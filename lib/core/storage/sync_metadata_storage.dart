abstract interface class SyncMetadataStorage {
  Future<DateTime?> getLastSyncTime(String key);
  Future<void> saveLastSyncTime(String key, DateTime timestamp);
}
