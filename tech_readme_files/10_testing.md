# 🧪 Testing Guide

> **Last Updated:** March 21, 2026
> **Test Files:** 29 | **Test Cases:** ~365 | **Framework:** `flutter_test` + `bloc_test` + `mocktail`

---

## Overview

The project uses a layered testing strategy aligned with Clean Architecture. Tests cover all implemented features across BLoC/Cubit, repository, model, use case, entity, and core utility layers.

### Dev Dependencies

| Package | Purpose |
|---------|---------|
| `flutter_test` | Flutter's built-in test framework |
| `bloc_test` | BLoC-specific test helpers (`blocTest`, `emitsExactly`) |
| `mocktail` | Zero-config mocking (no code generation) |

---

## Running Tests

```powershell
# Run all tests
flutter test

# Run a specific test file
flutter test test/features/auth/presentation/bloc/auth_bloc_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests matching a name pattern
flutter test --name "AuthBloc"

# Run tests in a specific directory
flutter test test/features/auth/

# Run with verbose output
flutter test --reporter expanded
```

---

## Test Directory Structure

```
test/
├── helpers/
│   └── mocks.dart                    # 37 mock classes (all repos, use cases, data sources, services)
│
├── fixtures/
│   ├── auth_fixtures.dart            # UserEntity, UserModel, login/register JSON samples
│   ├── attendance_fixtures.dart      # StatusEntity, CurrentEntity, ScheduleEntity, JSON samples
│   ├── kpi_fixtures.dart             # DefinitionEntity, EntryEntity, NoteEntity, JSON samples
│   └── profile_fixtures.dart         # ProfileEntity, ExperienceEntity, SkillEntity, JSON samples
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/user_model_test.dart
│   │   │   └── repositories/auth_repository_impl_test.dart
│   │   ├── domain/
│   │   │   ├── entities/user_entity_test.dart
│   │   │   └── usecases/auth_usecases_test.dart
│   │   └── presentation/
│   │       └── bloc/auth_bloc_test.dart
│   │
│   ├── attendance/
│   │   ├── data/
│   │   │   ├── models/attendance_model_test.dart
│   │   │   └── repositories/attendance_repository_impl_test.dart
│   │   ├── domain/
│   │   │   ├── entities/attendance_entity_test.dart
│   │   │   └── usecases/attendance_usecases_test.dart
│   │   └── presentation/
│   │       └── bloc/attendance_bloc_test.dart
│   │
│   ├── kpi/
│   │   ├── data/
│   │   │   ├── models/kpi_model_test.dart
│   │   │   └── repositories/kpi_repository_impl_test.dart
│   │   ├── domain/
│   │   │   ├── entities/kpi_entity_test.dart
│   │   │   └── usecases/kpi_usecases_test.dart
│   │   └── presentation/
│   │       └── bloc/kpi_bloc_test.dart
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── models/profile_model_test.dart
│   │   │   └── repositories/profile_repository_impl_test.dart
│   │   ├── domain/
│   │   │   ├── entities/profile_entity_test.dart
│   │   │   └── usecases/profile_usecases_test.dart
│   │   └── presentation/
│   │       └── bloc/profile_bloc_test.dart
│   │
│   └── settings/
│       └── presentation/
│           └── cubit/settings_cubit_test.dart
│
├── core/
│   ├── api/
│   │   ├── api_endpoints_test.dart
│   │   └── api_response_test.dart
│   ├── constants/
│   │   └── storage_keys_test.dart
│   ├── error/
│   │   ├── exceptions_test.dart
│   │   └── failures_test.dart
│   ├── extensions/
│   │   └── string_extensions_test.dart
│   └── utils/
│       └── validators_test.dart
│
└── widget_test.dart                  # Placeholder (default Flutter test)
```

---

## Implementation Phases

The test suite was built incrementally across 4 phases, each targeting a specific layer or set of features.

### Phase 1 — Auth, Settings & Core Utilities (8 files, ~75 tests)

**Goal:** Establish test infrastructure (mocks, fixtures) and cover the most critical feature (Auth) plus core utilities used everywhere.

