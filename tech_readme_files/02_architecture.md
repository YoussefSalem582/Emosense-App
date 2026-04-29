# 🏗️ Architecture

> A deep-dive into the Clean Architecture + BLoC pattern used in this project.

---

## 1. High-Level Overview

The project follows **Clean Architecture** (Uncle Bob / Reso Coder style) with three layers per feature, plus a shared **core** and **shared** layer that live outside of any feature:

```
┌──────────────────────────────────────────────────────────┐
│                   Presentation Layer                     │
│                                                          │
│   • BLoC (events → states)                               │
│   • Pages (full-screen UI)                               │
│   • Widgets (reusable feature-specific UI pieces)        │
│                                                          │
│   Depends on: Domain                                     │
├──────────────────────────────────────────────────────────┤
│                     Domain Layer                         │
│                                                          │
│   • Entities (plain Dart / Equatable)                    │
│   • Repository contracts (abstract classes)              │
│   • Use Cases (single-responsibility business logic)     │
│                                                          │
│   Depends on: NOTHING (zero Flutter imports)             │
├──────────────────────────────────────────────────────────┤
│                      Data Layer                          │
│                                                          │
│   • Models (extend Entity, add fromJson/toJson)          │
│   • Data Sources (Remote = API, Local = cache)           │
│   • Repository implementations                          │
│                                                          │
│   Depends on: Domain (implements its contracts)          │
│   Depends on: Core (ApiClient, exceptions)               │
└──────────────────────────────────────────────────────────┘
```

### The Dependency Rule

Dependencies **only point inward**:

```
Presentation → Domain ← Data
                 ↑
                 │
              Core / Shared
```

- **Domain** has zero knowledge of Flutter, Dio, or any external package.
- **Data** implements the abstract repository from Domain.
- **Presentation** talks to Domain through Use Cases only.
- **Core** provides cross-cutting concerns (networking, error handling, DI).
- **Shared** provides reusable UI widgets that any feature can use.

---

## 2. Layer-by-Layer Breakdown

### 2.1 Domain Layer

The domain layer is the **innermost** layer. It contains:

| Component | Purpose | File pattern |
|-----------|---------|-------------|
| **Entity** | Pure data class, no serialisation | `*_entity.dart` |
| **Repository** | Abstract contract defining what the feature can do | `*_repository.dart` |
| **Use Case** | Single operation, calls repository, returns `Either<Failure, T>` | `*_usecase.dart` |

**Rules:**
- No Flutter imports — only `dart:core`, `equatable`, `dartz`.
- Entities use `Equatable` for value equality.
- Use cases extend `UseCase<ReturnType, Params>` (see `core/usecase/usecase.dart`).
- Use `NoParams` when a use case needs no input.

**Example use case pattern:**

```dart
class LoginUseCase extends UseCase<AuthResponseEntity, LoginParams> {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, AuthResponseEntity>> call(LoginParams params) {
    return repository.login(email: params.email, password: params.password);
  }
}
```

### 2.2 Data Layer

The data layer **implements** domain contracts and handles external I/O.

| Component | Purpose | File pattern |
|-----------|---------|-------------|
| **Model** | Extends entity, adds `fromJson` / `toJson` | `*_model.dart` |
| **Remote Data Source** | HTTP calls via `ApiClient` | `*_remote_datasource.dart` |
| **Local Data Source** | Cache via SharedPreferences / SecureStorage | `*_local_datasource.dart` |
| **Repository Impl** | Orchestrates data sources, maps exceptions → failures | `*_repository_impl.dart` |

**Exception → Failure mapping** (repository impl pattern):

```dart
try {
  final result = await remoteDataSource.getJobs(page: params.page);
  return Right(result);                          // Success path
} on AuthException {
  return const Left(AuthFailure(message: 'Session expired'));
} on NetworkException {
  return const Left(NetworkFailure(message: 'No internet connection'));
} on ServerException catch (e) {
  return Left(ServerFailure(message: e.message));
} catch (e) {
  return Left(UnexpectedFailure(message: e.toString()));
}
```

### 2.3 Presentation Layer

The presentation layer handles **UI and state management**.

| Component | Purpose | File pattern |
|-----------|---------|-------------|
| **BLoC** | Receives events, calls use cases, emits states | `*_bloc.dart` |
| **Events** | Immutable input triggers | `*_event.dart` |
| **States** | Immutable output snapshots | `*_state.dart` |
| **Pages** | Full-screen widgets | `*_page.dart` |
| **Widgets** | Reusable feature-specific UI pieces | Any `.dart` in `widgets/` |

**BLoC pattern used in this project:**

```dart
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUseCase loginUseCase;
  // ... other use cases

  AuthBloc({required this.loginUseCase, ...}) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    // ... register other handlers
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await loginUseCase(LoginParams(email: event.email, password: event.password));
    result.fold(
      (failure) => emit(AuthError(message: failure.message)),
      (authResponse) => emit(Authenticated(user: authResponse.user)),
    );
  }
}
```

---

## 3. Core Layer

Cross-cutting infrastructure that does **not** belong to any single feature.

```
core/
├── api/            ← Dio client, endpoints, response envelope
├── constants/      ← App-wide config values, storage keys
├── error/          ← Exception hierarchy (data) + Failure hierarchy (domain)
├── extensions/     ← BuildContext & String extensions
├── usecase/        ← Abstract UseCase<T, P> base class
└── utils/          ← Logger (Talker), form validators
```

