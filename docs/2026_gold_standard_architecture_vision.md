# Tremor 2026 Gold Standard Architecture Specification
## The "Two-Zone" Hybrid Clean Architecture + CQRS + DDD + Compile-Time DI Engine

**System Role:** Tier-1 Lead / Staff Mobile Systems Architect  
**Evaluation Standard:** L2 / Senior Flutter Engineering Panel (LTIMindtree / LTTS)  
**Target Platform:** Flutter 3.47.0 (Stable) • Dart SDK 3.13.0 (Stable) • Impeller Native GPU Pipeline  

---

## 1. The Core Architectural Philosophy: The "Two-Zone" Paradigm

The fatal flaw of legacy Flutter projects was attempting to force a single Dependency Injection tool or State paradigm across the entire application:
- Using `GetIt` inside Use Cases and Repositories created the **Service Locator Antipattern**, turning compile-time safety into runtime crashes and destroying pure Dart VM unit testability.
- Using pure Constructor Injection down into 20 layers of UI widgets created unbearable **Constructor Drilling Boilerplate** and manual lifecycle leaks.

The **2026 Gold Standard** completely resolves this with strict **Zone Separation**:

```
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ZONE 1: THE HERMETIC BUSINESS CORE (Domain & Application CQRS Layers)                                   │
│ Pattern: STRICT CONSTRUCTOR INJECTION (Zero DI Frameworks • Zero Ambient State • Pure Dart 3.13)       │
│                                                                                                         │
│ class GetEarthquakesQuery(final EarthquakeRepository _repository);                                      │
│ class TriageEarthquakeCommand(final EarthquakeRepository _repository);                                  │
│ class EmergencyAlertOrchestrator(final GetEarthquakesQuery query, ...);                                 │
│                                                                                                         │
│ 🛡️ Invariant: Classes in this zone have ZERO knowledge of GetIt, Riverpod, or Flutter.                  │
│ 🏆 Testing: 100% testable in pure Dart VM in 2ms. Pass `MockRepository()` directly.                     │
│ 🏆 Safety: It is physically impossible to instantiate any class without providing its dependencies.    │
└────────────────────────────────────────────────────┬────────────────────────────────────────────────────┘
                                                     │
                                                     │ [COMPILE-TIME BOUNDARY]
                                                     │ The Composition Root bridges the zones
                                                     ▼
┌─────────────────────────────────────────────────────────────────────────────────────────────────────────┐
│ ZONE 2: THE RUNTIME & PRESENTATION GRAPH (Data, Infrastructure, Composition Root, UI)                   │
│ Pattern: COMPILE-TIME RESOLVED HIERARCHICAL DI CONTAINER + SCOPED LIFECYCLE MANAGEMENT                 │
│                                                                                                         │
│ - Composition Root (`app/di/`): Registers implementations typed against Domain contracts.               │
│ - Hierarchical Scoping: Features push memory scopes on navigation and drop scopes on route exit.        │
│ - Presentation (`presentation/`): Top-level Pages pull BLoCs from the Scoped Container; widgets below   │
│   use `context.read<EarthquakeBloc>()` without constructor drilling.                                    │
│                                                                                                         │
│ 🏆 Memory: Automatic Garbage Collection via Scope Disposal when routes unmount.                        │
│ 🏆 Zero Drilling: UI widgets never pass dependencies manually through constructors.                    │
└─────────────────────────────────────────────────────────────────────────────────────────────────────────┘
```

---

## 2. Master System Blueprint: Every File & Box Mapped

