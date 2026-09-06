import 'package:tremor/core/storage/sync_metadata_storage.dart';

final class InMemorySyncStorage implements SyncMetadataStorage {
  final Map<String, DateTime> _timestamps = {};

  @override
  Future<DateTime?> getLastSyncTime(String key) async => _timestamps[key];

  @override
  Future<void> saveLastSyncTime(String key, DateTime timestamp) async {
    _timestamps[key] = timestamp;
  }
}
