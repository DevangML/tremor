# Tremor Engineering Quality Constitution & Architectural Invariants

> **Status:** Active & Binding  
> **Author:** Winston (System Architect)  
> **Target Platform:** Dart 3.13.0+ / Flutter 3.47.0+  
> **Scope:** All features, core primitives, tests, and composition roots in Tremor.

---

## 1. Core Architectural Constitution (<200 LOC & Single Responsibility)

1. **Strict File Budget**: No production or test source file may exceed **200 lines of code**. Split by cohesive responsibility (Single Responsibility Principle), never by arbitrary line truncation.
2. **Reusability First**: Extract common domain primitives, presentation widgets, or test spies before creating duplicates.
3. **Additive Refactoring**: Refactors must never drop test counts or feature coverage.
4. **Zero Analyzer Warnings**: The project must strictly pass `flutter analyze` with 0 warnings, 0 errors, and 0 lints (`very_good_analysis` + `flutter_lints` compliant).
5. **100% Test Coverage Invariant**: Every handwritten production file must achieve **100.0% line test coverage**. No file is created without corresponding test suites.

---

## 2. Test-Driven Development (TDD) Protocol

For any new feature, bug fix, or scale-up capability:
1. **Red Phase (Test First)**: Author the test specification in `test/` defining the input/output boundaries, edge cases, error conditions, and state mutations before writing implementation code.
2. **Green Phase (Implementation)**: Write minimal, elegant production code strictly necessary to pass the test suite.
3. **Refactor Phase (Optimization & Quality)**: Polish formatting, ensure line lengths $\le 80$ chars, optimize constructor constness, and verify `100%` coverage.

---

## 3. Two-Zone Clean Architecture, CQRS & DDD

Tremor is divided into two distinct zones with unidirectional dependency rules:

```
[Zone 2: Presentation & Data] ---> Depends On ---> [Zone 1: Core Domain & CQRS Application]
```

### Zone 1: Pure Core (Zero Flutter Framework Coupling)
- **Domain Layer (`lib/features/<feature>/domain/`)**:
  - Contains enterprise Entities, Value Objects, Domain Events, and Repository Interfaces.
  - No imports of `package:flutter`, `package:flutter_bloc`, or JSON serialization libraries.
  - Mathematical and business logic live in pure domain services (e.g., trigonometric calculations).
- **Application Layer (`lib/features/<feature>/application/`)**:
  - **CQRS Segregation**:
    - **Queries**: Read-only pipelines returning domain entities or views with business filters.
    - **Commands**: Write-only transactions executing domain state modifications.
  - **Orchestrators (Sagas)**: Multi-step cross-boundary workflows coordinating queries, commands, domain services, and hardware gateways.

### Zone 2: Infrastructure & Framework
- **Data Layer (`lib/features/<feature>/data/`)**:
  - Translates remote protocols, local databases, and DTOs into Domain Entities via explicit Mappers.
  - Uses Freezed + `json_serializable` for immutable wire models.
- **Presentation Layer (`lib/features/<feature>/presentation/`)**:
  - BLoC (`flutter_bloc`) as the explicit unidirectional state machine.
  - Viewport-based slivers (`CustomScrollView`, `SliverAppBar`) and canvas-level rendering via `CustomPainter` with fine-grained `shouldRepaint()` caching.

---

## 4. Modern Dart 3.13+ Syntax Standard

1. **Extension Types**: Use `extension type const ValueObject(primitive) implements primitive` for zero-cost runtime allocations with strict compile-time invariants.
2. **Sealed Class Hierarchies**: Use `sealed class Event()` and `sealed class State()` to guarantee exhaustive compile-time pattern matching with `switch` expressions without fallback `default` branches.
3. **Named Records**: Use named records `({double lat, double lng})` for lightweight geometric and coordinate tuples.
4. **Primary & Unnamed Constructors**:
   - Utilize Dart 3.13 zero-body constructors with terminating semicolons where possible: `abstract class Failure(final String message);`.
   - Prefer unnamed constructors with modern `new(...)` syntax where appropriate: `final class ServiceLocator { new _(); }`.
5. **Pattern Matching & Destructuring**: Leverage object pattern destructuring in switch expressions:
   ```dart
   return switch (result) {
     Success(:final value) => _handleSuccess(value),
     FailureResult(:final value) => _handleFailure(value),
   };
   ```

---

## 5. Barrel Index (`index.dart`) Standards

1. Every layer (`core/`, `app/`, `domain/`, `application/`, `data/`, `presentation/`, and feature root) must provide a unified `index.dart` barrel file.
2. **Explicit `show` Clauses**: Consumer files must import through the barrel using explicit, selective `show` clauses:
   ```dart
   import 'package:tremor/core/index.dart' show Failure, Result, Success;
   import 'package:tremor/features/earthquakes/domain/index.dart'
       show EarthquakeEntity, EarthquakeRepository;
   ```
3. Granular direct file imports (e.g., `import '../../domain/entities/foo.dart'`) are strictly prohibited.
