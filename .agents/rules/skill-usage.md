---
trigger: always_on
glob: "*"
description: Mandates adherence to predefined project skills during development tasks.
---

# Skill Usage Rules

When working on this project, always prioritize the usage of predefined skills located in the `.agents/skills/` directory.

Before writing code or solving a problem from scratch, check if a skill exists that covers the task:

- **Testing & Quality**: 
  - `dart-add-unit-test`: Write unit tests for logic.
  - `flutter-add-widget-test`: Verify UI components.
  - `flutter-add-integration-test`: Automate user flows.
  - `dart-collect-coverage`: Run coverage reports.
  - `dart-run-static-analysis`: Ensure code quality and fix lints.
- **Debugging & Resolution**: 
  - `dart-fix-runtime-errors`: Handle stack traces and crashes.
  - `flutter-fix-layout-issues`: Fix rendering/overflow errors.
  - `dart-resolve-package-conflicts`: Fix pubspec version conflicts.
- **Architecture & Patterns**: 
  - `flutter-apply-architecture-best-practices`: Structure layered code (UI, Logic, Data).
  - `dart-flutter-patterns`: Implement GoRouter, Freezed, BLOC/Riverpod.
  - `flutter-setup-declarative-routing`: Configure app routing.
  - `dart-use-pattern-matching`: Utilize modern Dart 3 switch/pattern matching.
- **UI/UX**: 
  - `flutter-build-responsive-layout`: Build adaptive UIs for multiple form factors.
- **Feature Planning**: 
  - `spec-driven-implementation`: Create and follow PRODUCT.md/TECH.md specs.

Do not bypass these established workflows, as they ensure consistency and quality across the project.
