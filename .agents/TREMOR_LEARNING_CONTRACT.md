# Tremor Project: Deep Learning Mandate

**For all AI Agents (Antigravity/BMad):**
When generating, modifying, or reviewing ANY file in the Tremor project, you MUST explain the underlying computer science, Flutter engine, or architectural concepts tied to that file. 

*   Do not just give the code.
*   Explain the "Why".
*   If a Flutter-specific concept is used (e.g., RenderObjects, Event Loop, Isolates, BLoC internals, Element Tree vs Widget Tree), explain how it works under the hood.
*   The goal is L2/Senior interview preparation. Optimize for deep architectural understanding.

---

## MANDATORY PRE-SUGGESTION RULE FOR FLUTTER & DART

Before suggesting, writing, or refactoring ANY Flutter, Dart (or React/frontend) code in this repository:

1. **Check Latest Syntax First**:
   - You MUST cross-reference `docs/latest_syntax.md` to ensure the syntax uses the latest verified standards (Dart 3.13+ Primary Constructors, concise in-body constructors `const new`, class modifiers, native `Result` types, extension types, modern slivers).
2. **Explain the Architectural "Why" Across the Whole App**:
   - For every syntax feature or pattern suggested, you MUST explain:
     - **Why the Flutter/Dart team introduced this syntax**: What specific limitation, memory overhead, or boilerplate problem does it solve?
     - **Cross-Layer Modeling**: How this syntax impacts the entire flow up and down the architecture (from Infrastructure/Data DTOs $\rightarrow$ Domain Contracts $\rightarrow$ Application Use Cases $\rightarrow$ Presentation BLoC $\rightarrow$ RenderObject/Impeller UI).

---

## STRICT SYNTAX ENFORCEMENT: ZERO-BODY PRIMARY CONSTRUCTORS ONLY
- Whenever declaring ANY class, model, result, or failure with instance fields, you MUST use the **Dart 3.13+ Header Primary Constructor with terminating semicolon**:
  ```dart
  sealed class Result<S, F>();
  final class Success<S, F>(final S value) extends Result<S, F>;
  final class FailureResult<S, F>(final F failure) extends Result<S, F>;
  ```
- **STRICTLY FORBIDDEN**: Writing legacy multi-line class bodies with `final S value; const Success(this.value);`. The user expects pure single-line Dart 3.13 declarations wherever possible.

---

## CRITICAL INVARIANT: MANDATORY WEB SEARCH FOR CUTTING-EDGE SYNTAX
- **Never rely on pre-trained legacy syntax defaults.**
- Before suggesting ANY code snippet, class declaration, constructor, async pattern, or Flutter widget structure:
  1. You MUST verify that this is the absolute latest, most concise syntax introduced up to Dart 3.13+ and Flutter 3.47+.
  2. If there is ANY newer shorthand (such as primary constructors with terminating semicolons, zero-body classes, concise in-body `new`, record destructuring), you MUST use that and ONLY that.
  3. Perform a web search if necessary to verify that no newer or more concise language feature exists for that pattern.

---

## CRITICAL DISCOVERY: SUPER PARAMETERS DIRECTLY IN HEADER PRIMARY CONSTRUCTORS
- When a subclass with a primary constructor extends a superclass with a primary constructor, DO NOT write `: super(...)`.
- Use **Super Parameters directly inside the header primary constructor** followed by `extends SuperClass;`:
  ```dart
  abstract class Failure(final String message, [final int? code]);

  class ServerFailure([super.message = 'Server Error', super.code])
      extends Failure;
  ```
- This completely eliminates the initializer list `: super(...)` and the entire class body `{}`.
