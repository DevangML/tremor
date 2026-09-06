import 'package:tremor/core/error/failures.dart';
import 'package:tremor/core/result/result.dart';
import 'package:tremor/core/storage/sync_metadata_storage.dart';
import 'package:tremor/features/earthquakes/domain/entities/earthquake_entity.dart';
import 'package:tremor/features/earthquakes/domain/repositories/earthquake_repository.dart';

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
