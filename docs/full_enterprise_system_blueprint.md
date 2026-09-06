# Master Blueprint: The Complete End-to-End Enterprise Architecture of Tremor

**Engineering Standard:** Tier-1 Staff / Principal Mobile Systems Architect  
**Paradigm:** Clean Architecture + CQRS + Domain-Driven Design (DDD) + Unidirectional Data Flow (UDF)  
**Language & Engine Baseline:** Dart 3.13.0 (Stable) • Flutter 3.47.0 (Stable) • Impeller Rendering Pipeline  

---

## 1. The Global Architecture & Layer Invariants

Every single box from the architectural specifications is mapped to a dedicated responsibility and file path.

```
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 0. COMPOSITION ROOT & LIFECYCLE ("Accessories")                                        │
│    App Bootstrap • DI (Service Locator) • Environment Config • Router • main.dart      │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ wires runtime implementations
                                            ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 1. PRESENTATION LAYER ("The Interactive Face")                                         │
│    UI Actions • Screens • Widgets • BLoC/Cubit • Presentation Models • UI Mappers      │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ dispatches intent / triggers
                                            ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 2. APPLICATION LAYER ("The Workflow Conductor & CQRS Engine")                          │
│    Queries (Reads) • Commands (Writes) • Application Services • Workflow Orchestrators │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ coordinates & passes data
                                            ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 3. DOMAIN LAYER ("The Invariant Business Truths - Pure Dart")                          │
│    Entities • Value Objects • Invariants • Domain Services • Gateways • Domain Events  │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            ▲ implemented by contracts
                                            │
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 4. DATA LAYER ("The Translators & Storage Managers")                                   │
│    Repository Impls • Remote/Local Data Sources • DTOs • DTO Mappers • Cache Policies  │
└───────────────────────────────────────────┬────────────────────────────────────────────┘
                                            │ consumes raw I/O
                                            ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 5. INFRASTRUCTURE LAYER ("The Concrete Hardware & External World")                    │
│    Dio HTTP Client • SQLite/Drift Storage • Platform Channels (Haptic Motor/Sensors)   │
└────────────────────────────────────────────────────────────────────────────────────────┘
                                            │
                                            ▼
┌────────────────────────────────────────────────────────────────────────────────────────┐
│ 6. CROSS-CUTTING CONCERNS ("Tooling & Observability")                                 │
│    Structured Logging • Analytics Tracking • Secure Token Vault • Theme Design System │
└────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Exhaustive Layer-by-Layer Inventory

### Layer 0: Composition Root & App Lifecycle (`lib/app/`)
*Answers: "How is the application instantiated, configured, and wired before first frame?"*
1. **`app/bootstrap/bootstrap.dart`**: Global error zone interception (`PlatformDispatcher.onError`), logging initialization, orientation locking, and handing off to `runApp()`.
2. **`app/di/service_locator.dart`**: Dependency injection container. Pure constructor injection wiring concrete Data layer repositories and gateways into Application use cases.
3. **`app/config/env_config.dart`**: Environment variables (Dev / Staging / Prod endpoints, timeout thresholds).
4. **`app/router/app_router.dart`**: Decoupled declarative navigation avoiding context-dependent routing antipatterns.
5. **`main.dart`**: Minimalist bootstrap kickoff.

### Layer 1: Presentation Layer (`lib/features/earthquakes/presentation/`)
*Answers: "How does the user interact with the app, and how are pixels formatted?"*
1. **`bloc/earthquake_bloc.dart`**: State Controller managing event-to-state stream processing.
2. **`bloc/earthquake_state.dart`**: Dart 3 `sealed class` defining exhaustive UI states (`Initial`, `Loading`, `Loaded`, `Error`).
3. **`bloc/earthquake_event.dart`**: Sealed UI action triggers.
4. **`models/earthquake_card_ui_model.dart`**: Presentation-only model. Contains pre-computed display values (formatted date string, badge hex color, human-readable distance). **Guarantees widgets do zero string formatting or business calculations.**
5. **`mappers/earthquake_presentation_mapper.dart`**: Pure translator mapping Domain `EarthquakeEntity` $\rightarrow$ `EarthquakeCardUiModel`.
6. **`pages/earthquake_feed_page.dart`**: Screen coordinating custom Slivers, AppBar, and list virtualization.
7. **`widgets/magnitude_badge_widget.dart`**: Dedicated widget utilizing `CustomPainter` for 120 FPS magnitude ring rendering.

### Layer 2: Application Layer (`lib/features/earthquakes/application/`)
*Answers: "What operations should happen, in what order, and what workflows are executed?"*
1. **`queries/get_earthquakes_query.dart`**: Atomic CQRS Read. Calls domain repository contract, returns filtered entities.
2. **`commands/triage_earthquake_command.dart`**: Atomic CQRS Write. Marks an earthquake as reviewed/triaged in local storage.
3. **`services/earthquake_application_service.dart`**: Coordinates multi-repository interactions (e.g., syncing remote feed with local cache).
4. **`orchestrators/emergency_alert_orchestrator.dart`**: The Master Workflow Conductor:
   - Executes `GetEarthquakesQuery`.
   - Passes data to Domain `EarthquakeTriageService` for Haversine distance math.
   - If severe earthquake in user radius: Triggers `HapticGateway` and dispatches `TriageEarthquakeCommand`.
   - Emits clean result back to BLoC.

### Layer 3: Domain Layer (`lib/features/earthquakes/domain/`)
*Answers: "What is physically and mathematically true about an earthquake, independent of any app or database?"*
1. **`entities/earthquake_entity.dart`**: Pure Dart core aggregate with Named Record `Coordinates`.
2. **`value_objects/magnitude.dart`**: Dart 3.3 Zero-cost `extension type` enforcing magnitude invariants ($[0.0, 10.0]$).
3. **`value_objects/geo_boundary.dart`**: Typed geographic radius value object.
4. **`services/earthquake_triage_service.dart`**: Pure trigonometric Haversine distance & clustering algorithms. Zero external imports.
5. **`gateways/haptic_gateway.dart`**: Hardware vibration contract (`abstract interface class`).
6. **`events/earthquake_domain_events.dart`**: Sealed domain facts emitted when critical business invariants occur (`MajorTremorDetectedEvent`).
7. **`repositories/earthquake_repository.dart`**: Pure contract returning `Future<Result<List<EarthquakeEntity>, Failure>>`.

### Layer 4: Data Layer (`lib/features/earthquakes/data/`)
*Answers: "How is external wire data translated, cached, and managed?"*
1. **`models/earthquake_dto.dart`**: Freezed + json_serializable model mirroring external GeoJSON schema.
2. **`mappers/earthquake_dto_mapper.dart`**: Dedicated bidirectional mapper translating DTO $\leftrightarrow$ Domain Entity.
3. **`datasources/earthquake_remote_data_source.dart`**: Interface and implementation for USGS REST API.
4. **`datasources/earthquake_local_data_source.dart`**: Interface and implementation for in-memory / disk caching.
5. **`repositories/earthquake_repository_impl.dart`**: Concrete repository fulfilling the Domain contract. Coordinates remote and local data sources, maps DTOs to Entities, and returns `Result`.

### Layer 5: Infrastructure Layer (`lib/core/`)
*Answers: "Which concrete technologies talk to the outside world and the device hardware?"*
1. **`network/dio_client.dart`**: Configured HTTP engine with interceptors, timeouts, and auth headers.
2. **`hardware/platform_haptic_driver.dart`**: Implements Domain `HapticGateway` using native platform channels / Flutter services.

### Layer 6: Cross-Cutting Concerns (`lib/core/`)
*Answers: "How do we observe, secure, and style the application across all layers?"*
1. **`logging/app_logger.dart`**: Structured JSON logging.
2. **`analytics/analytics_tracker.dart`**: Telemetry dispatch interface.
3. **`security/secure_vault.dart`**: `final class` protecting encryption keys and sensitive tokens.
4. **`design_system/tremor_theme.dart`**: Centralized color tokens, typography scales, and animation curves.

---

## 3. The Grand Execution Path: One File At A Time

You write every single line of code. I explain the exact computer science concept, Dart 3.13 syntax, and interview defense for each file.

We will proceed strictly in dependency order:
```
PHASE 1: Domain Expansion (Value Objects -> Domain Service -> Gateway Contract -> Domain Events)
PHASE 2: Application Expansion (Query -> Command -> Application Service -> Workflow Orchestrator)
PHASE 3: Data & Infrastructure (DTO -> DTO Mapper -> Remote DataSource -> Repository Impl -> Haptic Driver)
PHASE 4: Cross-Cutting Tools (Logger -> Secure Vault -> Design Tokens)
PHASE 5: Presentation Layer (UI Model -> UI Mapper -> BLoC State/Event -> BLoC -> CustomPainter -> Page)
PHASE 6: Composition & Bootstrap (DI Container -> Bootstrap -> Main)
```