### Error Flow

```
API Error (HTTP 4xx/5xx)
  ↓ ApiClient catches DioException
  ↓ Maps to data-layer Exception (ServerException, AuthException, ValidationException…)
  ↓ Repository catches Exception
  ↓ Maps to domain-layer Failure (ServerFailure, AuthFailure, ValidationFailure…)
  ↓ Wrapped in Left<Failure, T>
  ↓ BLoC receives Either, folds into error state
  ↓ UI displays error message
```

### API Client Interceptors

The `ApiClient` (Dio wrapper) attaches three interceptors automatically:

1. **Auth Interceptor** — reads token from `FlutterSecureStorage`, adds `Authorization: Bearer <token>` header.
2. **Language Interceptor** — reads locale from `SharedPreferences`, adds `lang` and `Accept-Language` headers.
3. **Logging Interceptor** — `TalkerDioLogger` logs all requests/responses (disabled in production).

---

## 4. Shared Layer

Feature-agnostic, reusable UI building blocks.

```
shared/
├── assets/         ← Static asset path constants
├── spacing/        ← SizedBox presets, EdgeInsets presets, BorderRadius presets
└── widgets/        ← Buttons, inputs, cards, loading, error, empty state, app bar, responsive layout
```

Every widget under `core/widgets/` is designed to be **generic** — no feature-specific imports, no hardcoded strings (uses `AppLocalizations`).

---

## 5. Dependency Injection

The app uses **GetIt** as its service locator. All registrations happen in `lib/core/di/dependency_injection.dart`.

### Registration Strategy

| Type | Registration | Lifetime |
|------|-------------|----------|
| External (Prefs, Storage, Talker) | `registerLazySingleton` | App lifetime |
| API Client | `registerLazySingleton` | App lifetime |
| Data Sources | `registerLazySingleton` | App lifetime |
| Repositories | `registerLazySingleton` | App lifetime |
| Use Cases | `registerLazySingleton` | App lifetime |
| BLoCs | `registerFactory` | Per-widget (new instance each time) |

**Why BLoCs use `registerFactory`:** Each `BlocProvider` creates a fresh BLoC instance so that navigating away and back doesn't reuse stale state.

### Wiring Example

```
GetIt
 ├── ApiClient (singleton)
 │     └── uses: FlutterSecureStorage, Talker
 ├── AuthRemoteDataSource (singleton)
 │     └── uses: ApiClient
 ├── AuthRepository (singleton)
 │     └── uses: AuthRemoteDataSource, AuthLocalDataSource
 ├── LoginUseCase (singleton)
 │     └── uses: AuthRepository
 └── AuthBloc (factory — new instance per provider)
       └── uses: LoginUseCase, RegisterUseCase, LogoutUseCase, …
```

---

## 6. Routing

The shell uses **`MaterialApp`** (`lib/app.dart`) with **`initialRoute: AppRouter.splash`** and **`onGenerateRoute: AppRouter.generateRoute`**. Canonical paths live on **`AppRouter`** in `lib/core/routing/app_router.dart` as `static const String` fields (`AppRouter.login`, `AppRouter.adminDashboard`, `/text-analysis`, etc.).

Navigation is Navigator 1-friendly; **`GoRouter` is not used** in production wiring.

Prefer `Navigator.pushNamed(context, AppRouter.<constant>)` (or builders that wrap the same constants) instead of scattering raw literals outside `generateRoute`'s switch.

Typical scaffold:

```dart
MaterialApp(
  initialRoute: AppRouter.splash,
  onGenerateRoute: AppRouter.generateRoute,
);
```

Flows (splash → auth → employee/admin/analysis) evolve inside `generateRoute`; read that file alongside the splash/onboarding/authentication modules for authoritative behavior.

---

## 7. State Management Flow

```
┌──────────┐     ┌────────┐     ┌──────────┐     ┌────────────┐
│  UI      │────>│ Event  │────>│  BLoC    │────>│ Use Case   │
│  (Page)  │     │        │     │          │     │            │
│          │<────│ State  │<────│          │<────│ Repository │
└──────────┘     └────────┘     └──────────┘     └────────────┘
```

1. User interacts with UI → dispatches an **Event**
2. BLoC receives event → calls **Use Case** with params
3. Use Case calls **Repository** (abstract contract)
4. Repository impl calls **Data Source** (remote / local)
5. Returns `Either<Failure, T>` up the chain
6. BLoC folds the result → emits success or error **State**
7. UI rebuilds via `BlocBuilder` / `BlocListener`

---

## 8. Localisation

- Two ARB files: `app_en.arb` (English), `app_ar.arb` (Arabic)
- Auto-generated via `flutter gen-l10n` into `lib/l10n/generated/`
- Accessed in widgets via `context.l10n.someKey` (extension from `context_extensions.dart`)
- **No hardcoded user-facing strings** — everything goes through ARB keys

---

## 9. Theming

- Colours → `AppColors` (single source of truth)
- Text styles → `AppTextStyles` (Material 3 type scale)
- Light theme → `LightTheme.theme`
- Dark theme → `DarkTheme.theme`
- Font loaded at runtime via `google_fonts` package (`GoogleFonts.publicSansTextTheme()`)
- Both themes are configured in `app.dart` and toggled via `ThemeMode`
