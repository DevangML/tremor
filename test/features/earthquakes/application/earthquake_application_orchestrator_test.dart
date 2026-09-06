import 'package:flutter_test/flutter_test.dart';
import 'package:tremor/core/index.dart';
import 'package:tremor/features/earthquakes/application/index.dart';
import 'package:tremor/features/earthquakes/domain/index.dart';

final class SpyRepository implements EarthquakeRepository {
  new({required this.quakes, this.shouldFail = false});

  final List<EarthquakeEntity> quakes;
  final bool shouldFail;
  final List<String> triagedIds = [];

  @override
  Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes() async {
    if (shouldFail) {
      return FailureResult(ServerFailure('Repo Down'));
    }
    return Success(quakes);
  }

  @override
  Future<Result<void, Failure>> markAsTriaged(String id) async {
    triagedIds.add(id);
    return Success(null);
  }
}

final class SpyHapticGateway implements HapticGateway {
  int hapticCalls = 0;

  @override
  Future<void> triggerSevereAlertHaptic() async {
    hapticCalls++;
  }
}

void main() {
  group('EarthquakeApplicationService & EmergencyAlertOrchestrator', () {
    final quakes = [
      EarthquakeEntity(
        id: 'q-severe',
        mag: 6.5,
        place: 'Northern California',
        time: DateTime.now(),
        coordinates: (lat: 40.0, lng: -124.0),
      ),
      EarthquakeEntity(
        id: 'q-mild',
        mag: 3.1,
        place: 'Central California',
        time: DateTime.now(),
        coordinates: (lat: 36.0, lng: -120.0),
      ),
    ];

    test(
      'EarthquakeApplicationService syncs quakes and records timestamp',
      () async {
        final repo = SpyRepository(quakes: quakes);
        final syncStorage = InMemorySyncStorage();
        final appService = EarthquakeApplicationService(
          earthquakeRepository: repo,
          syncMetadataStorage: syncStorage,
        );

        expect(await appService.isSyncStale(), isTrue);

        final result = await appService.syncEarthquakes();
        expect(result, isA<Success<List<EarthquakeEntity>, Failure>>());
        expect(await appService.isSyncStale(), isFalse);
      },
    );

    test(
      'EarthquakeApplicationService returns FailureResult when repo fails',
      () async {
        final repo = SpyRepository(quakes: [], shouldFail: true);
        final syncStorage = InMemorySyncStorage();
        final appService = EarthquakeApplicationService(
          earthquakeRepository: repo,
          syncMetadataStorage: syncStorage,
        );

        final result = await appService.syncEarthquakes();
        expect(result, isA<FailureResult<List<EarthquakeEntity>, Failure>>());
      },
    );

    test(
      'EmergencyAlertOrchestrator triggers haptic & triages severe quake',
      () async {
        final repo = SpyRepository(quakes: quakes);
        final haptic = SpyHapticGateway();
        final orchestrator = EmergencyAlertOrchestrator(
          query: GetEarthquakeQuery(repo),
          command: TriageEarthquakeCommand(repo),
          hapticGateway: haptic,
          triageService: const EarthquakeTriageService(),
        );

        final result = await orchestrator.execute(
          userLocation: (lat: 40.1, lng: -124.1),
          alertRadiusKm: 50,
        );

        expect(result, isA<Success<List<EarthquakeEntity>, Failure>>());
        expect(haptic.hapticCalls, 1);
        expect(repo.triagedIds, contains('q-severe'));
      },
    );

    test(
      'EmergencyAlertOrchestrator forwards failure when query fails',
      () async {
        final repo = SpyRepository(quakes: [], shouldFail: true);
        final haptic = SpyHapticGateway();
        final orchestrator = EmergencyAlertOrchestrator(
          query: GetEarthquakeQuery(repo),
          command: TriageEarthquakeCommand(repo),
          hapticGateway: haptic,
          triageService: const EarthquakeTriageService(),
        );

        final result = await orchestrator.execute(
          userLocation: (lat: 40.1, lng: -124.1),
        );

        expect(result, isA<FailureResult<List<EarthquakeEntity>, Failure>>());
        expect(haptic.hapticCalls, 0);
      },
    );
  });
}
