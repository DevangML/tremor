import 'package:tremor/app/config/env_config.dart';
import 'package:tremor/core/analytics/analytics_tracker.dart';
import 'package:tremor/core/hardware/haptic_gateway.dart';
import 'package:tremor/core/hardware/platform_haptic_driver.dart';
import 'package:tremor/core/logging/app_logger.dart';
import 'package:tremor/core/security/secure_vault.dart';
import 'package:tremor/core/storage/in_memory_sync_storage.dart';
import 'package:tremor/core/storage/sync_metadata_storage.dart';
import 'package:tremor/features/earthquakes/application/commands/triage_earthquake_command.dart';
import 'package:tremor/features/earthquakes/application/orchestrators/emergency_alert_orchestrator.dart';
import 'package:tremor/features/earthquakes/application/queries/get_earthquake_query.dart';
import 'package:tremor/features/earthquakes/application/services/earthquake_application_service.dart';
import 'package:tremor/features/earthquakes/data/datasources/earthquake_remote_data_source.dart';
import 'package:tremor/features/earthquakes/data/mappers/earthquake_dto_mapper.dart';
import 'package:tremor/features/earthquakes/data/repositories/earthquake_repository_impl.dart';
import 'package:tremor/features/earthquakes/domain/repositories/earthquake_repository.dart';
import 'package:tremor/features/earthquakes/domain/services/earthquake_triage_service.dart';
import 'package:tremor/features/earthquakes/presentation/mappers/earthquake_presentation_mapper.dart';

/// The Central Composition Root Container (Zone 2).
/// Instantiates all singletons and wires them into Domain contracts top-down.
final class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  // Core & Infrastructure
  late final EnvConfig envConfig;
  late final AppLogger logger;
  late final AnalyticsTracker analytics;
  late final SecureVault secureVault;
  late final HapticGateway hapticGateway;
  late final SyncMetadataStorage syncStorage;

  // Data Layer
  late final EarthquakeRemoteDataSource remoteDataSource;
  late final EarthquakeDtoMapper dtoMapper;
  late final EarthquakeRepository earthquakeRepository;

  // Domain Services
  late final EarthquakeTriageService triageService;

  // Application Layer (CQRS)
  late final GetEarthquakeQuery getEarthquakeQuery;
  late final TriageEarthquakeCommand triageEarthquakeCommand;
  late final EarthquakeApplicationService applicationService;
  late final EmergencyAlertOrchestrator emergencyAlertOrchestrator;

  // Presentation Mappers
  late final EarthquakePresentationMapper presentationMapper;

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
