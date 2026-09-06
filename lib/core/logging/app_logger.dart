import 'dart:developer' as developer;

final class AppLogger {
  const new();

  void info(String message) {
    developer.log('[INFO] $message', name: 'Tremor');
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    developer.log(
      '[ERROR] $message',
      name: 'Tremor',
      error: error,
      stackTrace: stackTrace,
    );
  }
}
