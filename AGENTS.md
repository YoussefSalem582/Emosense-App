# Technology 92 App — Agent Instructions

> **Scope**: Only modify files inside `technology_ninety_two_app/`.
> The sibling directories `technology_ninety_two_backend-main/` and `technology_ninety_two_front_end-main/` are read-only reference repos — never edit them.

## Project Overview

Flutter job marketplace app (Android + iOS).

- **Architecture**: Clean Architecture + BLoC
- **State**: `flutter_bloc` (BLoC for features, Cubit for simple state)
- **Routing**: GoRouter — use `RouteNames` constants, never hardcode paths
- **DI**: GetIt + injectable — register in `injection_container.dart`
- **Networking**: Dio via `ApiClient` wrapper with auth/language/logging/retry interceptors
- **Storage**: `FlutterSecureStorage` for tokens, `SharedPreferences` for preferences
- **Secrets**: `--dart-define` at build time + `EnvConfig` — never hardcode secrets
- **Auth**: Email/password + Google Sign-In (`google_sign_in` → backend OAuth exchange)
- **Localization**: ARB-based (English + Arabic) via `context.l10n`
- **Firebase**: Firebase Core for analytics/crashlytics foundation
- **Monitoring**: Sentry (`sentry_flutter`) for error tracking and performance monitoring
- **Offline-First**: `ConnectivityCubit` + `CachePolicy` (TTL tiers) + `OfflineQueue` (mutation queue)
- **Background Tasks**: `flutter_foreground_task` for attendance timer lock-screen notification
- **Platform**: Windows 11 development environment

## Key Entry Points

| File | Purpose |
|------|---------|
| `lib/main.dart` | App start: inits Firebase, DI, Sentry |
| `lib/app.dart` | MaterialApp + GoRouter setup |
| `lib/injection_container.dart` | GetIt registration |
| `lib/core/api/api_endpoints.dart` | All API path constants |
| `lib/config/routes/route_names.dart` | All route name constants |

## Feature Architecture

Every feature lives under `lib/features/<name>/` with three layers:

```
features/<name>/
├── data/
│   ├── datasources/     # Remote/local data sources (ApiClient calls)
│   ├── models/          # Extend entities; add fromJson/toJson
│   └── repositories/    # Implement domain contracts
├── domain/
│   ├── entities/        # Pure Dart + Equatable — no serialization
│   ├── repositories/    # Abstract contracts → Either<Failure, T>
│   └── usecases/        # One file per operation, extend UseCase<T, Params>
└── presentation/
    ├── bloc/            # *_bloc.dart, *_event.dart, *_state.dart (separate files)
    ├── pages/           # Full-screen widgets
    └── widgets/         # Feature-specific UI
```

**Dependency rule**: Presentation → Domain ← Data. Domain has zero Flutter imports.

## Design Tokens — Never Hardcode

| Category | Use | Never |
|----------|-----|-------|
| Colors | `AppColors.primary`, `AppColors.error` | `Color(0xFF...)`, `Colors.blue` |
| Text | `AppTextStyles.bodyLarge`, `AppTextStyles.titleMedium` | raw `TextStyle(...)` |
| Spacing | `AppSpacing.base`, `AppSpacing.pagePadding` | raw `16.0` |
| Radius | `AppRadius.md`, `AppRadius.lg` | raw `BorderRadius.circular(8)` |
| Assets | `AppImages.logo`, `AppIcons.settings` | `'assets/images/logo.png'` |
| Routes | `RouteNames.home`, `RouteNames.login` | `'/home'` |

**Spacing scale**: xxs=2, xs=4, sm=8, md=12, base=16, lg=20, xl=24, xxl=32, xxxl=40, huge=48, massive=64

**Radius scale**: xs=4, sm=6, md=8, base=10, lg=12, xl=16, xxl=20, round=100

## State Management (BLoC)

