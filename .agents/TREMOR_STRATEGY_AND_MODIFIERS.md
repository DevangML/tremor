# Tremor Project Strategy & L2 Architecture State

## Core Vision & Goal
- **Target**: L2/Mid-Senior Flutter Developer Interview (LTIMindtree / LTTS).
- **Execution Style**: The user types the code to build physical muscle memory and deep understanding. The AI provides architecture, syntax, under-the-hood engine/Dart VM concepts, and reviews.
- **Architecture**: Enterprise 4-6 Layer Clean Architecture (Feature-first with layers):
  - `presentation/` (Widgets, Pages, BLoC/Cubit, UI States)
  - `application/` (Use Cases / Interactors)
  - `domain/` (Pure Dart Entities, Repository Contracts, Failures)
  - `data/` (DTOs via Freezed, Mappers, Repository Implementations, Data Sources)
  - `core/` (Network, Security, Error, Storage)

---

## The Dart 3 Class Modifiers Strategy (Mandatory Interview Coverage)
Every major Dart 3 modifier has an explicit architectural home in Tremor:

1. **`abstract interface class`**:
   - Location: `lib/features/earthquakes/domain/repositories/earthquake_repository.dart`
   - Purpose: Pure contract with zero implementation. Forces the data layer to implement every method; blocks `extends` and instantiation.
2. **`abstract class`**:
   - Location: `lib/core/error/failures.dart`
   - Purpose: Incomplete base template with shared fields (`message`, `code`) inherited via `extends`.
3. **`final class`**:
   - Location: `lib/core/security/secure_vault.dart`
   - Purpose: Closed to external subtyping (`extends` and `implements` blocked). Protects sensitive cryptographic keys/storage.
4. **`base class`**:
   - Location: `lib/core/network/base_api_client.dart`
   - Purpose: Forces inheritance via `extends`, strictly forbids `implements` so logging/auth headers cannot be bypassed.
5. **`sealed class`**:
   - Location: `lib/features/earthquakes/presentation/bloc/earthquake_state.dart`
   - Purpose: Known, closed set of subtypes in one file. Enables compiler-enforced exhaustive pattern matching in UI `switch` expressions.

---

## Current Build Progress
- [x] **Setup & Inception**: Initialized in `~/Desktop/tremor`, configured `very_good_analysis`, `freezed`, `json_serializable`, `flutter_bloc`.
- [x] **Domain Entity**: `lib/features/earthquakes/domain/entities/earthquake_entity.dart` written in pure Dart (with `const` constructor first).
- [ ] **Next Active Step**:
  1. `lib/features/earthquakes/domain/repositories/earthquake_repository.dart` (`abstract interface`)
  2. `lib/core/error/failures.dart` (`abstract`)
  3. `lib/core/security/secure_vault.dart` (`final`)
  4. `lib/core/network/base_api_client.dart` (`base`)
  5. `lib/features/earthquakes/presentation/bloc/earthquake_state.dart` (`sealed`)
  6. Use case (`application/usecases/get_earthquakes_usecase.dart`)
  7. Data layer DTO & Repo Implementation
  8. Presentation (BLoC & UI with Slivers / CustomPainter)

---

## Dart 3.13 Standards & Explicit Result Architecture (Locked In)
- **Dart SDK Target**: Dart 3.13.0 (stable).
- **Primary Constructor Syntax**:
  - In Dart 3.13+, use header primary constructors with `final` declaring parameters:
    ```dart
    abstract class Failure(final String message, [final int? code]);
    ```
- **Explicit Error Boundary**:
  - Instead of letting exceptions leak through `Future<List<EarthquakeEntity>>`, use a native sealed `Result<S, F>`:
    ```dart
    abstract interface class EarthquakeRepository {
      Future<Result<List<EarthquakeEntity>, Failure>> getEarthquakes();
    }
    ```
  - Eliminates legacy `dartz`/`Either` dependencies and forces exhaustive pattern matching in Use Cases and BLoCs.
