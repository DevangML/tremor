import 'package:tremor/app/index.dart' show EnvConfig;
import 'package:tremor/core/index.dart'
    show
        AnalyticsTracker,
        AppLogger,
        ConsoleAnalyticsTracker,
        HapticGateway,
        InMemorySyncStorage,
        PlatformHapticDriver,
        SecureVault,
        SyncMetadataStorage;
import 'package:tremor/features/earthquakes/application/index.dart'
    show
        EarthquakeApplicationService,
        EmergencyAlertOrchestrator,
        GetEarthquakeQuery,
        TriageEarthquakeCommand;
import 'package:tremor/features/earthquakes/data/index.dart'
    show
        EarthquakeDtoMapper,
        EarthquakeRemoteDataSource,
        EarthquakeRepositoryImpl,
        MockEarthquakeRemoteDataSource;
import 'package:tremor/features/earthquakes/domain/index.dart'
    show EarthquakeRepository, EarthquakeTriageService;
import 'package:tremor/features/earthquakes/presentation/index.dart'
    show EarthquakePresentationMapper;

/// The Central Composition Root Container (Zone 2).
/// Instantiates all singletons and wires them into Domain contracts top-down.
final class ServiceLocator {
  new _();

  static final ServiceLocator instance = ServiceLocator._();

  // Core & Infrastructure
  late EnvConfig envConfig;
  late AppLogger logger;
  late AnalyticsTracker analytics;
  late SecureVault secureVault;
  late HapticGateway hapticGateway;
  late SyncMetadataStorage syncStorage;

  // Data Layer
  late EarthquakeRemoteDataSource remoteDataSource;
  late EarthquakeDtoMapper dtoMapper;
  late EarthquakeRepository earthquakeRepository;

  // Domain Services
  late EarthquakeTriageService triageService;

  // Application Layer (CQRS)
  late GetEarthquakeQuery getEarthquakeQuery;
  late TriageEarthquakeCommand triageEarthquakeCommand;
  late EarthquakeApplicationService applicationService;
  late EmergencyAlertOrchestrator emergencyAlertOrchestrator;

  // Presentation Mappers
  late EarthquakePresentationMapper presentationMapper;

  void initialize({required EnvConfig config}) {
    envConfig = config;
    logger = const AppLogger();
    analytics = const ConsoleAnalyticsTracker();
    secureVault = SecureVault('usgs_tremor_secret_token_2026');
    hapticGateway = const PlatformHapticDriver();
    syncStorage = InMemorySyncStorage();

    // Data Wiring
    remoteDataSource = const MockEarthquakeRemoteDataSource();
    dtoMapper = const EarthquakeDtoMapper();
    earthquakeRepository = EarthquakeRepositoryImpl(
      remoteDataSource: remoteDataSource,
      mapper: dtoMapper,
    );

    // Domain Services
    triageService = const EarthquakeTriageService();

    // Application Layer Wiring
    getEarthquakeQuery = GetEarthquakeQuery(earthquakeRepository);
    triageEarthquakeCommand = TriageEarthquakeCommand(earthquakeRepository);
    applicationService = EarthquakeApplicationService(
      earthquakeRepository: earthquakeRepository,
      syncMetadataStorage: syncStorage,
    );
    emergencyAlertOrchestrator = EmergencyAlertOrchestrator(
      query: getEarthquakeQuery,
      command: triageEarthquakeCommand,
      hapticGateway: hapticGateway,
      triageService: triageService,
    );

    // Presentation Layer Wiring
    presentationMapper = const EarthquakePresentationMapper();
  }
}