| File | Tests | What It Covers |
|------|-------|----------------|
| `test/helpers/mocks.dart` | — | 13 initial mock classes (Auth repos, use cases, data sources, GoogleSignIn) |
| `test/fixtures/auth_fixtures.dart` | — | Sample UserEntity, UserModel, login/register JSON |
| `test/features/auth/presentation/bloc/auth_bloc_test.dart` | 15 | Login, register, logout, forgot password, Google sign-in, session expiry, user data update, error clearing |
| `test/features/auth/data/repositories/auth_repository_impl_test.dart` | 14 | Exception-to-failure mapping for all 6 auth methods |
| `test/features/auth/data/models/user_model_test.dart` | 9 | fromJson (flat, nested, minimal), toJson, round-trip, AuthResponseModel |
| `test/features/auth/domain/entities/user_entity_test.dart` | 8 | fullName, initials, Equatable |
| `test/features/settings/presentation/cubit/settings_cubit_test.dart` | 4 | Load defaults, load saved prefs, setThemeMode, setLocale |
| `test/core/utils/validators_test.dart` | 19 | required, email, password, confirmPassword, phone, name, minLength, maxLength |
| `test/core/extensions/string_extensions_test.dart` | 16 | capitalize, titleCase, isValidEmail, truncate, initials, isNullOrEmpty |
| `test/core/error/failures_test.dart` | 12 | All 8 failure types, Equatable equality, getFieldError |

---

### Phase 2 — Attendance, KPI & Auth Use Cases (7 files, ~95 tests)

**Goal:** Cover the two most complex BLoCs (Attendance with timer/cache, KPI with CRUD/filter) and their full data layer. Add Auth use case tests.

| File | Tests | What It Covers |
|------|-------|----------------|
| `test/fixtures/attendance_fixtures.dart` | — | Status, current, schedule entities + JSON |
| `test/fixtures/kpi_fixtures.dart` | — | Definition, entry, note entities + JSON |
| `test/features/attendance/presentation/bloc/attendance_bloc_test.dart` | 16 | Load, check-in/out, status update, refresh, schedule, offline cache, Completer |
| `test/features/kpi/presentation/bloc/kpi_bloc_test.dart` | 18 | Load, upsert (insert/update), delete, refresh, filter by definition/sort, Completer, pagination |
| `test/features/attendance/data/repositories/attendance_repository_impl_test.dart` | 14 | Exception-to-failure mapping for 6 methods |
| `test/features/kpi/data/repositories/kpi_repository_impl_test.dart` | 14 | Exception-to-failure mapping incl. ValidationException and NotFoundException |
| `test/features/attendance/data/models/attendance_model_test.dart` | 13 | StatusModel, CurrentModel, ScheduleModel — fromJson/toJson/round-trip |
| `test/features/kpi/data/models/kpi_model_test.dart` | 14 | DefinitionModel, NoteModel, EntryModel — nested fromJson/toJson/round-trip |
| `test/features/auth/domain/usecases/auth_usecases_test.dart` | 16 | All 6 auth use cases: param forwarding, success, failure, Params equality |

**Infrastructure expanded:** 29 mock classes (+16 for Attendance and KPI)

---

### Phase 3 — Profile Feature & Remaining Entities/Use Cases (7 files, ~120 tests)

**Goal:** Cover the most complex feature (Profile — 5 use cases, 9 model types, 15+ repo methods) and fill entity/use case gaps in Attendance and KPI.

| File | Tests | What It Covers |
|------|-------|----------------|
| `test/fixtures/profile_fixtures.dart` | — | Profile, experience, education, skill entities + JSON |
| `test/features/profile/presentation/bloc/profile_bloc_test.dart` | 25 | Load, refresh, personal/professional update, experience/education/skill CRUD, bulk skill add, image upload/delete, resume/video CRUD, summary update, reset |
| `test/features/profile/data/repositories/profile_repository_impl_test.dart` | 16 | Exception-to-failure mapping for 15+ methods incl. ValidationException |
| `test/features/profile/data/models/profile_model_test.dart` | 22 | 9 model types: ProfileModel, ExperienceModel, EducationModel, SkillModel, ProfessionalDetailsModel, ProfileSummaryModel, ProfileImagesModel, ResumeModel, VideoModel |
| `test/features/attendance/domain/entities/attendance_entity_test.dart` | 12 | StatusEntity, CurrentEntity, ScheduleEntity Equatable; FilterEntity hasActiveFilters/copyWith |
| `test/features/kpi/domain/entities/kpi_entity_test.dart` | 14 | DefinitionEntity, EntryEntity.displayValue, NoteEntity; FilterEntity hasActiveFilters/copyWith |
| `test/features/attendance/domain/usecases/attendance_usecases_test.dart` | 12 | 6 use cases + Params equality |
| `test/features/kpi/domain/usecases/kpi_usecases_test.dart` | 11 | 4 use cases + Params equality |