```dart
// Event (features/*/presentation/bloc/*_event.dart)
abstract class FeatureEvent extends Equatable { const FeatureEvent(); }
class LoadData extends FeatureEvent { @override List<Object?> get props => []; }

// State (features/*/presentation/bloc/*_state.dart)
abstract class FeatureState extends Equatable { const FeatureState(); }
class FeatureInitial extends FeatureState {}
class FeatureLoading extends FeatureState {}
class FeatureLoaded extends FeatureState {
  final DataType data;
  const FeatureLoaded({required this.data});
  @override List<Object?> get props => [data];
}
class FeatureError extends FeatureState {
  final String message;
  const FeatureError({required this.message});
  @override List<Object?> get props => [message];
}

// BLoC (features/*/presentation/bloc/*_bloc.dart)
class FeatureBloc extends Bloc<FeatureEvent, FeatureState> {
  FeatureBloc({required this.useCase}) : super(FeatureInitial()) {
    on<LoadData>(_onLoad);
  }
  Future<void> _onLoad(LoadData event, Emitter<FeatureState> emit) async {
    emit(FeatureLoading());
    final result = await useCase(params);
    result.fold(
      (failure) => emit(FeatureError(message: failure.message)),
      (data)    => emit(FeatureLoaded(data: data)),
    );
  }
}
```

- `BlocBuilder` for UI rebuilds, `BlocListener` for side effects, `BlocConsumer` for both
- `context.read<FeatureBloc>().add(event)` to dispatch; `context.watch<FeatureBloc>().state` to read
- Log transitions: `AppLogger.logBlocTransition('FeatureBloc', event, currentState)`

## Offline-First Architecture

The app is offline-first. All code touching network or cache must respect these conventions.

### Connectivity

- `ConnectivityCubit` (in `core/network/`) is globally provided in `app.dart`
- Read current status: `context.read<ConnectivityCubit>().state.isOnline`
- `MainShell` auto-syncs all BLoCs on offline→online transition (2s debounce)

### Cache TTL (reads)

Use `CachePolicy` from `core/network/cache_policy.dart` in BLoC load handlers:

| Tier | Age | Behaviour |
| ---- | --- | --------- |
| `fresh` | < 5 min | Return cache, skip API call |
| `stale` | 5 min – 24 h | Return cache immediately, refresh in background |
| `expired` | > 24 h | Show loading, must fetch from API |

### Offline Queue (writes)

Mutation operations (POST/PUT/PATCH/DELETE) must use `OfflineQueue` when offline:
- Queue is SharedPreferences-backed and persists across app restarts
- `OfflineQueueProcessor` processes the queue on reconnect
- Max 3 retries per item; failed items are discarded after exhausting retries

## API Integration

1. Add path constant to `lib/core/api/api_endpoints.dart`
2. Add method to remote data source using `ApiClient` (get/post/put/patch/delete/uploadFile)
3. Parse with `ApiResponse.fromJson()` — backend envelope: `{ "success": bool, "message": str, "data": any }`
4. Create/update model with `fromJson`/`toJson` (snake_case JSON → camelCase Dart)
5. Add method to domain repository contract returning `Either<Failure, T>`
6. Implement in repository with exception → failure mapping:
   - `AuthException` → `AuthFailure`, `NetworkException` → `NetworkFailure`, `ServerException` → `ServerFailure`
7. Create use case extending `UseCase<ReturnType, Params>`
8. Wire into BLoC; register all in `injection_container.dart`

## DI Registration

```dart
// injection_container.dart
sl.registerLazySingleton(() => FeatureRemoteDataSource(apiClient: sl()));
sl.registerLazySingleton<FeatureRepository>(() => FeatureRepositoryImpl(dataSource: sl()));
sl.registerLazySingleton(() => GetFeatureUseCase(repository: sl()));
sl.registerFactory(() => FeatureBloc(useCase: sl()));  // Factory — new instance per screen
```

## Localization

- All user-facing strings: `context.l10n.someKey`
- Add to **both** `lib/l10n/arb/app_en.arb` and `lib/l10n/arb/app_ar.arb`
- Run `flutter gen-l10n` after every ARB change
- Never use raw strings in UI widgets