```
tremor/
├── lib/
│   ├── app/                                  <--- ZONE 2: COMPOSITION ROOT & LIFECYCLE
│   │   ├── bootstrap/
│   │   │   └── bootstrap.dart                # Global error zone, telemetry, orientation, runApp
│   │   ├── di/
│   │   │   ├── service_locator.dart          # Central container registering Repos/Gateways to Domain contracts
│   │   │   └── feature_scopes.dart           # Hierarchical lifecycle scope manager (Push/Drop scopes)
│   │   ├── config/
│   │   │   └── env_config.dart               # Environment configurations (Dev / Staging / Prod)
│   │   └── router/
│   │       └── app_router.dart               # Declarative navigation wiring
│   │
│   ├── core/                                 <--- ZONE 2: CROSS-CUTTING INFRASTRUCTURE & TOOLS
│   │   ├── error/
│   │   │   └── failures.dart                 # Dart 3.13 zero-body super primary constructors
│   │   ├── result/
│   │   │   └── result.dart                   # Native Dart 3 sealed class Result<S, F>()
│   │   ├── network/
│   │   │   └── base_api_client.dart          # Base class enforcing auth & telemetry logging
│   │   ├── security/
│   │   │   └── secure_vault.dart             # Final class closed to subtyping for token encryption
│   │   └── design_system/
│   │       └── tremor_theme.dart             # Centralized design tokens and severity color ramps
│   │
│   └── features/
│       └── earthquakes/
│           ├── domain/                       <--- ZONE 1: HERMETIC DOMAIN CORE (Pure Dart)
│           │   ├── entities/
│           │   │   └── earthquake_entity.dart# Pure entity + Named Record Coordinates
│           │   ├── value_objects/
│           │   │   └── magnitude.dart        # Zero-cost extension type const Magnitude(double)
│           │   ├── services/
│           │   │   └── earthquake_triage_service.dart # Pure Haversine trigonometry math
│           │   ├── events/
│           │   │   └── earthquake_domain_events.dart  # Sealed domain facts (MajorTremorDetectedEvent)
│           │   ├── gateways/
│           │   │   └── haptic_gateway.dart   # Abstract interface for device vibration
│           │   └── repositories/
│           │       └── earthquake_repository.dart # Abstract interface returning Result
│           │
│           ├── application/                  <--- ZONE 1: HERMETIC CQRS & ORCHESTRATION (Pure Dart)
│           │   ├── queries/
│           │   │   └── get_earthquakes_query.dart     # Atomic CQRS Read (constructor injected)
│           │   ├── commands/
│           │   │   └── triage_earthquake_command.dart # Atomic CQRS Write (constructor injected)
│           │   ├── services/
│           │   │   └── earthquake_application_service.dart # Multi-source coordination
│           │   └── orchestrators/
│           │       └── emergency_alert_orchestrator.dart   # Workflow conductor linking Query + Math + Command
│           │
│           ├── data/                         <--- ZONE 2: DATA ADAPTERS & TRANSLATIONS
│           │   ├── models/
│           │   │   └── earthquake_dto.dart   # Freezed + json_serializable GeoJSON DTO
│           │   ├── mappers/
│           │   │   └── earthquake_dto_mapper.dart # Bidirectional DTO <-> Entity translator
│           │   ├── datasources/
│           │   │   ├── earthquake_remote_data_source.dart # Dio REST client
│           │   │   └── earthquake_local_data_source.dart  # In-memory / cache storage
│           │   └── repositories/
│           │       └── earthquake_repository_impl.dart    # Implements Domain repository contract
│           │
│           └── presentation/                 <--- ZONE 2: PRESENTATION & IMPELLER RENDERING
│               ├── models/
│               │   └── earthquake_card_ui_model.dart # UI-only model (pre-computed colors & dates)
│               ├── mappers/
│               │   └── earthquake_presentation_mapper.dart # Maps Entity -> UI Model
│               ├── bloc/
│               │   ├── earthquake_bloc.dart  # State controller orchestrating events to states
│               │   ├── earthquake_event.dart # Sealed UI action triggers
│               │   └── earthquake_state.dart # Sealed UI states for exhaustive pattern matching
│               ├── widgets/
│               │   └── magnitude_badge_widget.dart # CustomPainter vector rendering for 120 FPS
│               └── pages/
│                   └── earthquake_feed_page.dart   # Viewport with Slivers and lazy virtualization
```

---

## 3. The 4 Golden Invariants of the 2026 Vision

### Invariant 1: Compile-Time Constructor Injection in Business Logic
No class in `domain/` or `application/` will ever access a global variable, `BuildContext`, or `service_locator`.
Every dependency is declared explicitly in the Dart 3.13 header primary constructor:
```dart
class EmergencyAlertOrchestrator({
  required final GetEarthquakesQuery query,
  required final TriageEarthquakeCommand command,
  required final HapticGateway hapticGateway,
  required final EarthquakeTriageService triageService,
});
```
*Result:* Writing a unit test for this orchestrator requires zero framework setup. You pass 4 mocks into the constructor, run the test in the pure Dart VM in 3 milliseconds, and get 100% deterministic assertions.

### Invariant 2: Scoped Memory Lifecycle in Presentation
When the user navigates into the Earthquake Monitor screen:
1. The app router activates the **`earthquake_feature` DI Scope**.
2. The concrete data sources, repositories, and BLoC instances are instantiated lazily.
3. When the user leaves the screen, the router calls `dropScope('earthquake_feature')`.
*Result:* Memory usage remains lean and deterministic. No lingering singletons or un-disposed streams eating battery in the background.

### Invariant 3: Zero Business Logic & Zero Formatting in Widgets
A Widget's only job is to translate state into `RenderObjects`:
- The Widget never calls `DateTime.parse()` or `DateFormat()`.
- The Widget never calculates `if (mag >= 5.0) Colors.red else Colors.orange`.
- The `EarthquakePresentationMapper` pre-computes all display formatting into an `EarthquakeCardUiModel`. The widget simply binds `Text(model.formattedTime)` and `CustomPaint(painter: MagnitudeRingPainter(model.badgeColor))`.

### Invariant 4: Impeller Native Rendering & Frame Budgets
All custom graphics (severity rings, shockwave pulses) are rendered via `CustomPainter` recording directly to the engine's `DisplayList`, skipping nested `Container` and `ClipOval` widget overhead. Overriding `shouldRepaint()` ensures that scrolling a 100-item feed consumes 0.0ms of layout time during parent rebuilds.

---

## 4. The L2 / Senior Architect Interview Defense Script

If asked: **"Why did you choose this architecture over simple BLoC + GetIt?"**

> *"In enterprise applications, standardizing on a single DI pattern creates a dilemma: using GetIt everywhere introduces hidden dependencies that degrade unit test isolation, while pure constructor injection down to UI widgets causes severe constructor drilling. We solve this by adopting the 2026 Two-Zone architecture: the Domain and Application layers enforce strict, framework-free Constructor Injection via Dart 3.13 primary constructors, guaranteeing pure Dart VM testability in milliseconds. The outer Composition Root and Presentation layers use scoped hierarchical lifecycle containers, eliminating widget constructor drilling while ensuring feature caches and BLoCs are automatically garbage-collected upon route exit."*