**Infrastructure expanded:** 36 mock classes (+7 for Profile)

---

### Phase 4 — Core API, Profile Entities/Use Cases & Remaining Core (6 files, ~75 tests)

**Goal:** Fill remaining coverage gaps in core utilities (ApiResponse, ApiEndpoints, Exceptions, StorageKeys) and Profile domain layer (entities, use cases).

| File | Tests | What It Covers |
|------|-------|----------------|
| `test/core/api/api_response_test.dart` | 18 | ApiResponse fromJson with/without transformer, missing keys, pagination parsing, hasPagination, hasData, Equatable; PaginationMeta fromJson, defaults, navigation helpers, toJson, round-trip |
| `test/core/api/api_endpoints_test.dart` | 10 | Static paths (auth, profile, attendance, kpi) + dynamic path builders (8 methods) |
| `test/core/error/exceptions_test.dart` | 15 | All 6 exception types: toString, default values, custom values |
| `test/core/constants/storage_keys_test.dart` | 4 | tech92_ prefix consistency, uniqueness, specific key values |
| `test/features/profile/domain/entities/profile_entity_test.dart` | 20 | ProfileEntity fullName (all name permutations), 8 sub-entities Equatable |
| `test/features/profile/domain/usecases/profile_usecases_test.dart` | 12 | 5 use cases: GetPersonalDetails, GetProfessionalDetails, GetProfileCompleteness, UpdatePersonalDetails, UpdateProfessionalDetails + Params equality |

**Infrastructure expanded:** 37 mock classes (+1 MockGetProfileCompletenessUseCase)

---

## Test Coverage by Layer

### BLoC / Cubit Tests (5 files, ~80 tests)

BLoC tests verify state transitions, use case orchestration, caching, and error handling.

| Test File | BLoC/Cubit | Key Scenarios |
|-----------|------------|---------------|
| `auth_bloc_test.dart` | AuthBloc | Login/register success & failure, Google sign-in flow, logout clears state, session expiry, cached user restoration, user data update, error clearing |
| `attendance_bloc_test.dart` | AttendanceBloc | Load statuses + current, check-in/out, status update, `Completer`-based refresh, schedule load, offline cache fallback, timer service sync |
| `kpi_bloc_test.dart` | KpiBloc | Load definitions + entries, upsert insert/update, delete, refresh, filter by definition/sort, `Completer` refresh, pagination |
| `profile_bloc_test.dart` | ProfileBloc | Load personal/professional/completeness, update forms, experience/education/skill CRUD, bulk skill add, image upload/delete, resume/video CRUD, summary update, reset on logout |
| `settings_cubit_test.dart` | SettingsCubit | Load saved theme/locale from SharedPreferences, toggle theme mode, switch locale, persistence |

**Pattern:**

```dart
blocTest<AuthBloc, AuthState>(
  'emits [AuthLoading, AuthAuthenticated] on successful login',
  build: () {
    when(() => mockLoginUseCase(any()))
        .thenAnswer((_) async => Right(tUserEntity));
    return buildBloc();
  },
  act: (bloc) => bloc.add(
    LoginRequested(email: 'test@test.com', password: 'password123'),
  ),
  expect: () => [
    AuthLoading(),
    AuthAuthenticated(user: tUserEntity),
  ],
);
```

---

### Repository Implementation Tests (4 files, ~60 tests)

Repository tests verify the exception-to-failure mapping contract. Each method tests:
1. **Success path** — returns `Right(data)`
2. **`AuthException`** → `AuthFailure`
3. **`NetworkException`** → `NetworkFailure`
4. **`ServerException`** → `ServerFailure`
5. **Catch-all** → `UnexpectedFailure`

Some repos also test:
- **`ValidationException`** → `ValidationFailure` (with field errors)
- **`NotFoundException`** → `NotFoundFailure`

| Test File | Repository | Methods Tested |
|-----------|-----------|----------------|
| `auth_repository_impl_test.dart` | AuthRepositoryImpl | login, register, logout, forgotPassword, googleSignIn, getCachedUser |
| `attendance_repository_impl_test.dart` | AttendanceRepositoryImpl | getStatuses, getCurrent, checkIn, checkOut, updateStatus, getSchedule |
| `kpi_repository_impl_test.dart` | KpiRepositoryImpl | getDefinitions, getEntries, upsertEntry, deleteEntry |
| `profile_repository_impl_test.dart` | ProfileRepositoryImpl | getPersonalDetails, getProfessionalDetails, updatePersonalDetails, addExperience, deleteExperience, getSkills, addSkill, uploadImage, deleteImage, getProfileSummary, uploadResume, deleteResume |

