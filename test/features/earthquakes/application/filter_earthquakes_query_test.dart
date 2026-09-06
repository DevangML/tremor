import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/index.dart'
    show Failure, FailureResult, Result, ServerFailure, Success;
import 'package:tremor/features/earthquakes/application/index.dart'
    show FilterEarthquakesQuery;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeRepository, EarthquakeTriageService;

final class FakeEarthquakeRepository implements EarthquakeRepository {
  new(this._result);

  final Result<List<EarthquakeEntity>, Failure> _result;

  @override
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes() async =>
      _result;

  @override
  Future<Result<void, Failure>> markAsTriaged(String id) async =>
      Success(null);
}

void main() {
  group('FilterEarthquakesQuery (CQRS Read Pipeline Tests)', () {
    final sampleQuakes = [
      EarthquakeEntity(
        id: 'q1',
        mag: 6.5,
        place: 'Northern California',
        time: DateTime.utc(2026, 9, 6, 12),
        coordinates: (lat: 40.5, lng: -124.5),
      ),
      EarthquakeEntity(
        id: 'q2',
        mag: 4,
        place: 'Central California',
        time: DateTime.utc(2026, 9, 6, 10),
        coordinates: (lat: 36.5, lng: -120.5),
      ),
      EarthquakeEntity(
        id: 'q3',
        mag: 2.5,
        place: 'Nevada Border',
        time: DateTime.utc(2026, 9, 6, 8),
        coordinates: (lat: 38, lng: -118),
      ),
    ];

    const triageService = EarthquakeTriageService();

    test('filters earthquakes by minimum magnitude', () async {
      final repo = FakeEarthquakeRepository(Success(sampleQuakes));
      final query = FilterEarthquakesQuery(
        repository: repo,
        triageService: triageService,
      );

      final result = await query(minMagnitude: 4);

      switch (result) {
        case Success(:final value):
          expect(value.length, equals(2));
          expect(value.map((e) => e.id), containsAll(['q1', 'q2']));
          expect(value.any((e) => e.id == 'q3'), isFalse);
        case FailureResult():
          fail('Expected Success, got Failure');
      }
    });

    test(
      'filters earthquakes by radial distance from epicenter center',
      () async {
        final repo = FakeEarthquakeRepository(Success(sampleQuakes));
        final query = FilterEarthquakesQuery(
          repository: repo,
          triageService: triageService,
        );

        // Center near Northern California
        final result = await query(
          center: (lat: 40.5, lng: -124.5),
          maxRadiusKm: 150,
        );

        switch (result) {
          case Success(:final value):
            expect(value.length, equals(1));
            expect(value.first.id, equals('q1'));
          case FailureResult():
            fail('Expected Success, got Failure');
        }
      },
    );

    test('propagates repository failures directly', () async {
      final repo = FakeEarthquakeRepository(
        FailureResult(ServerFailure('Timeout', 408)),
      );
      final query = FilterEarthquakesQuery(
        repository: repo,
        triageService: triageService,
      );

      final result = await query(minMagnitude: 3);

      switch (result) {
        case Success():
          fail('Expected Failure, got Success');
        case FailureResult(:final value):
          expect(value.message, equals('Timeout'));
          expect(value.code, equals(408));
      }
    });
  });
}
