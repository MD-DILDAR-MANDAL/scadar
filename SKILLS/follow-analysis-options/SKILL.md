---
name: follow-analysis-options
description: Ensures all Dart and Flutter code written complies with the project's strict analysis_options.yaml lint rules, including using package imports, final locals, and const constructors.
---

# Follow Analysis Options

When writing or refactoring Dart/Flutter code for this project, you must strictly adhere to the rules defined in `analysis_options.yaml`.

## Key Constraints

1. **Imports**: Always use package imports (`always_use_package_imports`). Never use relative imports for files outside the immediate directory if package imports are possible.
2. **Types**: 
   - Always declare return types (`always_declare_return_types`). Do not rely on dynamic inference for return types.
   - Enforce strict casts (`strict-casts: true`); avoid implicit dynamic casts.
   - Enforce strict inference (`strict-inference: true`) and strict raw types (`strict-raw-types: true`).
3. **Immutability & Const**: 
   - Use `const` constructors where possible (`prefer_const_constructors`).
   - Prefer `const` literals to create immutables (`prefer_const_literals_to_create_immutables`).
   - Prefer final local variables (`prefer_final_locals`).
4. **UI / Flutter**:
   - Avoid unnecessary containers (`avoid_unnecessary_containers`).
   - Use `SizedBox` for whitespace instead of `Container` (`sized_box_for_whitespace`).
   - Put children properties last in widget constructors (`sort_child_properties_last`).
   - Always use a `Key` in widget constructors (`use_key_in_widget_constructors`).
   - Do not put logic in `createState` (`no_logic_in_create_state`).
5. **Async & Memory**:
   - Only await Futures (`await_only_futures`).
   - Avoid `void` async functions; use `Future<void>` instead (`avoid_void_async`).
   - Always cancel subscriptions (`cancel_subscriptions`).
   - Always close sinks (`close_sinks`).
   - explicitly handle unawaited futures where required (`unawaited_futures`).
6. **Logging**:
   - Avoid `print` statements (`avoid_print`). Use a dedicated logger if logging is necessary.

Before completing any code modifications, internally review the changes to ensure they pass these strict linting rules.