**Pattern:**

```dart
test('returns ServerFailure when ServerException is thrown', () async {
  when(() => mockRemoteDataSource.login(any(), any()))
      .thenThrow(const ServerException());

  final result = await repository.login('email', 'password');

  expect(result, isA<Left>());
  result.fold(
    (failure) => expect(failure, isA<ServerFailure>()),
    (_) => fail('Should have returned a failure'),
  );
});
```

---

### Model Serialization Tests (4 files, ~50 tests)

Model tests verify `fromJson` / `toJson` round-trips, null handling, and nested object parsing.

| Test File | Models Tested |
|-----------|--------------|
| `user_model_test.dart` | UserModel — flat JSON, nested company JSON, minimal/nullable fields, `toJson` round-trip |
| `attendance_model_test.dart` | AttendanceStatusModel, CurrentAttendanceModel, AttendanceScheduleModel — `fromJson`/`toJson`/round-trip |
| `kpi_model_test.dart` | KpiDefinitionModel, KpiEntryModel, KpiNoteModel — `fromJson`/`toJson`/round-trip with nested structures |
| `profile_model_test.dart` | ProfileModel, ExperienceModel, EducationModel, SkillModel, ProfessionalDetailsModel, ProfileSummaryModel, ProfileImagesModel, ResumeModel, VideoModel — `fromJson`/`toJson`/round-trip |

**Pattern:**

```dart
test('fromJson creates valid model from JSON', () {
  final model = UserModel.fromJson(tUserJson);

  expect(model.id, '1');
  expect(model.email, 'test@test.com');
  expect(model.firstName, 'John');
});

test('toJson produces correct JSON', () {
  final json = tUserModel.toJson();

  expect(json['email'], 'test@test.com');
  expect(json['first_name'], 'John');
});
```

---

### Use Case Tests (4 files, ~45 tests)

Use case tests verify correct delegation to repositories and `Either` return types.

| Test File | Use Cases Tested |
|-----------|-----------------|
| `auth_usecases_test.dart` | LoginUseCase, RegisterUseCase, LogoutUseCase, ForgotPasswordUseCase, GetCachedUserUseCase, GoogleSignInUseCase + Params equality |
| `attendance_usecases_test.dart` | GetStatusesUseCase, GetCurrentUseCase, CheckInUseCase, CheckOutUseCase, UpdateStatusUseCase, GetScheduleUseCase + Params equality |
| `kpi_usecases_test.dart` | GetDefinitionsUseCase, GetEntriesUseCase, UpsertEntryUseCase, DeleteEntryUseCase + Params equality |
| `profile_usecases_test.dart` | GetPersonalDetailsUseCase, GetProfessionalDetailsUseCase, GetProfileCompletenessUseCase, UpdatePersonalDetailsUseCase, UpdateProfessionalDetailsUseCase + Params equality |

**Pattern:**

```dart
test('calls repository.login with correct params', () async {
  when(() => mockRepository.login(any(), any()))
      .thenAnswer((_) async => Right(tAuthResponse));

  final result = await useCase(const LoginParams(
    email: 'test@test.com',
    password: 'password',
  ));

  expect(result, Right(tAuthResponse));
  verify(() => mockRepository.login('test@test.com', 'password')).called(1);
});
```

---

### Entity Tests (4 files, ~50 tests)

Entity tests verify Equatable equality, computed properties, and `copyWith` methods.

| Test File | Entities Tested |
|-----------|----------------|
| `user_entity_test.dart` | UserEntity — `fullName`, `initials`, Equatable props |
| `attendance_entity_test.dart` | StatusEntity, CurrentEntity, ScheduleEntity (Equatable); FilterEntity — `hasActiveFilters`, `copyWith`, clear flags |
| `kpi_entity_test.dart` | DefinitionEntity, EntryEntity (`displayValue`), NoteEntity; FilterEntity — `hasActiveFilters`, `copyWith`, clear flags |
| `profile_entity_test.dart` | ProfileEntity (`fullName` for all name permutations), ProfessionalDetailsEntity, ExperienceEntity, EducationEntity, SkillEntity, ProfileImagesEntity, ProfileSummaryEntity, ResumeEntity, VideoEntity — all Equatable |

