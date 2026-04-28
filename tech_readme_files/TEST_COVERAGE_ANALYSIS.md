# Test Coverage Analysis

> **Date:** March 20, 2026
> **Current Coverage:** ~0% (1 placeholder test)
> **Codebase Size:** ~195 Dart files, 7 features, 21 use cases, 4 BLoCs, 1 Cubit

---

## Current State

The project has a single test file (`test/widget_test.dart`) containing one placeholder assertion (`1 + 1 == 2`). No actual unit, widget, or integration tests exist. The dev dependencies `bloc_test` and `mocktail` are already in `pubspec.yaml` but unused.

---

## Priority Areas for Test Coverage

### Priority 1 — BLoC / Cubit Tests (Critical)

BLoCs contain the app's core business logic orchestration. They are the highest-value test targets because they coordinate use cases, manage state transitions, and handle error paths.

| BLoC/Cubit | File | Why Test | Key Scenarios |
|------------|------|----------|---------------|
| **AuthBloc** | `features/auth/presentation/bloc/auth_bloc.dart` | Singleton, guards entire app access | Login success/failure, register validation, Google sign-in flow, logout clears state, session expiry handling, cached user restoration |
| **AttendanceBloc** | `features/attendance/presentation/bloc/attendance_bloc.dart` | Complex async: parallel API calls, timer service, cache, offline fallback | Check-in/out state transitions, status update, `Completer`-based refresh, cache restore, offline fallback with `offlineMessage`, timer service start/stop sync |
| **KpiBloc** | `features/kpi/presentation/bloc/kpi_bloc.dart` | CRUD + filter + sort + cache | Load definitions + entries, upsert/delete entry, filter by definition/date, sort options, cache persist/restore, offline fallback |
| **ProfileBloc** | `features/profile/profile_view/presentation/bloc/profile_bloc.dart` | Most complex: 5 use cases, cache, bulk operations, locale refresh | Load personal/professional/completeness, update personal/professional, bulk skill add, cache persist/restore, offline fallback, reset on logout |
| **SettingsCubit** | `features/settings/presentation/cubit/settings_cubit.dart` | Controls theme + locale globally | Load saved preferences, toggle theme mode, switch locale, persist to SharedPreferences |

**Estimated tests:** ~80-100 test cases across all BLoCs.

**Testing pattern:**
```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] on successful login',
  build: () {
    when(() => loginUseCase(any())).thenAnswer((_) async => Right(userEntity));
    return AuthBloc(loginUseCase: loginUseCase, ...);
  },
  act: (bloc) => bloc.add(LoginRequested(email: 'test@test.com', password: 'pass')),
  expect: () => [AuthLoading(), AuthAuthenticated(user: userEntity)],
);
```

---

### Priority 2 — Use Case Tests (High)

Use cases are thin but validate that domain logic correctly delegates to repositories and returns `Either<Failure, T>`. Testing them ensures the contract between layers holds.

| Feature | Use Cases (21 total) | Key Scenarios |
|---------|---------------------|---------------|
| **Auth** (6) | Login, Register, ForgotPassword, GoogleSignIn, GetCachedUser, Logout | Success returns `Right(data)`, failure returns `Left(failure)`, parameter validation |
| **Attendance** (6) | CheckIn, CheckOut, GetCurrentAttendance, GetAttendanceStatuses, GetAttendanceSchedule, UpdateAttendanceStatus | Success/failure paths, correct params forwarded to repo |
| **KPI** (4) | GetKpiDefinitions, GetKpiEntries, UpsertKpiEntry, DeleteKpiEntry | Pagination params, CRUD operations |
| **Profile** (5) | GetPersonalDetails, GetProfessionalDetails, GetProfileCompleteness, UpdatePersonalDetails, UpdateProfessionalDetails | Data round-trip, failure mapping |

**Estimated tests:** ~42-63 test cases (2-3 per use case).

---

### Priority 3 — Repository Implementation Tests (High)

Repository impls contain the critical exception-to-failure mapping logic. Testing ensures `ServerException → ServerFailure`, `AuthException → AuthFailure`, etc.

| Repository Impl | File | Key Scenarios |
|-----------------|------|---------------|
| **AuthRepositoryImpl** | `features/auth/data/repositories/auth_repository_impl.dart` | Each method: success path returns `Right`, `AuthException` → `AuthFailure`, `NetworkException` → `NetworkFailure`, `ServerException` → `ServerFailure`, catch-all → `UnexpectedFailure` |
| **AttendanceRepositoryImpl** | `features/attendance/data/repositories/attendance_repository_impl.dart` | Same pattern for 6 methods |
| **KpiRepositoryImpl** | `features/kpi/data/repositories/kpi_repository_impl.dart` | Same pattern for 4 methods |
| **ProfileRepositoryImpl** | `features/profile/shared/data/repositories/profile_repository_impl.dart` | Same pattern, plus multi-locale skill fetch |

**Estimated tests:** ~60-80 test cases (4-5 per method × 4 repos).

---

### Priority 4 — Model Serialization Tests (Medium)

Models handle `fromJson` / `toJson` and are the bridge between API responses and domain entities. Incorrect mapping causes silent data loss.

