import 'package:tremor/core/index.dart'
    show Failure, Result, Success, SyncMetadataStorage;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeEntity, EarthquakeRepository;

class EarthquakeApplicationService({
  required final EarthquakeRepository earthquakeRepository,
  required final SyncMetadataStorage syncMetadataStorage,
}) {
  static const _syncKey = 'earthquakes_feed';

  Future<bool> isSyncStale({int thresholdMinutes = 15}) async {
    final lastSync = await syncMetadataStorage.getLastSyncTime(_syncKey);
    if (lastSync == null) return true;

    return DateTime.now().difference(lastSync).inMinutes > thresholdMinutes;
  }

  Future<Result<List<EarthquakeEntity>, Failure>> syncEarthquakes() async {
    final result = await earthquakeRepository.getEarthquakes();

    if (result case Success()) {
      await syncMetadataStorage.saveLastSyncTime(_syncKey, DateTime.now());
    }

    return result;
  }
}
