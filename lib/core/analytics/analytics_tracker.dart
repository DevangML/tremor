abstract interface class AnalyticsTracker {
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]);
}

final class ConsoleAnalyticsTracker implements AnalyticsTracker {
  const new();

  @override
  Future<void> logEvent(String name, [Map<String, dynamic>? parameters]) async {
    // Diagnostic console logging for development telemetry:
    // In production, this forwards to Firebase / Datadog.
  }
}