| Model | File | Key Scenarios |
|-------|------|---------------|
| **UserModel** | `features/auth/data/models/user_model.dart` | `fromJson` with all fields, `fromJson` with nulls, `toJson` round-trip |
| **AttendanceModel** (3 models) | `features/attendance/data/models/attendance_model.dart` | Status, Current, Schedule — each with `fromJson`/`toJson` |
| **KpiModel** (3 models) | `features/kpi/data/models/kpi_model.dart` | Definition, Entry, Note — `fromJson`/`toJson` |
| **ProfileModel** (8+ models) | `features/profile/shared/data/models/profile_model.dart` | Profile, Experience, Education, Skill, Professional, Resume, Video, Summary — `fromJson`/`toJson` cache round-trip |

**Estimated tests:** ~40-50 test cases.

---

### Priority 5 — Core Utility Tests (Medium)

| Utility | File | Key Scenarios |
|---------|------|---------------|
| **Validators** | `core/utils/validators.dart` | Email format, phone format, password strength, name validation — boundary cases, empty strings, unicode |
| **ApiResponse** | `core/api/api_response.dart` | Parse success response, parse error response, parse validation (422) response, pagination extraction |
| **String Extensions** | `core/extensions/string_extensions.dart` | All extension methods |
| **Failures** | `core/error/failures.dart` | Equatable equality, `message` property |

**Estimated tests:** ~30-40 test cases.

---

### Priority 6 — Widget Tests (Lower Priority)

Widget tests are valuable but have higher maintenance cost and require more setup (mocking BLoCs, navigation, l10n). Start with the most reusable widgets.

| Widget | Priority | Rationale |
|--------|----------|-----------|
| **AppButton** | High | Used everywhere — test all variants (elevated, outlined, text, loading, disabled) |
| **AppTextField** | High | Core form input — test validation display, password toggle, formatters |
| **AppPhoneField** | Medium | Test RTL directionality fix, country code selection |
| **AppDateField** | Medium | Test date display format, age calculation, clear action |
| **EmptyStateWidget** | Low | Simple presentational widget |
| **OfflineBanner** | Medium | Test retry loading state toggle |

**Estimated tests:** ~30-40 test cases.

---

## Recommended Implementation Order

1. **Set up test infrastructure first:**
   - Create `test/helpers/` with mock classes for all repositories, use cases, data sources
   - Create `test/fixtures/` with sample JSON responses and entity factories
   - Create a `pump_app.dart` helper that wraps widgets with `MaterialApp`, `BlocProvider`, and `AppLocalizations`

2. **Phase 1 (Week 1-2): BLoC tests** — highest ROI, catches state management regressions
3. **Phase 2 (Week 2-3): Repository + Model tests** — catches API contract regressions
4. **Phase 3 (Week 3-4): Use case + Core utility tests** — fills coverage gaps
5. **Phase 4 (Ongoing): Widget tests** — add as features change

---

## Test Infrastructure Needed

```
test/
├── helpers/
│   ├── mocks.dart              # All mock classes (MockAuthRepository, etc.)
│   ├── pump_app.dart           # Widget test helper with l10n + theme
│   └── test_injection.dart     # Test DI container setup
├── fixtures/
│   ├── auth_fixtures.dart      # Sample UserEntity, login response JSON
│   ├── attendance_fixtures.dart
│   ├── kpi_fixtures.dart
│   └── profile_fixtures.dart
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/user_model_test.dart
│   │   │   └── repositories/auth_repository_impl_test.dart
│   │   ├── domain/usecases/
│   │   │   ├── login_usecase_test.dart
│   │   │   ├── register_usecase_test.dart
│   │   │   └── ...
│   │   └── presentation/bloc/auth_bloc_test.dart
│   ├── attendance/
│   │   ├── data/...
│   │   ├── domain/...
│   │   └── presentation/bloc/attendance_bloc_test.dart
│   ├── kpi/
│   │   ├── data/...
│   │   ├── domain/...
│   │   └── presentation/bloc/kpi_bloc_test.dart
│   ├── profile/
│   │   ├── shared/data/...
│   │   ├── profile_view/...
│   │   └── edit_profile/...
│   └── settings/
│       └── presentation/cubit/settings_cubit_test.dart
├── core/
│   ├── utils/validators_test.dart
│   ├── api/api_response_test.dart
│   └── extensions/string_extensions_test.dart
└── shared/
    └── widgets/
        ├── app_button_test.dart
        └── app_text_field_test.dart
```

---

## Summary

| Priority | Category | Est. Tests | Coverage Impact |
|----------|----------|-----------|-----------------|
| P1 | BLoC/Cubit tests | 80-100 | High — all state logic |
| P2 | Use case tests | 42-63 | Medium — domain contracts |
| P3 | Repository impl tests | 60-80 | High — error mapping |
| P4 | Model serialization tests | 40-50 | Medium — API contracts |
| P5 | Core utility tests | 30-40 | Medium — shared logic |
| P6 | Widget tests | 30-40 | Lower — UI rendering |
| **Total** | | **~280-370** | |

Starting with P1 (BLoC tests) and P3 (repository tests) together would give the best coverage-to-effort ratio, catching both state management bugs and API integration regressions.