## Security

- **Never hardcode** API URLs, tokens, client IDs, keys in Dart source
- Secrets live in `.env` (git-ignored); access only via `EnvConfig.baseUrl`, `EnvConfig.googleClientId`, etc.
- Add placeholders to `.env.example` (committed)
- Auth tokens → `FlutterSecureStorage` with `encryptedSharedPreferences: true`; never `SharedPreferences`
- Storage key strings centralized in `core/constants/storage_keys.dart`

## Shared Widgets

Always check `lib/shared/widgets/` before building new UI:

**Inputs**: `AppTextField`, `AppPhoneField`, `AppDropdownField`, `AppSearchableDropdownField`, `AppDateField`, `AppDateInputSheet`
**Buttons**: `AppButton`
**Cards**: `AppCard`
**Dialogs**: `AppBottomSheet`, `UnsavedChangesDialog`
**Banners**: `ConnectivityBanner`, `OfflineBanner`, `AppToast`, `TranslationPendingBanner`
**Filters**: `AppDateFilter`, `FilterIconButton`, `FilterSheetActions`
**Feedback**: `AppLoading`, `AppErrorWidget`, `EmptyStateWidget`
**Layout**: `CustomAppBar`, `ResponsiveLayout`, `AuthPatternBackground`
**Viewers**: `PdfViewerPage`, `VideoPlayerPage`, `PhotoPickerBottomSheet`

## Naming Conventions

| Item | Convention |
|------|-----------|
| Files | `snake_case.dart` |
| Classes | `PascalCase` |
| Variables/functions | `camelCase` |
| Constants | `camelCase` (not SCREAMING_CASE) |
| Private members | `_prefixed` |

## Mandatory Documentation (after every change)

1. `CHANGELOG.md` — add entry under the current version (Keep a Changelog format)
2. `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — dated entry at top
3. `tech_readme_files/CURRENT_STATUS.md` — update feature status and metrics

## Agent tooling layout (repository root)

| Path | Purpose |
|------|---------|
| `.agents/` | Agent rules (`rules/`) and skills (`skills/`) |
| `.claude/` | Claude Code settings and slash commands (`commands/`) |
| `.claude/settings.json` | Shared Claude Code permissions (must not contain secrets) |
| `.claude/settings.local.json` | Local-only permissions/overrides (**gitignored** — paths or sensitive allow rules) |
| `.cursor/` | Cursor rules (`rules/`) and skills (`skills/`) |
| `.agentignore` | Paths excluded from generic agent context |
| `.aiderignore` | Paths excluded for Aider |
| `.claudeignore` | Paths excluded for Claude Code workspace features |
| `.copilotignore` | Paths excluded for Copilot-style tooling |
| `.cursorignore` | Paths excluded from Cursor AI context |
| `.cursorindexingignore` | Paths excluded from Cursor codebase index |
| `.geminiignore` | Paths excluded for Gemini-assisted workflows |
| `.windsurfignore` | Paths excluded for Windsurf |
| `AGENTS.md` | Agent instructions (this file) |
| `CHANGELOG.md` | Project changelog (Keep a Changelog) |
| `CLAUDE.md` | Claude-specific instructions |
| `tech_readme_files/` | Technical documentation guides and status |

**Cross-references:** always-applied rules `project-scope` + `documentation-updates` in `.cursor/rules/` and `.agents/rules/`, assistant `*ignore` headers, `CLAUDE.md`, `.agents/AGENTS.md`, and `tech_readme_files/01_folder_structure.md`.

## Available Skills

| Skill | When to use |
|-------|------------|
| `/add-feature` | Scaffold a complete Clean Architecture feature |
| `/add-api` | Wire a new backend endpoint end-to-end |
| `/add-language` | Add or update localization strings |

Skill prompts live in `.agents/skills/`, `.cursor/skills/`, and `.claude/commands/`.
