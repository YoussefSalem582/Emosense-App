# Claude Instructions

## Response Guidelines

- Be concise — lead with the action or answer, skip preamble
- Do not summarize what you just did; the diff speaks for itself
- Reference files with relative paths (e.g., `lib/core/api/api_endpoints.dart`)
- Ask before creating new files that aren't required by the task
- One task at a time — complete it fully before moving on
- After every meaningful change: update `CHANGELOG.md`, `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`, and `tech_readme_files/CURRENT_STATUS.md`

## Agent tooling layout (repository root)

AI/tooling directories, ignore files, and top-level docs are listed in **`AGENTS.md`** under **Agent tooling layout (repository root)** (same table as in that file). Shared **`.claude/settings.json`** must not contain secrets; use gitignored **`.claude/settings.local.json`** for local-only permission rules (see **`tech_readme_files/08_security_and_environment.md`**).

## Environment

- **Platform**: Windows 11 — use PowerShell syntax in Bash commands, not Unix shell
- **Shell scripts**: Use `.ps1` equivalents (`scripts/build_debug.ps1`, `scripts/build_release.ps1`)
- **Flutter**: SDK on PATH; run via `flutter <command>`
- **Approved commands** (no prompt needed): `flutter pub get`, `flutter gen-l10n`, `flutter analyze`, `flutter test`, `dart format`, `dart run build_runner build`

## Project Scope

**Only work on `technology_ninety_two_app/` (the Flutter mobile app).**

Do NOT modify, create, or delete files in:

- `technology_ninety_two_backend-main/` — Laravel backend (another team)
- `technology_ninety_two_front_end-main/` — Next.js frontend (another team)

These repos are included for reference only (API contracts, route definitions, model schemas). You may read them for context but must never edit them.

## Project Overview

- **App**: Flutter job marketplace mobile application
- **Architecture**: Clean Architecture + BLoC (presentation → domain ← data)
- **State Management**: flutter_bloc
- **Routing**: GoRouter with `RouteNames` constants
- **DI**: GetIt + injectable (`injection_container.dart`)
- **Networking**: Dio (`ApiClient` wrapper with interceptors)
- **Local Storage**: SharedPreferences, FlutterSecureStorage
- **Secrets**: `--dart-define` at build time + `EnvConfig` — never hardcode secrets
- **Auth**: Email/password + Google Sign-In (`google_sign_in` → backend OAuth exchange)
- **Localization**: ARB-based l10n (English + Arabic) via `context.l10n`
- **Firebase**: Firebase Core for analytics/crashlytics foundation
- **Monitoring**: Sentry (`sentry_flutter`) for error tracking and performance monitoring
- **Offline-First**: `ConnectivityCubit` + `CachePolicy` (TTL tiers) + `OfflineQueue` (mutation queue)
- **Background Tasks**: `flutter_foreground_task` for attendance timer lock-screen notification

## Entry Points

| File | Purpose |
|------|---------|
| `lib/main.dart` | App entry point (inits Firebase, DI, Sentry) |
| `lib/app.dart` | MaterialApp / GoRouter setup |
| `lib/injection_container.dart` | GetIt DI registration |

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `lib/config/` | env, routes, theme |
| `lib/core/` | api, constants, error, extensions, usecase, utils |
| `lib/core/network/` | Offline-first: `ConnectivityService`, `ConnectivityCubit`, `ConnectivityState`, `CachePolicy`, `OfflineQueue`, `OfflineQueueProcessor` |
| `lib/shared/` | assets, spacing, reusable widgets |
| `lib/features/` | Feature modules (Clean Architecture) |
| `lib/l10n/` | ARB files + generated localizations |

---

## Dart & Flutter Conventions

### Design Tokens — Never Hardcode

