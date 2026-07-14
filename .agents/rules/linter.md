---
trigger: always_on
glob: "*.dart"
description: Dart linter rules to follow in the codebase.
---

# Dart Linter Rules
Always follow the specific linter rules defined in `analysis_options.yaml` when writing or modifying Dart files:

## Strict Typing and Inference
- **strict-inference**: Always provide types where they cannot be inferred.
- **strict-raw-types**: Do not use raw types (e.g. use `List<int>` instead of `List`).
- **always_declare_return_types**: Always declare the return type for functions and methods.

## Imports and Structure
- **always_use_package_imports**: Use `package:` imports for files in `lib/` and other directories. Avoid relative imports like `../` unless you are inside the `test/` directory where relative imports are acceptable.
- **unused_import**: Do not leave any unused imports in files.
- **sort_child_properties_last**: For Flutter widgets, always put `child` or `children` properties at the very end of the argument list.

## Asynchronous Programming
- **await_only_futures**: Only use `await` on functions that return a `Future`.
- **avoid_void_async**: Avoid `async` functions that return `void`. Prefer returning `Future<void>`.
- **unawaited_futures**: Always await futures, or explicitly wrap them in `unawaited(...)` if they should run in the background.

## Data Integrity and Security
- **avoid_print**: Do not use `print` in production code. Use a logging framework or `debugPrint`.
- **cancel_subscriptions**: Always cancel `StreamSubscription`s in `dispose` or when they are no longer needed.
- **close_sinks**: Always close `Sink`s, `StreamController`s, and `Subject`s when they are no longer needed.
- **no_logic_in_create_state**: Avoid putting business logic inside a `StatefulWidget`'s `createState()` method.

## UI and Performance (For 60 FPS)
- **prefer_const_constructors**: Use `const` constructors for widgets whenever possible.
- **prefer_const_literals_to_create_immutables**: Use `const` when defining immutable collections (lists, maps, sets).
- **sized_box_for_whitespace**: Use `SizedBox` instead of `Container` for empty space or spacing.
- **use_key_in_widget_constructors**: Always include a `Key? key` parameter in public widget constructors.
- **avoid_unnecessary_containers**: Do not wrap a single widget in a `Container` if it has no styling properties.
- **prefer_final_locals**: Use `final` for local variables that are not reassigned.
