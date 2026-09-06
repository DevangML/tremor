import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/index.dart'
    show Failure, FailureResult, HapticGateway, Result, ServerFailure, Success;
import 'package:tremor/features/earthquakes/application/index.dart'
    show HazardAssessmentOrchestrator;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show
        EarthquakeEntity,
        EarthquakeRepository,
        EarthquakeTriageService,
        HazardLevel,
        SecondaryHazardPredictedEvent;

final class FakeRepo implements EarthquakeRepository {
  new(this._result);
  final Result<List<EarthquakeEntity>, Failure> _result;

  @override
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes() async =>
      _result;

  @override
  Future<Result<void, Failure>> markAsTriaged(String id) async =>
      Success(null);
}

final class SpyHapticGateway implements HapticGateway {
  bool alertTriggered = false;

  @override
  Future<void> triggerSevereAlertHaptic() async {
    alertTriggered = true;
  }
}

void main() {
  group(
    'HazardAssessmentOrchestrator (Application Saga / CQRS Workflow)',
    () {
      const triageService = EarthquakeTriageService();

      test(
        'assesses shallow high-mag tremor, triggers haptics and yields event',
        () async {
        final haptics = SpyHapticGateway();
        final severeQuake = EarthquakeEntity(
          id: 'tsunami-1',
          mag: 7.4,
          place: 'Off coast of Honshu, Japan',
          time: DateTime.utc(2026, 9, 6),
          coordinates: (lat: 38, lng: 142.5),
        );

        final repo = FakeRepo(
          Success<List<EarthquakeEntity>, Failure>([severeQuake]),
        );
        final orchestrator = HazardAssessmentOrchestrator(
          repository: repo,
          triageService: triageService,
          hapticGateway: haptics,
        );

      final events = <SecondaryHazardPredictedEvent>[];
      final result = await orchestrator.assessRegionalRisks(
        epicenter: (lat: 38, lng: 142.5),
        radiusKm: 200,
        focalDepthKm: 15,
        onHazardIdentified: events.add,
      );

      expect(haptics.alertTriggered, isTrue);
      expect(events.length, equals(1));
      expect(events.first.hazardLevel, equals(const HazardLevel(4)));
      expect(events.first.hazardLevel.isTsunamiRisk, isTrue);
      expect(events.first.earthquake.id, equals('tsunami-1'));

      switch (result) {
        case Success(:final value):
          expect(value.length, equals(1));
        case FailureResult():
          fail('Expected Success, got Failure');
      }
    });

    test(
      'does not trigger severe haptic when quakes are low magnitude',
      () async {
        final haptics = SpyHapticGateway();
        final mildQuake = EarthquakeEntity(
          id: 'mild-1',
          mag: 3.1,
          place: 'Bay Area',
          time: DateTime.utc(2026, 9, 6),
          coordinates: (lat: 37.7, lng: -122.4),
        );

        final repo = FakeRepo(
          Success<List<EarthquakeEntity>, Failure>([mildQuake]),
        );
        final orchestrator = HazardAssessmentOrchestrator(
          repository: repo,
          triageService: triageService,
          hapticGateway: haptics,
        );

        final events = <SecondaryHazardPredictedEvent>[];
        final result = await orchestrator.assessRegionalRisks(
          epicenter: (lat: 37.7, lng: -122.4),
          radiusKm: 100,
          focalDepthKm: 10,
          onHazardIdentified: events.add,
        );

        expect(haptics.alertTriggered, isFalse);
        expect(events.length, equals(1));
        expect(events.first.hazardLevel, equals(const HazardLevel(1)));
        expect(events.first.hazardLevel.isTsunamiRisk, isFalse);

        switch (result) {
          case Success(:final value):
            expect(value.length, equals(1));
          case FailureResult():
            fail('Expected Success, got Failure');
        }
      },
    );

    test('propagates failure when repository fails', () async {
      final haptics = SpyHapticGateway();
      final repo = FakeRepo(
        FailureResult<List<EarthquakeEntity>, Failure>(
          ServerFailure('Gateway Error', 502),
        ),
      );
      final orchestrator = HazardAssessmentOrchestrator(
        repository: repo,
        triageService: triageService,
        hapticGateway: haptics,
      );

      final result = await orchestrator.assessRegionalRisks(
        epicenter: (lat: 37.7, lng: -122.4),
        radiusKm: 100,
        focalDepthKm: 10,
      );

      expect(haptics.alertTriggered, isFalse);
      switch (result) {
        case Success():
          fail('Expected Failure, got Success');
        case FailureResult(:final value):
          expect(value.message, equals('Gateway Error'));
          expect(value.code, equals(502));
      }
    });
  });
}