- **Colors**: Use `AppColors.primary`, `AppColors.error`, etc. — never `Color(0xFF...)` or `Colors.blue`
- **Typography**: Use `AppTextStyles.bodyLarge`, `AppTextStyles.titleMedium`, etc.
- **Spacing**: Use `AppSpacing.verticalBase`, `AppSpacing.paddingAll16`, `AppSpacing.pagePadding`
- **Radius**: Use `AppRadius.md`, `AppRadius.lg`, etc.
- **Assets**: Use `AppImages.logo`, `AppIcons.settings` — never hardcode asset paths
- **Routes**: Use `RouteNames.home`, `RouteNames.login` — never hardcode path strings

### Localization

- All user-facing strings go through `context.l10n.someKey`
- Add keys to BOTH `lib/l10n/arb/app_en.arb` and `lib/l10n/arb/app_ar.arb`
- Run `flutter gen-l10n` after adding keys

### Import Order

1. Dart SDK (`dart:`)
2. Flutter SDK (`package:flutter/`)
3. Third-party packages (`package:`)
4. Project imports (relative)

### Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` (Dart convention, not SCREAMING_CASE)
- Private members: `_prefixed`

### Error Extensions

Use `context.showError()`, `context.showSuccess()` from `context_extensions.dart`.

### Storage Keys

Centralize all storage key strings in `core/constants/storage_keys.dart`.

---

## Design System

### Colors (from `AppColors`)