---

### Core Utility Tests (7 files, ~60 tests)

| Test File | What's Tested |
|-----------|--------------|
| `validators_test.dart` | Email, password, phone, name, required, minLength, maxLength — boundary cases, empty strings, unicode |
| `string_extensions_test.dart` | `capitalize`, `titleCase`, `truncate`, `initials`, `isValidEmail`, `isNullOrEmpty` |
| `failures_test.dart` | All 8 failure types — Equatable equality, `message` property, `getFieldError` |
| `exceptions_test.dart` | All 6 exception types — `toString`, default values, custom values |
| `api_response_test.dart` | `fromJson` with/without transformer, missing keys, pagination parsing, `hasPagination`, `hasData`, Equatable |
| `api_endpoints_test.dart` | Static paths (auth, profile, attendance, kpi) + dynamic path builders |
| `storage_keys_test.dart` | `tech92_` prefix consistency, uniqueness across all keys |

---

## Test Infrastructure

### Mocks (`test/helpers/mocks.dart`)

37 mock classes using `mocktail`. Organized by feature:

| Feature | Mock Classes |
|---------|-------------|
| **Auth** | MockAuthRepository, MockLoginUseCase, MockRegisterUseCase, MockLogoutUseCase, MockForgotPasswordUseCase, MockGetCachedUserUseCase, MockGoogleSignInUseCase, MockAuthRemoteDataSource, MockAuthLocalDataSource, MockGoogleSignIn, MockGoogleSignInAccount, MockSharedPreferences |
| **Attendance** | MockAttendanceRepository, MockGetAttendanceStatusesUseCase, MockGetCurrentAttendanceUseCase, MockCheckInUseCase, MockUpdateAttendanceStatusUseCase, MockCheckOutUseCase, MockGetAttendanceScheduleUseCase, MockAttendanceRemoteDataSource, MockAttendanceLocalDataSource, MockAttendanceTimerService |
| **KPI** | MockKpiRepository, MockGetKpiDefinitionsUseCase, MockGetKpiEntriesUseCase, MockUpsertKpiEntryUseCase, MockDeleteKpiEntryUseCase, MockKpiLocalDataSource, MockKpiRemoteDataSource |
| **Profile** | MockProfileRepository, MockGetPersonalDetailsUseCase, MockGetProfessionalDetailsUseCase, MockGetProfileCompletenessUseCase, MockUpdatePersonalDetailsUseCase, MockUpdateProfessionalDetailsUseCase, MockProfileRemoteDataSource, MockProfileLocalDataSource |

### Fixtures (`test/fixtures/`)

Each fixture file provides:
- **Sample entities** — pre-built domain objects for assertions
- **Sample models** — pre-built data models for serialization tests
- **Sample JSON** — `Map<String, dynamic>` mimicking API responses

| Fixture File | Contents |
|-------------|----------|
| `auth_fixtures.dart` | `tUserEntity`, `tUserModel`, `tUserJson`, `tAuthResponseEntity` |
| `attendance_fixtures.dart` | `tStatusEntity`, `tCurrentEntity`, `tScheduleEntity`, status/current/schedule JSON maps |
| `kpi_fixtures.dart` | `tDefinitionEntity`, `tEntryEntity`, `tNoteEntity`, definition/entry/note JSON maps |
| `profile_fixtures.dart` | `tProfileEntity`, `tExperienceEntity`, `tEducationEntity`, `tSkillEntity`, profile/experience/education/skill JSON maps |

---

## Writing New Tests

### Adding a Test for a New BLoC

1. **Create mock classes** in `test/helpers/mocks.dart` for any new use cases or data sources
2. **Create fixtures** in `test/fixtures/<feature>_fixtures.dart` with sample entities and JSON
3. **Create test file** at `test/features/<feature>/presentation/bloc/<name>_bloc_test.dart`
4. **Follow the pattern:**

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Import BLoC, events, states, use cases, fixtures, mocks

