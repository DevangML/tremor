enum Environment { dev, staging, prod }

final class EnvConfig {
  const new({
    required this.environment,
    required this.apiBaseUrl,
    required this.enableDetailedLogs,
  });

  final Environment environment;
  final String apiBaseUrl;
  final bool enableDetailedLogs;

  static const EnvConfig dev = EnvConfig(
    environment: Environment.dev,
    apiBaseUrl: 'https://earthquake.usgs.gov/earthquakes/feed/v1.0',
    enableDetailedLogs: true,
  );
}
