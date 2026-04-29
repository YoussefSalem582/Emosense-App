---
description: "Clean Architecture patterns for feature modules — domain, data, presentation layers"
globs: "lib/features/**/*.dart"
alwaysApply: false
---

# Feature Architecture (Clean Architecture + BLoC)

Each feature in `lib/features/` follows three layers: `data/ → domain/ ← presentation/`

## Folder Structure

```
features/<feature_name>/
├── data/
│   ├── datasources/     # Remote/local data sources
│   ├── models/          # Extend entities, add fromJson/toJson
│   └── repositories/    # Implement domain contracts
├── domain/
│   ├── entities/        # Pure Dart, Equatable, no serialization
│   ├── repositories/    # Abstract contracts, return Either<Failure, T>
│   └── usecases/        # One per operation, extend UseCase<T, Params>
└── presentation/
    ├── bloc/            # Events, States, BLoC (separate files)
    ├── pages/           # Full-screen widgets
    └── widgets/         # Feature-specific UI pieces
```

## Dependency Rule

Dependencies only point inward: `Presentation → Domain ← Data`

- **Domain**: Zero Flutter imports. Only `dart:core`, `equatable`, `dartz`.
- **Data**: Implements domain contracts. Uses `ApiClient`, maps exceptions → failures.
- **Presentation**: Talks to Domain through Use Cases only.

## Domain Layer Rules

- Entities extend `Equatable` — no `fromJson`/`toJson`
- Repository contracts are abstract classes returning `Either<Failure, T>`
- Use cases extend `UseCase<ReturnType, Params>` — one file per operation
- Use `NoParams` when no input is needed

## Data Layer Rules

- Models extend their entity and add `fromJson(Map<String, dynamic>)` / `toJson()`
- `fromJson` maps backend snake_case JSON keys to camelCase Dart fields
- Remote data sources use `ApiClient` (get, post, put, patch, delete, uploadFile)
- Repository impls wrap calls in try/catch and map exceptions to failures:
  - `AuthException` → `AuthFailure`
  - `NetworkException` → `NetworkFailure`
  - `ServerException` → `ServerFailure`
  - catch-all → `UnexpectedFailure`

## Presentation Layer Rules

- BLoC receives events, calls use cases, emits states
- Events and states in separate files, extend `Equatable`
- Use `result.fold()` to map Either to success/error states
- Log transitions via `AppLogger.logBlocTransition()`

## DI Registration

In `lib/core/di/dependency_injection.dart`:
- Data sources, repos, use cases → `registerLazySingleton`
- BLoCs → `registerFactory` (new instance per provider)
- Add `BlocProvider` in `app.dart`