void main() {
  late MockSomeUseCase mockUseCase;

  setUpAll(() {
    registerFallbackValue(const SomeParams());
  });

  setUp(() {
    mockUseCase = MockSomeUseCase();
  });

  FeatureBloc buildBloc() => FeatureBloc(someUseCase: mockUseCase);

  group('LoadRequested', () {
    blocTest<FeatureBloc, FeatureState>(
      'emits [Loading, Loaded] on success',
      build: () {
        when(() => mockUseCase(any()))
            .thenAnswer((_) async => Right(tData));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadRequested()),
      expect: () => [FeatureLoading(), FeatureLoaded(data: tData)],
    );

    blocTest<FeatureBloc, FeatureState>(
      'emits [Loading, Error] on failure',
      build: () {
        when(() => mockUseCase(any()))
            .thenAnswer((_) async => const Left(ServerFailure()));
        return buildBloc();
      },
      act: (bloc) => bloc.add(LoadRequested()),
      expect: () => [
        FeatureLoading(),
        const FeatureError(message: 'Server error'),
      ],
    );
  });
}
```

### Adding a Test for a New Repository

```dart
void main() {
  late MockRemoteDataSource mockRemoteDataSource;
  late FeatureRepositoryImpl repository;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    repository = FeatureRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('someMethod', () {
    test('returns Right(data) on success', () async {
      when(() => mockRemoteDataSource.someMethod())
          .thenAnswer((_) async => tModel);

      final result = await repository.someMethod();

      expect(result, isA<Right>());
    });

    test('returns AuthFailure on AuthException', () async {
      when(() => mockRemoteDataSource.someMethod())
          .thenThrow(const AuthException());

      final result = await repository.someMethod();

      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('Expected failure'),
      );
    });

    // Repeat for NetworkException, ServerException, catch-all
  });
}
```

### Adding a Test for a New Model

```dart
void main() {
  group('FeatureModel', () {
    test('fromJson creates valid model', () {
      final model = FeatureModel.fromJson(tJson);
      expect(model.id, '1');
      expect(model.name, 'Test');
    });

    test('fromJson handles null fields', () {
      final model = FeatureModel.fromJson({'id': '1'});
      expect(model.name, isNull);
    });

    test('toJson produces correct map', () {
      final json = tModel.toJson();
      expect(json['id'], '1');
      expect(json['name'], 'Test');
    });

    test('fromJson/toJson round-trip preserves data', () {
      final json = tModel.toJson();
      final restored = FeatureModel.fromJson(json);
      expect(restored.id, tModel.id);
      expect(restored.name, tModel.name);
    });
  });
}
```

---

## Coverage Summary

| Category | Files | Tests | Features Covered |
|----------|-------|-------|-----------------|
| BLoC / Cubit | 5 | ~80 | Auth, Attendance, KPI, Profile, Settings |
| Repository Impl | 4 | ~60 | Auth, Attendance, KPI, Profile |
| Model Serialization | 4 | ~50 | User, Attendance (3), KPI (3), Profile (9) |
| Use Cases | 4 | ~45 | Auth (6), Attendance (6), KPI (4), Profile (5) |
| Entities | 4 | ~50 | User, Attendance, KPI, Profile (8 sub-entities) |
| Core Utilities | 7 | ~60 | Validators, StringExt, Failures, Exceptions, ApiResponse, ApiEndpoints, StorageKeys |
| **Total** | **28** | **~365** | |

### Not Yet Covered

| Area | Reason | Priority |
|------|--------|----------|
| Widget tests | Higher maintenance cost, requires l10n/theme/BLoC setup | Future |
| Integration tests | Requires device/emulator, API mocking infrastructure | Future |
| Home feature | Presentation-only (no BLoC/domain/data) | N/A |
| Jobs feature | Removed from codebase | N/A |
| Essential Info | Scaffolded only, no implementation | N/A |
| Dashboard | Scaffolded only, no implementation | N/A |

---

## Best Practices

1. **One concern per test** — each test verifies exactly one behavior
2. **Descriptive names** — use `'emits [Loading, Loaded] when load succeeds'` format
3. **`setUp` for fresh mocks** — avoid shared state between tests
4. **`setUpAll` for fallback values** — register `mocktail` fallback values once
5. **Builder functions** — use `buildBloc()` helpers to construct the system under test
6. **Test both paths** — always test success (`Right`) and failure (`Left`) for `Either` returns
7. **Verify interactions** — use `verify(() => mock.method()).called(1)` to confirm delegation
8. **Group related tests** — use `group()` blocks to organize by event/method
9. **Fixtures over inline data** — use shared fixture files to keep tests DRY
10. **No test interdependence** — each test must pass independently and in any order