- **Primary**: `#5B6EF5` — Brand blue (buttons, links, active states)
- **Primary variants**: `primaryLight` (#8B96F9), `primaryDark` (#3D4ED4), `primaryTint` (#EEF0FE)
- **Secondary**: `#E9C62B` — Accent yellow
- **Background**: `backgroundLight` (#F2F2F7), `backgroundDark` (#000000)
- **Surfaces**: iOS-style dark hierarchy — `darkSurface` (#1C1C1E), `darkCard` (#2C2C2E), `darkSurfaceContainerHigh` (#3A3A3C)
- **Frosted Glass**: `frostedLight`, `frostedDark`, `frostedBorderLight`, `frostedBorderDark`
- **Separators**: `separator` (#C6C6C8), `opaqueSeparator` (#D8D8DC)
- **Neutrals**: `neutral100`–`neutral500` (iOS system grays)
- **Status**: `success` (#34C759), `error` (#FF3B30), `warning` (#FF9500), `info` (#5AC8FA) — each with light variant
- **Shimmer**: `shimmerBase`/`shimmerHighlight` (light + dark variants)

Always use `AppColors.primary`, `AppColors.error`, etc. — never raw hex or `Colors.*`.

### Spacing (from `AppSpacing`)

| Token | Value | Usage |
|-------|-------|-------|
| `xxs` | 2 | Tight gaps |
| `xs` | 4 | Icon padding |
| `sm` | 8 | Small gaps |
| `md` | 12 | Medium gaps |
| `base` | 16 | Default spacing |
| `lg` | 20 | Section gaps |
| `xl` | 24 | Large gaps |
| `xxl` | 32 | Section dividers |
| `xxxl` | 40 | Page sections |
| `huge` | 48 | Extra-large gaps |
| `massive` | 64 | Maximum spacing |

Helpers: `AppSpacing.verticalBase`, `AppSpacing.horizontalSM`, `AppSpacing.pagePadding`, `AppSpacing.screenPadding`

### Radius (from `AppRadius`)

| Token | Value |
|-------|-------|
| `xs` | 4 |
| `sm` | 6 |
| `md` | 8 |
| `base` | 10 |
| `lg` | 12 |
| `xl` | 16 |
| `xxl` | 20 |
| `round` | 100 |

### Typography (from `AppTextStyles`)

- Font: PublicSans (EN) / Tajawal (AR) — locale-aware via `AppFonts.forLocale`; fallback: Roboto
- Material Design type scale: `displayLarge` → `labelSmall`
- iOS HIG-inspired: negative `letterSpacing` on headlines, increased `fontWeight` contrast
- Use `AppTextStyles.bodyLarge`, `AppTextStyles.titleMedium`, etc.

### Shared Widgets

Check `lib/shared/widgets/` before building new UI. Existing components:

**Inputs**: `AppTextField`, `AppPhoneField`, `AppDropdownField`, `AppSearchableDropdownField`, `AppDateField`, `AppDateInputSheet`
**Buttons**: `AppButton`
**Cards**: `AppCard`
**Dialogs**: `AppBottomSheet`, `UnsavedChangesDialog`
**Banners**: `ConnectivityBanner`, `OfflineBanner`, `AppToast`, `TranslationPendingBanner`
**Filters**: `AppDateFilter`, `FilterIconButton`, `FilterSheetActions`
**Feedback**: `AppLoading`, `AppErrorWidget`, `EmptyStateWidget`
**Layout**: `CustomAppBar`, `ResponsiveLayout`, `AuthPatternBackground`
**Viewers**: `PdfViewerPage`, `VideoPlayerPage`, `PhotoPickerBottomSheet`

---

## Feature Architecture (Clean Architecture + BLoC)

Each feature in `lib/features/` follows three layers: `data/ → domain/ ← presentation/`

### Folder Structure

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

### Dependency Rule

Dependencies only point inward: `Presentation → Domain ← Data`

- **Domain**: Zero Flutter imports. Only `dart:core`, `equatable`, `dartz`.
- **Data**: Implements domain contracts. Uses `ApiClient`, maps exceptions → failures.
- **Presentation**: Talks to Domain through Use Cases only.

### Domain Layer Rules

- Entities extend `Equatable` — no `fromJson`/`toJson`
- Repository contracts are abstract classes returning `Either<Failure, T>`
- Use cases extend `UseCase<ReturnType, Params>` — one file per operation
- Use `NoParams` when no input is needed

### Data Layer Rules

- Models extend their entity and add `fromJson(Map<String, dynamic>)` / `toJson()`
- `fromJson` maps backend snake_case JSON keys to camelCase Dart fields
- Remote data sources use `ApiClient` (get, post, put, patch, delete, uploadFile)
- Repository impls wrap calls in try/catch and map exceptions to failures:
  - `AuthException` → `AuthFailure`
  - `NetworkException` → `NetworkFailure`
  - `ServerException` → `ServerFailure`
  - catch-all → `UnexpectedFailure`

### Presentation Layer Rules

- BLoC receives events, calls use cases, emits states
- Events and states in separate files, extend `Equatable`
- Use `result.fold()` to map Either to success/error states
- Log transitions via `AppLogger.logBlocTransition()`

### DI Registration

In `injection_container.dart`:

- Data sources, repos, use cases → `registerLazySingleton`
- BLoCs → `registerFactory` (new instance per provider)
- Add `BlocProvider` in `app.dart`

---

## BLoC & Cubit Patterns

### File Organization

Each BLoC/Cubit has separate files:

- `<name>_bloc.dart` — The BLoC class
- `<name>_event.dart` — Event classes (BLoC only)
- `<name>_state.dart` — State classes

### Event Pattern

```dart
abstract class FeatureEvent extends Equatable {
  const FeatureEvent();
  @override
  List<Object?> get props => [];
}

class LoadData extends FeatureEvent {}

class ActionWithParams extends FeatureEvent {
  final int id;
  const ActionWithParams({required this.id});
  @override
  List<Object?> get props => [id];
}
```

### State Pattern

```dart
abstract class FeatureState extends Equatable {
  const FeatureState();
  @override
  List<Object?> get props => [];
}

class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final DataType data;
  const FeatureLoaded({required this.data});
  @override
  List<Object?> get props => [data];
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError({required this.message});
  @override
  List<Object?> get props => [message];
}
```

### BLoC Pattern

```dart
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  final SomeUseCase someUseCase;

  FeatureBloc({required this.someUseCase}) : super(FeatureInitial()) {
    on<LoadData>(_onLoad);
  }

  Future<void> _onLoad(LoadData event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    final result = await someUseCase(params);
    result.fold(
      (failure) => emit(FeatureError(message: failure.message)),
      (data) => emit(FeatureLoaded(data: data)),
    );
  }

  @override
  void onTransition(Transition<FeatureEvent, FeatureState> transition) {
    AppLogger.logBlocTransition('FeatureBloc', transition.event, transition.currentState);
    super.onTransition(transition);
  }
}
```

### UI Usage

- `BlocBuilder<Bloc, State>` for rebuilding UI on state changes
- `BlocListener<Bloc, State>` for side effects (navigation, snackbars)
- `BlocConsumer` when you need both
- Access BLoC via `context.read<FeatureBloc>()` for events
- Access state via `context.watch<FeatureBloc>().state` in build methods

---

## API Integration

### Adding a New Endpoint

1. Define path in `lib/core/api/api_endpoints.dart`
   - Static: `static const String name = '/path';`
   - Dynamic: `static String name(int id) => '/path/$id';`
   - Group related endpoints under comment banners
   - Paths do NOT include base URL or `/api/v1` prefix (handled by ApiClient)

2. Add HTTP call to remote data source using `ApiClient`
3. Parse response with `ApiResponse.fromJson()`
4. Create/update model with `fromJson`/`toJson`
5. Add method to domain repository contract (returns `Either<Failure, T>`)
6. Implement in repository impl with exception-to-failure mapping
7. Create use case
8. Wire into BLoC
9. Register in `injection_container.dart`

### ApiClient Methods

| Method | Signature |
|--------|-----------|
| GET | `apiClient.get(path, {queryParameters})` |
| POST | `apiClient.post(path, {data})` |
| PUT | `apiClient.put(path, {data})` |
| PATCH | `apiClient.patch(path, {data})` |
| DELETE | `apiClient.delete(path)` |
| Upload | `apiClient.uploadFile(path, {file, fieldName, data})` |

All return `Response<dynamic>`. Parse with `ApiResponse.fromJson()`.

### Backend Response Format

Success: `{ "success": true, "message": "...", "data": ..., "pagination": {...} }`
Error: `{ "success": false, "message": "...", "errors": {} }`
Validation (422): `{ "message": "...", "errors": { "field": ["msg"] } }`

### Error Flow

API error → `ApiClient` catches `DioException` → maps to Exception (`ServerException`, `AuthException`, `NetworkException`) → Repository catches Exception → maps to Failure → wrapped in `Left<Failure, T>` → BLoC folds into error state → UI displays error

### Interceptors (automatic)

1. **Auth**: Adds `Authorization: Bearer <token>` from SecureStorage
2. **Language**: Adds `lang` and `Accept-Language` headers
3. **Logging**: `TalkerDioLogger` (disabled in production)
4. **Retry**: `RetryInterceptor` — auto-retries failed GET requests (2 retries, 1s/3s backoff) on transient network errors and 5xx responses. Mutations are NOT retried; they go through `OfflineQueue`.

---

## Offline-First Architecture

The app is offline-first. All code touching network or cache must respect these conventions.

### Connectivity

- `ConnectivityCubit` (in `core/network/`) is globally provided in `app.dart`
- Read current status: `context.read<ConnectivityCubit>().state.isOnline`
- Listen for changes: `BlocListener<ConnectivityCubit, ConnectivityState>`
- `MainShell` auto-syncs all BLoCs on offline→online transition (2s debounce)

### Cache TTL (reads)

Use `CachePolicy` from `core/network/cache_policy.dart` in BLoC load handlers:

```dart
final policy = CachePolicy.evaluate(cachedAt: snapshot.cachedAt);
if (policy == CacheTier.fresh) {
  emit(FeatureLoaded(data: snapshot.data)); // skip API
  return;
}
// stale: emit cached data, then fetch in background
// expired: fetch only, show loading
```

| Tier | Age | Behaviour |
| ---- | --- | --------- |
| `fresh` | < 5 min | Return cache, skip API call |
| `stale` | 5 min – 24 h | Return cache immediately, refresh in background |
| `expired` | > 24 h | Show loading, must fetch from API |

TTL constants live in `AppConstants` (`cacheFreshDuration`, `cacheExpiredDuration`).

### Offline Queue (writes)

Mutation operations (POST/PUT/PATCH/DELETE) must use `OfflineQueue` when offline:

```dart
final isOnline = context.read<ConnectivityCubit>().state.isOnline;
if (!isOnline) {
  await offlineQueue.enqueue(OfflineAction(type: 'feature_action', payload: {...}));
  emit(FeatureQueued()); // optimistic UI
  return;
}
// proceed with API call normally
```

- Queue is SharedPreferences-backed and persists across app restarts
- `OfflineQueueProcessor` (registered in DI) processes the queue on reconnect
- Handler registration: `offlineQueueProcessor.registerHandler('action_type', handler)`
- Max 3 retries per item; failed items are discarded after exhausting retries

### What NOT to do

- Never make API calls without checking connectivity first for write operations
- Never bypass `CachePolicy` — always check cache freshness before fetching
- Never use `SharedPreferences` directly for the queue — use `OfflineQueue`

---

## Security Conventions

- **Never hardcode** API URLs, tokens, client IDs, or any secret in Dart source
- All secrets are passed via `--dart-define` at build time and accessed via `EnvConfig` getters
- Add placeholders for new secrets to `.env.example` (committed to git) and to build scripts
- Auth tokens MUST use `FlutterSecureStorage` (`encryptedSharedPreferences: true`), NOT `SharedPreferences`
- Storage key strings are centralized in `core/constants/storage_keys.dart`
- Release builds use `scripts/build_release.ps1` (`--obfuscate --split-debug-info`)
- See `tech_readme_files/08_security_and_environment.md` for full details

### Environment Config

Access secrets only through `EnvConfig`:

- `EnvConfig.baseUrl`
- `EnvConfig.apiVersion`
- `EnvConfig.googleClientId`
- `EnvConfig.sentryDsn`
- `EnvConfig.current.isProduction` / `EnvConfig.current.enableLogging`

### Token Storage

```dart
// CORRECT — FlutterSecureStorage
final token = await secureStorage.read(key: StorageKeys.accessToken);

// WRONG — SharedPreferences (insecure for tokens)
final token = prefs.getString('token');
```

---

## Features (`lib/features/`)

Each feature follows Clean Architecture: `data/ → domain/ ← presentation/`

| Feature | Layers | Key Pages |
|---------|--------|-----------|
| `auth/` | Sub-features: `auth_select/`, `essential_data/`, `essential_info/`, `forgot_password/`, `language_select/`, `login/`, `onboarding/`, `register/`, `shared/`, `splash/` | Splash, Language Select, Onboarding, Auth Select, Login, Register, Forgot Password, Google Sign-In, Essential Data Wizard, Essential Info review |
| `home/` | presentation only | Main shell (bottom nav + ConnectivityBanner + auto-sync), Home dashboard with real-time stats |
| `profile/` | Sub-features: `shared/` (data/domain), `profile_view/`, `edit_profile/` | Profile view, Edit profile (photo upload, personal/professional/summary forms, specialty) |
| `attendance/` | data (+ services), domain, presentation | Clock in/out, live timer, status management; check-in/out queued offline via `OfflineQueue` |
| `kpi/` | data, domain, presentation | KPI definitions, entries CRUD, date filter, skeleton, notes display; upsert/delete queued offline |
| `settings/` | presentation, cubit | Settings page (theme, locale, about us, contact, privacy/terms, app info, dev options, delete account, logout) |

### Feature-Specific Widgets

| Widget | File | Description |
|--------|------|-------------|
| `AuthHeader` | `features/auth/shared/presentation/widgets/auth_header.dart` | Logo + title + subtitle for auth pages |
| `SocialLoginButton` | `features/auth/shared/presentation/widgets/social_login_button.dart` | Google / Apple / LinkedIn button |
| Auth onboarding widgets | `features/auth/onboarding/presentation/widgets/` | 6 widgets (nav buttons, data, dot indicator, progress, header, page content) |
| Auth essential data widgets | `features/auth/essential_data/presentation/widgets/` | 5 widgets (name step, age/nationality step, specialty/phone step, resume step, wizard skeleton) |
| Auth essential info widgets | `features/auth/essential_info/presentation/widgets/` | 2 widgets (field row, skeleton) |
| Auth register widgets | `features/auth/register/presentation/widgets/` | 3 widgets (form fields, footer, avatar picker) |
| Home widgets | `features/home/presentation/widgets/` | 7 widgets (greeting header, attendance card, quick actions, stats row, recent KPIs, recent attendance, page skeleton) |
| Profile widgets | `features/profile/profile_view/presentation/widgets/profile/` | 9 section cards (personal, professional, education, experience, skills, resume, video, summary, completeness) |
| Edit profile widgets | `features/profile/edit_profile/presentation/widgets/` | 11 form/tab sections + 4 CRUD dialogs (add skill, delete confirm, education form, experience form) |
| Common profile widgets | `features/profile/shared/presentation/widgets/common/` | Shared helpers (header, info row, section card, date helpers) |
| Profile skeletons | `features/profile/shared/presentation/widgets/skeletons/` | Skeleton placeholders for profile and edit profile pages |
| Attendance widgets | `features/attendance/presentation/widgets/` | 5 widgets (timer card, status selector, action button, schedule section, page skeleton) |
| KPI widgets | `features/kpi/presentation/widgets/` | 5 widgets (add entry sheet, filter sheet, delete dialog, entry card, page skeleton) |
| Settings widgets | `features/settings/presentation/widgets/` | 11 widgets (theme, language, user card, account, about, contact, dev options, section header, tile, app info dialog, app changelog data) |

---

## Documentation Updates (Mandatory)

Documentation lives in `technology_ninety_two_app/tech_readme_files/`. The changelog is at `technology_ninety_two_app/CHANGELOG.md`.

### After EVERY feature, fix, refactor, or meaningful change, you MUST update

1. **`CHANGELOG.md`** — Add the change under the correct version's `### Added`, `### Changed`, or `### Fixed` section. Follow [Keep a Changelog](https://keepachangelog.com/) format.
2. **`tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`** — Add a dated entry at the top documenting: what changed, files created, files modified, key decisions.
3. **`tech_readme_files/CURRENT_STATUS.md`** — Update feature status, metrics, progress, and any new sections.

### Conditional updates (only when relevant)

| File | Update when... |
|------|-------|
| `01_folder_structure.md` | Adding/removing/moving files or folders |
| `02_architecture.md` | Changing architecture patterns or layers |
| `03_how_to_add_new_feature.md` | Changing the feature scaffold process |
| `04_how_to_add_new_api.md` | Changing API integration patterns |
| `05_how_to_add_new_language.md` | Adding languages or changing l10n setup |
| `06_how_to_change_theme_colors.md` | Adding design tokens or changing theme |
| `07_how_to_create_reusable_component.md` | Adding/changing shared widgets |
| `08_security_and_environment.md` | Adding secrets, changing auth/security |
| `09_api_endpoints.md` | Adding/changing API endpoints |

## Build Scripts (`scripts/`)

> **Windows**: Use `.ps1` scripts. Unix `.sh` equivalents exist for CI/Mac.

| Script | Purpose | Example |
|--------|---------|---------|
| `scripts/build_release.ps1` | Obfuscated release build | `.\scripts\build_release.ps1 apk` |
| `scripts/build_debug.ps1` | Debug build / run / utilities | `.\scripts\build_debug.ps1 run` |

## Custom Commands

Slash commands use `.claude/commands/`; shared skills also live in `.agents/skills/` and `.cursor/skills/` (see **`AGENTS.md`** — Agent tooling layout).

| Command | Description |
|---------|-------------|
| `/add-feature` | Scaffold a complete Clean Architecture feature module |
| `/add-api` | Connect a new backend endpoint end-to-end |
| `/add-language` | Add or update localization strings |
| `/new-screen` | Add a page + BLoC to an existing feature |
| `/review` | Audit code against all project conventions |
| `/test` | Write unit/widget tests for existing code |
| `/update-docs` | Update CHANGELOG, status, and summary docs |
| `/clean-build` | flutter clean + pub get + build_runner + gen-l10n |
