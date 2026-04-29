# Changelog

All notable changes to the Emosense app will be documented in this file. Older releases may refer to Technology 92 in section titles where preserved for history.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Changed

- **Reusable widgets location** — Moved `lib/shared/widgets/` to `lib/core/widgets/` (`package:emosense_mobile/core/widgets/...`).
- **Shell / routing presentation** — Moved `lib/shared/presentation/` to `lib/features/shared/presentation/` (central `screens.dart` barrel, common shell pages, dev screens). Updated imports in `app_router`, `screen_state_manager`, employee dashboard/screen factory.
- **Removed `lib/shared/`** — Deleted the `shared.dart` barrel folder; import **`package:emosense_mobile/core/widgets/widgets.dart`** and **`package:emosense_mobile/features/shared/presentation/screens.dart`** (or specific paths) directly.
- **Documentation & agent tooling** — (1) Emosense/repo-root alignment: removed **`technology_ninety_two_app/`** path prefixes, Cursor globs use **`lib/...`**, DI references **`lib/core/di/dependency_injection.dart`**, staging IDs in **`08_security`/Play**, **`.claude/settings.json`** allowlist roots, ignore-file headers — see prior summary. (2) **Routing accuracy (`AppRouter`):** synced **`AGENTS` / `CLAUDE` / `.agents/AGENTS`**, **`project-scope`**, **`dart-conventions`**, **`add-*` / `new-screen` / `review`**, **`01_folder_structure`** (removed legacy **`jobs/`** subtree), **`02_architecture` §6**, **`03_how_to_add_new_feature`**, **`CURRENT_STATUS`** to **`MaterialApp` + `AppRouter.generateRoute`** (Navigator 1) vs outdated GoRouter/`RouteNames` guidance.
- **`AppConfig` / `.env`** — Removed incorrect **`EnvConfig`** / **`--dart-define`** documentation; **`AGENTS`** / **`CLAUDE`** / **`.agents`** / **`08_security`** / **`09_api`** / **`CURRENT_STATUS`** / **`GOOGLE_PLAY`** now describe **`flutter_dotenv`** + **`AppConfig`** (`lib/main.dart`, `lib/core/config/app_config.dart`).
---

## [0.5.2] - 2026-04-08

### Fixed

- **Claude Code settings** — Removed release keystore credentials from `.claude/settings.json` (they must not live in version control). Added `.claude/settings.local.json` to `.gitignore` for local-only permission overrides. Documented in `AGENTS.md`, `CLAUDE.md`, `.cursor/rules/security.mdc`, `.agents/rules/security.md`, and `tech_readme_files/08_security_and_environment.md`. **Action:** If you used the previous signing password in production, rotate keystore/key passwords and update your local signing config.
- **Currency icon** — Replaced Material `monetization_on_outlined` (dollar sign) with a custom Saudi Riyal SVG icon (`assets/icons/saudi-riyal.svg`) in the edit profile compensation section. Added `prefixWidget` support to `AppDropdownField` for custom SVG prefix icons.- **Edit profile data loss** — Fixed bug where opening the edit profile page during a transient BLoC state (e.g. `ProfileUpdating` from a previous save still completing) showed empty fields, causing data overwrite on next save. Now dispatches `ProfileLoadRequested` when no cached data is available in `initState`.
- **Profile cache field loss** — Fixed `_persistProfileCache` fallback branch that created a minimal `ProfileModel` missing 12 fields (phone, birthDate, gender, nationality, maritalStatus, city, currentLocation, workingAs, workShift, etc.). All entity fields are now preserved in the cache fallback.
- **Attendance missed checkout** — Schedule history entries where the user checked in but never checked out now show a warning icon with "لم يسجل انصراف" label and client-side estimated duration (from check-in to end of work date), instead of misleading `0m`. The backend only calculates live elapsed for today's session; past unclosed sessions return `duration_seconds: 0`.

### Changed

- **`master` merge** — Merged `refactor/tickets-subfeatures` into `master` with DI import reconciliation (feat/auth-stack + employee sub-features + analysis + tickets). Removed duplicate legacy `login_screen` under `presentation/pages/auth/login_screens/`. Post-merge fixes: `login_screen` → `EmployeeNavigationScreen` package path; `ticket_no_params` re-export via `package:emosense_mobile/core/usecases/no_params.dart`. Stopped tracking `.claude/settings.local.json` (remains gitignored).
- **Branch integration (`refactor/tickets-subfeatures`)** — Merged `refactor/employee-sub-features` and `feature/analysis-sub-features` into `refactor/tickets-subfeatures`. Resolved `employee_screen_factory` (employee sub-feature paths + `EmployeeTicketsBloc` / `tickets/employee` page), removed duplicate `employee_screens` barrel under `presentation/pages/`, unified DI imports for analysis sub-features (`text_analysis`, `video_analysis`, `voice_analysis`) with tickets admin/employee registration, and pointed `lib/shared/presentation/screens.dart` at `analysis/shared/presentation/pages/analysis_screens.dart`.
- **Agent tooling layout** — Documented repository-root agent directories, ignore files, and docs (`AGENTS.md` — new "Agent tooling layout" table; skills pointer now includes `.cursor/skills/`). Same table mirrored in `.agents/AGENTS.md`; `CLAUDE.md` links to `AGENTS.md` and notes `.agents/skills/` + `.cursor/skills/` beside `.claude/commands/` in Custom Commands. **Cross-references:** all assistant `*ignore` headers point to `AGENTS.md`; `tech_readme_files/01_folder_structure.md` adds **Agent & AI tooling** and top-level tree lines for agent roots; `.cursor/rules/documentation-updates.mdc` and `.agents/rules/documentation-updates.md` link to the layout table; `.cursor/rules/project-scope.mdc` and `.agents/rules/project-scope.md` include **Agent tooling (repository root)** pointing to `AGENTS.md`.
- **Documentation audit & sync** — Comprehensive audit of all documentation, AI agent rules, and skills files against actual codebase. Fixed 20+ discrepancies accumulated since v0.5.0 iOS refactor:
  - **Colors**: Updated primary from stale `#5C6DB4` to actual `#5B6EF5`, background from `#F8F7FA` to `#F2F2F7` across all docs and rules
  - **New design tokens**: Added frosted glass, separator, neutral, shimmer, dark surface hierarchy tokens to all design system references
  - **Typography**: Added Tajawal (Arabic) font, iOS HIG letter-spacing notes
  - **Spacing**: Added `huge` (48) and `massive` (64) tokens missing from docs
  - **Stale jobs/ references removed**: Feature-Specific Widgets table referenced non-existent `features/jobs/` — replaced with actual auth, home, and attendance widgets
  - **Auth widget paths fixed**: `features/auth/presentation/widgets/` → `features/auth/shared/presentation/widgets/`
  - **Settings widgets**: Fixed count (10 → 11), corrected widget names (removed stale `SettingsGeneralSection`/`SettingsLogoutButton`, added `SettingsAccountSection`/`SettingsDevOptionsSection`)
  - **KPI widgets**: Fixed count from 6 to actual 5
  - **Shared widgets**: Fixed count from 16/18 to actual 26, added full table with all widgets
  - **DI table**: Added missing Connectivity, OfflineQueue, EssentialData, Attendance registrations
  - **Test numbers**: Reconciled metrics (471 test cases / 29 files)
  - **Project Overview**: Added `flutter_foreground_task` and Offline-First to all agent instruction files

---

## [0.5.1] - 2026-04-07

### Fixed

- **Home pull-to-refresh 10s timeout (H1)** — `ProfileLoadRequested` now accepts an optional `Completer<void>` that the BLoC completes in a `finally` block, bypassing Equatable state deduplication that silently swallowed cache-hit emissions. Refresh went from 10007ms → 4ms.
- **Profile refresh crash on deactivated widget (H2)** — Captured `ProfileBloc` reference before async `firstWhere`/timeout so `onTimeout` never accesses a disposed `BuildContext`. Added 10s timeout to both `RefreshIndicator` and `OfflineBanner.onRetry` to prevent indefinite hangs.
- **`setState` after dispose in 7 files (H3)** — Added `mounted` guards after every `await` that precedes `setState`: `register_page.dart`, `attendance_page.dart`, `kpi_page.dart`, `edit_profile_page.dart`, `education_form_dialog.dart`, `experience_form_dialog.dart`.
- **Attendance schedule failure silently ignored (H4)** — `_onLoad` error check now includes `scheduleResult.isLeft()` alongside statuses and current attendance results.
- **KPI upsert/delete errors silently swallowed (H5)** — Added `actionError` field to `KpiLoaded` state; BLoC now emits failure messages and `KpiPage` shows error toasts via `context.showError()`.
- **Attendance status update not queued offline (H6)** — `_onUpdateStatus` now enqueues an `OfflineQueueItem` of type `attendanceStatusUpdate` when offline, matching the existing pattern for check-in/out.
- **Unused `isDark` variable in AppToast (H7)** — Removed dead code.
- **Missing `AuthException` handler in register (H8)** — Added `on AuthException catch` clause in `auth_repository_impl.dart` register method so auth errors map to `AuthFailure` instead of `UnexpectedFailure`.

## [0.5.0] - 2026-04-06

### Added

#### iOS App Store Publishing Setup

- **Bundle ID** — Updated iOS bundle identifier from `com.example.technologyNinetyTwo` (Flutter default placeholder) to `com.technology92.employee` across all Xcode build configurations (Debug, Release, Profile) in `ios/Runner.xcodeproj/project.pbxproj` and `ios/Runner/GoogleService-Info.plist`.
- **iOS Privacy Permissions** — Added required `NSPhotoLibraryUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryAddUsageDescription`, `NSMicrophoneUsageDescription`, and `LSApplicationQueriesSchemes` keys to `ios/Runner/Info.plist` for `image_picker`, `file_picker`, `image_cropper`, and `url_launcher` plugins.
- **ExportOptions.plist** — Created `ios/ExportOptions.plist` for automated `xcodebuild -exportArchive` with App Store export method and automatic code signing. Fill in `YOUR_TEAM_ID` before archiving.

#### Hero Animations

- **Profile avatar hero** — Shared element transition on the user's avatar across three navigation points: `HomeGreetingHeader` (28px) → `ProfileHeader` (44px, bordered) → `EditPersonalTab` (same `ProfileHeader`). The avatar smoothly flies and scales between pages on push/pop. Tag: `profile-avatar`.
- **Settings avatar hero** — The `SettingsUserCard` avatar (30px) also carries the `profile-avatar` hero tag. Navigating from Settings to Profile animates the avatar across the route replacement.
- **Auth logo hero** — The app logo in `AuthHeader` carries `auth-logo` hero tag. Chains across Auth Select → Login → Register → Forgot Password (all connected via `pushNamed`). The logo repositions smoothly as the user moves through the auth flow.
- **Splash → Language Select logo hero** — The splash page logo (220px) and language select logo (160px) share the `auth-logo` tag. On first launch the logo shrinks and repositions as the splash transitions to the language picker.

### Changed

#### iOS-Inspired Full UI/UX Refactor

- **Color palette** — Updated `AppColors` to iOS system colors: softened primary to `#5B6EF5`, added `frostedBackground`/`frostedBorder` tokens for glass effects, introduced `systemGroupedBackground` for iOS-style grouped lists, added `separator`/`opaqueSeparator` colors. Dark mode: true black scaffold (`#000000`), Apple-style layered surfaces (`#1C1C1E`, `#2C2C2E`, `#3A3A3C`).
- **Typography** — Reduced `letterSpacing` on headlines (display → `-1.5`, title → `-0.3`), increased `fontWeight` contrast between hierarchy levels, added `largeTitle` style (34px bold) matching iOS HIG, slightly increased body line height for readability.
- **Light theme** — Zero-elevation `CardThemeData` with 16px radius and subtle borders, transparent `AppBarTheme` with tight title tracking (`-0.05`), 54px elevated buttons with 14px radius, filled `InputDecorationTheme` with `systemGroupedBackground` and 12px radius, 24px top-radius bottom sheets with `showDragHandle: true`, `InkSparkle` splash factory throughout.
- **Dark theme** — Mirrors light theme structure adapted for dark surfaces: true dark scaffold, layered surface containers, maintained contrast ratios, frosted glass tokens.
- **`CustomAppBar`** — Added optional `useBlur` property wrapping AppBar in `ClipRect` + `BackdropFilter` (sigma 20). Chevron-left back button with tooltip. Removed bottom border shadow.
- **`AppButton`** — Height increased to 54px, radius to 14px. Subtle scale-down press animation (`0.97` scale) via `AnimationController`. Loading spinner `valueColor` derived from `foregroundColor`. Outlined variant border based on `foregroundColor.withValues(alpha: 0.3)`.
- **`AppCard`** — Default `elevation: 0` with `AppRadius.borderRadiusXL`. `InkWell` only wraps child when `onTap` is provided. `BorderSide` applied correctly for subtle borders.
- **`AppTextField`** — `prefixIcon` size to 20. `fillColor: systemGroupedBackground`, 12px radius, focus/error border alpha variants.
- **`EmptyStateWidget`** — `Icons.folder_open_outlined` replacing `tray_outlined`. Circular icon container with `surfaceContainerHigh.withValues(alpha: 0.5)` background.
- **`AppLoading`** — `CupertinoActivityIndicator` replacing Material spinner. `AppLoadingOverlay` uses `AbsorbPointer` to block interaction with theme-aware scrim.
- **`AuthPatternBackground`** — Replaced tiled tech-pattern image with subtle `RadialGradient` (primary tint fading to transparent). Eliminates the "AI template" aesthetic.
- **Bottom navigation** — Frosted-glass `BackdropFilter` nav bar (sigma 24) with `frostedLight`/`frostedDark` colors and 0.5px top border. `HapticFeedback.selectionClick()` on tap. Removed pill indicator and box shadows.
- **Splash** — Clean `colorScheme.surface` background, `CupertinoActivityIndicator`, correct light/dark logo asset selection.
- **Language Select** — Fixed `bilingualScheme.primary` reference to `colorScheme.primary`. Updated card backgrounds and border radius.
- **Home dashboard** — Monochrome primary-tint quick-action icons (removed per-action rainbow colors). Unified primary-accent stat cards with simplified percentage display. Tabular-figures timer (`FontFeature.tabularFigures()`). `Material` + `InkWell` replacing `GestureDetector` in greeting header.
- **Profile pages** — Design-token `AppSpacing`/`AppRadius` chips replacing hardcoded values. Flat zero-elevation cards.
- **Settings** — Icon containers reduced to 32px with 0.08 alpha tint. Section headers with `fontWeight: w500` and `letterSpacing: 0.5`.
- **KPI page** — Replaced last hardcoded padding values with `AppSpacing` tokens.

#### UX Refinements

- **Settings account section** — Split Logout and Delete Account into two visually separated sections with extra vertical spacing between them. Logout is now styled as a normal action (no red color) to prevent accidental taps. Delete Account has its own danger-zone section header with red styling and a `warning_amber_rounded` icon in the confirmation dialog.
- **Attendance status chips** — Replaced per-status colored icons and colored text with a small colored dot + neutral `onSurface`/`onSurfaceVariant` text. Both `AttendanceStatusSelector` (attendance page) and `_StatusPicker` (home attendance card) updated. Selected state uses subtle `colorScheme.primary` tint and border instead of per-status rainbow colors. Unselected chips use `surfaceContainer` fill with faint `outlineVariant` border.

### Fixed

- **Bottom navigation overlapping content** — Removed `extendBody: true` from `MainShell`'s `Scaffold`. Content that was hidden behind the frosted nav bar is now fully scrollable and visible.

---

## [0.4.1] - 2026-04-05

### Fixed

- **Force-unwrap of `response.data!` in remote datasources** — 16 call sites across `auth_remote_datasource`, `profile_remote_datasource`, and `essential_data_remote_datasource` would throw an unhandled `NullPointerException` if the backend returned a 2xx envelope with a null `data` field. Added `ApiResponse.requireData()` which throws a typed `ServerException` instead, letting repositories map it to a `ServerFailure` the UI can display.
- **`setState` without `mounted` guard in `experience_form_dialog._fetchCountries`** — Dismissing the dialog mid-fetch could trigger `setState called after dispose`. Added `mounted` check before the success `setState`.
- **`BlocListener` missing `listenWhen` filters** — 5 listeners (`main_shell`, `settings_page`, `profile_page`, `edit_profile_page`, `attendance_page`) fired on every state transition, causing wasted work and potential stale snackbar re-displays. Added targeted `listenWhen` filters so each listener only runs on the exact states it handles.
- **Async `BlocListener` without `context.mounted` check** — `essential_data_wizard_page` and `forgot_password_page` listeners could fire after navigation and crash on `context.read` / `context.showError`. Added `context.mounted` guards.
- **`launchUrl` silently failing in Settings › About** — Privacy policy, terms, and Play Store links had no error handling. Now surfaces a localized error snackbar (`couldNotOpenLink`) on failure.
- **Hardcoded English strings in `AddSkillDialog`** — "to add a skill", "Add", "Added skills appear here", "Skills to add", and the skill count suffix were hardcoded. Replaced with new l10n keys (`toAddASkill`, `addedSkillsAppearHere`, `skillsToAdd`, `skillCountSingular`, `skillCountPlural`) in both `app_en.arb` and `app_ar.arb`.
- **Hardcoded "Session expired" in repository error mappings** — `ProfileRepositoryImpl`, `AttendanceRepositoryImpl`, and `KpiRepositoryImpl` discarded the actual `AuthException.message` (already localized by the backend via the `lang` header). Now forwards `e.message` and `e.statusCode` into `AuthFailure` (39 call sites across the three files).
- **`avatarUrl` operator-precedence ambiguity in `ProfileModel.fromJson`** — `json['avatar_url'] ?? json['image'] as String?` only cast the right-hand value. Wrapped in parentheses so the cast applies to the whole expression.

### Changed

- **Removed 3 dead `OfflineActionType` constants** — `profileUpdatePersonal`, `profileUpdateProfessional`, `profileUpdateSummary` were declared but never enqueued or handled. Removed to avoid confusion.

### Fixed

- **401 interceptor wiping auth token on failed login** — `ApiClient` unconditionally deleted the stored auth token on any 401 response, including wrong-credential login attempts. Now only deletes the token when the request actually carried a Bearer token (session expiry), preventing valid tokens from being wiped by unrelated 401s.
- **Unsafe `value.cast<String>()` in validation error parsing** — Replaced with `whereType<String>()` to safely filter non-string values from backend error arrays instead of throwing a `TypeError`.
- **GoRouter debug logging enabled in production** — `debugLogDiagnostics` was hardcoded to `true`, leaking route information to device logs. Now gated behind `EnvConfig.current.enableLogging`.
- **Route `extra` data lost on deep links** — PDF viewer, video player, and edit profile routes passed data via untyped `state.extra`, which would crash on deep links or process restoration. Migrated to type-safe query parameters.
- **OfflineQueue silently discarding corrupted data** — Queue deserialization errors were caught and swallowed without logging. Now logs errors via `AppLogger.error()`.

### Changed

- **Standardized navigation to use named routes** — Migrated all `context.go('/path')` and `context.push('/path')` calls across 12 files to use `context.goNamed(RouteNames.x)` / `context.pushNamed(RouteNames.x)`, eliminating hardcoded path strings.
- **Removed 12 unused RouteNames constants** — Cleaned up dead code (`resetPassword`, `personalDetails`, `professionalDetails`, `educationList`, `addEducation`, `editEducation`, `experienceList`, `addExperience`, `editExperience`, `skillsList`, `applications`, `notifications`).
- **Consistent page transitions** — PDF viewer and video player routes now use `_buildPage()` custom fade transition instead of plain `MaterialPage`.

### Fixed

- **Attendance status chips not updating on language switch** — When the user changed locale in Settings, attendance status chip labels (Available, Busy, Break, Meal) stayed in the old language because cached API responses retained stale localized strings. Now resets attendance cache and re-fetches on locale change.
- **Attendance notification persists after logout/delete account** — The foreground timer service continued running (and showing a notification) after the user logged out or deleted their account. Now dispatches `AttendanceResetRequested` (which stops the timer) and `KpiResetRequested` on both `AuthUnauthenticated` and `AuthAccountDeleted`.
- **Stale user data shown after account deletion and re-login** — In-memory BLoC caches (Profile, Attendance, KPI) were not reset when `AuthAccountDeleted` was emitted (only `AuthUnauthenticated` was handled). Added `clear()` methods to Attendance and KPI local datasources and call them during BLoC reset so both in-memory and persisted caches are wiped.

- **Google Sign-In errors masked as "Network Error"** — All three auth entry points (login, auth select, register) replaced platform/Google errors with a generic "Network Error" message because `_localizeError` treated every `statusCode == null` error as a network issue. Now shows the actual error message from the BLoC. Also: BLoC catch block now parses `PlatformException` separately (handles `sign_in_canceled` as user cancellation, extracts `e.message` for meaningful feedback), and Google buttons on login/register pages are disabled during loading to prevent double-taps.

- **Stale feature cache shown after account deletion + re-registration** — `clearAuthData()` only cleared auth keys, leaving `profile_cache`, `kpi_cache`, and `attendance_cache` in SharedPreferences. A freshly registered user would see the previous account's data because `CachePolicy` evaluated the stale cache as `fresh` (< 5 min). Added feature cache keys to `StorageKeys` and extended `clearAuthData()` to remove them. Also added `clearAuthData()` before `cacheAuthData()` in `login()`, `register()`, and `googleSignIn()` repository methods to guard against user-switching scenarios.

- **Production environment hardcoded to development** — `EnvConfig.current` was always `_development`, enabling verbose Talker/BLoC logging in release builds. Now uses `kReleaseMode ? _production : _development` so production builds have logging disabled.
- **Cleartext HTTP traffic allowed in production** — `android:usesCleartextTraffic="true"` was set on the main `AndroidManifest.xml`, permitting plain HTTP on release builds. Moved to `debug/AndroidManifest.xml` only; added `network_security_config.xml` enforcing HTTPS-only for production.
- **Sentry tracing at 100% in production** — `tracesSampleRate` was hardcoded to `1.0` regardless of environment. Now `0.2` in production and `1.0` in debug/development.
- **No R8/ProGuard rules for release builds** — Added `proguard-rules.pro` with rules for Flutter engine, OkHttp, Sentry, Google Sign-In, Firebase, and Kotlin coroutines. Enabled `isMinifyEnabled` and `isShrinkResources` in the release build type.

- **Test suite failures (471 tests passing)** — Comprehensive fix for stale test suite after auth restructuring and offline-first architecture additions. Fixed: auth import paths (`auth/domain/` → `auth/shared/domain/`), missing BLoC constructor params (`connectivityCubit`, `offlineQueue`, `deleteAccountUseCase`, `sharedPreferences`), profile model ID type changes (int → String), failure class named params, settings cubit constructor emission capture, profile CRUD reload expectations (`_refreshAfterMutation` no longer emits `ProfileLoading`), and `ConnectivityStatus` mock state stubs.
- **Google Sign-In ApiException: 10 (DEVELOPER_ERROR)** — Two root causes: (1) `GOOGLE_SERVER_CLIENT_ID` in `.env` was from a different Google Cloud project than `google-services.json`, causing the native Google SDK to reject the OAuth configuration. Updated to use the correct web client ID (client_type: 3) from the Firebase project. (2) `GoogleSignIn()` constructor received an empty string as `serverClientId` when the env var wasn't set — now passes `null` to let the plugin fall back to `google-services.json` configuration.
- **New Google Sign-In users skipping essential data screens** — The Google sign-in handler did not set `isFirstTimeEssentialData: true` for first-time users, causing them to skip the essential info review page after the wizard. Now mirrors the registration flow: clears stale `essentialDataComplete` flag and sets `isFirstTimeEssentialData: true` for new users so the router redirects through `/essential-data` → `/essential-info` → `/home`.
- **Google Sign-In using wrong backend endpoint** — App was sending `email`/`name` to the old `/oauth/exchange` endpoint (which timed out). Switched to the new `FlutterGoogleAuthController` endpoints (`/auth/google/sign-in` + `/auth/google/sign-up`) that accept a verified Google `id_token`. Added `serverClientId` to `GoogleSignIn` to obtain the ID token, and the data source now tries sign-in first, falling back to sign-up for new users.

### Added

- **Google Play Data Safety questionnaire plan** — Comprehensive implementation plan document (`tech_readme_files/GOOGLE_PLAY_DATA_SAFETY_PLAN.md`) with exact answers for all 5 Data Safety form steps, complete data inventory (50+ data points), third-party service disclosures (Sentry, Firebase, Google Sign-In), pre-submission verification checklist, and post-launch compliance maintenance procedures. Confirms existing account deletion and granular data deletion features meet Google Play requirements.

- **Offline-first architecture** — Complete offline-first infrastructure enabling the app to work fully offline with cached reads, queued writes, and auto-sync on reconnect.
  - `ConnectivityService` + `ConnectivityCubit` — Global connectivity monitoring using `connectivity_plus` + `internet_connection_checker`. Emits `online`/`offline` status app-wide.
  - `ConnectivityBanner` — Animated slide-down banner in `MainShell` that appears when offline and auto-dismisses when connectivity returns.
  - `OfflineQueue` + `OfflineQueueProcessor` — Persistent mutation queue (SharedPreferences-backed) for write operations. Actions are queued when offline and processed sequentially (FIFO) when connectivity returns, with max 3 retries.
  - `RetryInterceptor` — Dio interceptor that auto-retries failed GET requests (2 retries with 1s/3s backoff) on transient network errors and 5xx server responses.
  - `CachePolicy` — Cache freshness helper with three tiers: fresh (< 5 min, skip API), stale (5 min – 24 h, show cached + background refresh), expired (> 24 h, must fetch).
  - **Cache timestamps** — All three cache snapshots (Profile, Attendance, KPI) now include `cachedAt` timestamps for freshness tracking.
  - **Auto-sync on reconnect** — `MainShell` listens for offline→online transitions and auto-refreshes all BLoCs with a 2-second debounce to avoid burst requests.
  - **Offline mutation queueing** — Attendance check-in/out, KPI upsert/delete operations are queued when offline with optimistic UI updates.
  - **Localization** — Added 8 offline-related l10n keys in both EN and AR (offlineShowingCachedData, offlineActionQueued, offlinePendingSync, offlineSyncComplete, offlineSyncFailed, offlineLastUpdated, offlinePendingActions, connectionRestored).

### Changed

- **AppPhoneField supported countries narrowed** — `kSupportedCountries` reduced from 7 to 2 (SA + JO only), matching the backend's `PhoneHelper::isValid()` validation. Country selector switched from `modalBottomSheet` to a compact `dialog` (220×320, no search autofocus) — appropriate for a 2-item list.

---

- **False "No internet connection" banner** — `InternetConnectionChecker` v3 defaults to unreliable free APIs (`dummyapi.online`, `jsonplaceholder.typicode.com`, `fakestoreapi.com`) which frequently fail. Replaced with highly-available captive-portal endpoints (Google `generate_204`, Apple, Cloudflare). Also fixed fire-and-forget `isOnline` call in `ConnectivityService.init()` — now properly awaited so the initial status is accurate before the cubit reads it.
- **Connectivity banner overlapping status bar and AppBar** — Banner was in a Column above the page's Scaffold, sitting behind the status bar with no SafeArea. Moved to a Stack overlay positioned just below the AppBar. Uses `AnimatedSize` + `AnimatedOpacity` for smooth collapse/expand instead of `AnimatedSlide` which didn't affect layout size. Made banner more compact (smaller text, tighter padding).
- **Duplicate offline banners** — Global `ConnectivityBanner` and page-level `OfflineBanner` both showed "No internet connection" simultaneously. `OfflineBanner` now hides when the device is offline (global banner already visible).
- **"Connection restored" used SnackBar instead of AppToast** — Fixed `MainShell._onConnectionRestored()` to call `AppToast.show()` directly and use `State.context` instead of a captured BlocListener context that could be stale after the 2-second debounce timer.
- **KPI bottom sheet and entry cards showing English when app is in Arabic** — The add-KPI-entry bottom sheet dropdown used raw backend `name` field instead of localized strings. Added `_localizedDefName()` helper that maps definition `key` to `context.l10n` strings. Also added missing `dial_speed` key to the entry card's `_localizedName()` map and created `kpiDialSpeed` l10n key in both EN/AR ARB files.
- **Profile image not showing on Home/Settings** — Two root causes: (1) `_persistProfileCache` dropped `images` when `_applyPendingImagePaths` returned a plain `ProfileImagesEntity` instead of `ProfileImagesModel` — the `is ProfileImagesModel` cast failed and saved `null` to cache, so on next load with fresh cache the image was gone. Fixed by wrapping non-model entities in `ProfileImagesModel` before caching. Also fixed `_applyPendingImagePaths` to return the original model when no pending state exists, and to return `ProfileImagesModel` when it does. (2) `HomeGreetingHeader` and `SettingsUserCard` used `NetworkImage()` which fails on local file paths from pending uploads. Added `FileImage` fallback. Also added missing `avatarUrl` to the `ProfileModel` fallback in `_persistProfileCache`.

### Added

- **Profile resume/video offline support** — Resume and video features now work offline:
  - **PdfViewerPage** — Checks connectivity before downloading; shows a clear "file not available offline" message with wifi-off icon when the PDF hasn't been cached yet. Previously-viewed PDFs load from the temp directory cache.
  - **VideoPlayerPage** — Checks connectivity before streaming; shows "video requires internet" message instead of a cryptic playback error.
  - **Resume/video delete queueing** — Delete operations are queued via `OfflineQueue` when offline with optimistic UI removal. New `OfflineActionType.profileDeleteResume` and `profileDeleteVideo` action types with `OfflineQueueProcessor` handlers.
  - **Upload connectivity guard** — Resume and video uploads show a clear "upload requires internet" error when attempted offline (file uploads cannot be queued).
  - **EditVideoSection** — Switched from `url_launcher` (external browser) to in-app `VideoPlayerPage` for consistent offline handling and better UX.
  - Added 4 new l10n keys (EN + AR): `uploadRequiresInternet`, `deleteQueuedOffline`, `fileNotAvailableOffline`, `videoRequiresInternet`.
- **Profile "Pending translation..." shown on all empty fields** — Replaced the blanket `isTranslationPending` approach that marked every unfilled field with a styled inline chip that only appears on translation-dependent fields (specialty). Unfilled fields (city, gender, work shift, etc.) correctly show "-".
- **Router error page uses design tokens & l10n** — Replaced hardcoded `Colors.red`, `SizedBox(height:)`, and English string literals in the GoRouter `errorPageBuilder` with `AppColors.error`, `AppSpacing` constants, and `context.l10n.pageNotFound` / `context.l10n.goHome` localized strings. Added `pageNotFound` and `goHome` keys to both EN and AR ARB files.

## [0.4.0] - 2026-03-26

### Added

#### Auth & Onboarding

- **Auth Selection screen** — New `/auth-select` route and `AuthSelectPage` inserted between onboarding and login/register. Shows app logo, "Get Started" header, Login button, Create Account button, and Google Sign-In option. Added `RouteNames.authSelect` and l10n keys `authSelectTitle` / `authSelectSubtitle` (EN + AR).
- **Essential Data Wizard** — 4-step post-auth wizard that collects required profile data (name, age, nationality, specialty, phone, resume) before granting access to the app. Built with Clean Architecture: `EssentialDataCubit` + 2 use cases (`GetEssentialDataUseCase`, `SubmitEssentialDataUseCase`), remote data source with multipart file upload. Steps: (1) First Name + Last Name, (2) Age + Nationality dropdown from API, (3) Specialty + Phone, (4) Resume upload (PDF/DOC/DOCX, 5MB limit) with Arabic/English toggle. Enforced at router level via `needsEssentialData` flag on `AuthAuthenticated` state. Local `SharedPreferences` flag provides fast bypass on restart; API GET check validates on first wizard load.
- **Essential Info review screen** — New `auth/essential_info/` sub-feature (`/essential-info` route). After first-time registration and essential data submission, shows submitted profile fields (name, age, nationality, specialty, phone) and AI translation status banner. "Continue to Home" proceeds to `/home`. Built with `EssentialInfoCubit` / `GetEssentialDataUseCase` (reuses existing domain layer).
- **Applicant translations support** — POST `/applicant/essential/info` response (`source_locale`, `target_locale`, `translation_status`) now parsed and carried through the full Clean Architecture stack. Translation locale pair bridged via `AuthAuthenticated` state to the essential-info review page, where the banner shows the specific locale pair (e.g. "Translating from Arabic to English").
- **Client-side locale validation on register screen** — Name fields validate locale-compatible characters, matching the essential data wizard's validation and ensuring names pre-fill correctly into the wizard.
- **Client-side locale validation on essential data wizard** — Name and specialty fields validate that text matches the app's current locale before submission. Mirrors backend's `validateLanguage()` rule and prevents 422 errors. New `Validators.localeChars()` helper and `invalidLocaleChars` l10n key (EN + AR).
- **Wizard pre-population (name + phone)** — Essential data wizard pre-fills `firstName`, `lastName`, and `phone` from registration response stored in `AuthBloc`. Phone parsed via `PhoneNumber.parse`.
- **Delete account** — Users can permanently delete their account from Settings → Account section. Calls `DELETE /delete/account` (backend soft-delete + token revocation), clears all local auth data, revokes Google Sign-In, and redirects to login. Full Clean Architecture stack wired end-to-end.
- **Essential data localization** — 22 new ARB keys (EN + AR) covering all wizard steps, validation messages, and file upload UI.

#### Profile

- **Profile view UX overhaul widgets** — New `ProfileSubSectionLabel`, `FormSectionHeader`, `CollapsibleProfileSection`, and `ProfileEmptyState` shared widgets for section organization.
- **Specialty row in profile & edit profile** — Dedicated "Specialty" row in personal details card (profile view) and specialty text field in edit personal form. Professional card now shows "Industry" (`industryName`) only.
- **Styled pending translation chip** — `ProfileInfoRow` supports `isPendingTranslation` flag. Translation-dependent empty fields show a compact styled chip (translate icon + localized label) instead of a plain dash.
- **Translation pending hint banner** — Profile page shows an info banner when name/specialty characters don't match the app locale (AI translation in progress). New `TranslationPendingBanner` shared widget, `Validators.isLocaleMismatch()` helper, and `profileTranslationPending` l10n key (EN + AR).
- **Specialty display in profile** — Profile shows user's specialty from `applicant_translations` via `/applicant/essential/info` in the Professional Details card as fallback when industry hasn't been set.
- **Experience & Education detail dialogs** — Tapping any experience or education item opens a styled `Dialog` with full details: colored header band, icon, name/company, job-type + duration badges, detail rows, and description section. Duration computed client-side from start/end dates.
- **Full-screen experience/education add/edit forms** — `ExperienceFormDialog` and `EducationFormDialog` are now full-screen pages (`MaterialPageRoute(fullscreenDialog: true)`) with `CustomAppBar`, collapsible form sections, and sticky save button — replacing the previous bottom sheet approach.
- **Collapsible sections in Personal & Professional edit tabs** — Personal tab: 5 `CollapsibleProfileSection` widgets (Name, Contact, Identity & Demographics, Specialty & Work, Location). Professional tab: 4 sections (Experience Level, Industry & Role, Compensation, Availability & Status). Both tabs have a sticky save button always visible at the bottom.

#### Home

- **Home page skeletonizer** — `HomePageSkeleton` mirrors full home page layout using `skeletonizer`. Shown on first load while all three BLoCs are in initial/loading state.
- **Home empty states** — `HomeRecentKpis` and `HomeRecentAttendance` display inline `EmptyStateWidget` when data is empty, instead of collapsing to `SizedBox.shrink()`.

#### Shared & Core

- **`AppToast` reusable toast widget** — Top-anchored slide-down banner in `lib/shared/widgets/banners/app_toast.dart`. Four types (`success`, `error`, `warning`, `info`) with localized type labels, matching `AppColors`, and appropriate icons. RTL-aware. `context.showSuccess()`, `context.showError()`, `context.showWarning()`, and `context.showInfo()` all delegate to `AppToast.show()`.
- **Country flag utility** — `countryCodeToFlag()` helper in `core/utils/country_flag.dart` converts ISO 3166-1 alpha-2 codes to flag emojis via Unicode Regional Indicator Symbols.
- **Localized in-app changelog** — `AppInfoDialog` changelog data fully localized: group titles use `l10n.*` keys; item text and dates stored as bilingual `Bi` objects resolved at render time. Five new ARB keys (`changelogGroupNew`, `changelogGroupBetter`, `changelogGroupFixed`, `changelogGroupSimplified`, `changelogGroupWelcome`).
- **`isRequired` param on input widgets** — `AppTextField`, `AppDropdownField`, and `AppSearchableDropdownField` now support a red asterisk required-field indicator.

#### Testing

- **Test coverage analysis** — Comprehensive analysis in `tech_readme_files/TEST_COVERAGE_ANALYSIS.md` identifying 6 priority areas (~280-370 test cases needed).
- **Unit test suite (Phase 1)** — 8 test files, ~75 test cases: AuthBloc, SettingsCubit, AuthRepositoryImpl, UserModel, UserEntity, Validators, StringExtensions, Failure classes. Created shared test infrastructure (13 mock classes, auth fixtures).
- **Unit test suite (Phase 2)** — 7 test files, ~95 test cases: AttendanceBloc, KpiBloc, AttendanceRepositoryImpl, KpiRepositoryImpl, AttendanceModel, KpiModel, Auth use cases. Expanded to 29 mock classes, attendance/kpi fixtures.
- **Unit test suite (Phase 3)** — 7 test files, ~120 test cases: ProfileBloc, ProfileRepositoryImpl, ProfileModel serialization (9 models), AttendanceEntity, KpiEntity, Attendance use cases, KPI use cases. Expanded to 36 mock classes.
- **Unit test suite (Phase 4)** — 6 test files, ~75 test cases: ApiResponse, PaginationMeta, ProfileEntity, Profile use cases, ApiEndpoints, Exceptions, StorageKeys. 37 mock classes total.
- **Testing documentation** — `tech_readme_files/10_testing.md` comprehensive testing guide. Updated `01_folder_structure.md` with test directory tree.

### Changed

#### Profile

- **Profile view UX overhaul** — Grouped personal card rows into 3 sub-sections (Contact, Identity & Demographics, Location & Work) and professional card rows into 3 sub-sections (Career, Industry & Function, Compensation & Availability) using `ProfileSubSectionLabel`. Added actionable advice tiles to completeness card (shows backend `advices` when profile < 100%). Replaced plain empty states in 5 section cards with `ProfileEmptyState` (icon, title, subtitle, CTA). Added quick-action chips (Edit Profile, Add Skills, Upload Resume) below profile header. Removed edit button from header.
- **Edit profile UX overhaul** — Grouped personal form fields into 5 sections and professional into 4 sections using `FormSectionHeader`. Sticky save button pattern for Personal and Professional tabs. Renamed "More" tab to "Portfolio" with 5 CRUD sections wrapped in collapsible `CollapsibleProfileSection` cards with count badges. Deep-link navigation via GoRouter `extra` parameter to open edit profile at specific tab.
- **Profile BLoC: eliminate duplicate API calls** — `_isLoading` guard on `_onRefresh`, new `_refreshAfterMutation()` helper fetching only the changed section + summary/completeness (2 API calls instead of 11). Reduces profile API calls from ~33 per navigation cycle to ~11, and from ~11 per CRUD operation to ~2.
- **Profile locale refresh fix** — `_pendingLocaleRefresh` mechanism queues refresh when language changes during loading. `app.dart` locale-change listener now fires `ProfileRefreshRequested` in `ProfileLoading` state.
- **Profile data source fetches essential info** — `getPersonalDetails()` now fetches `/applicant/essential/info` in parallel, merging the `specialty` field into the profile model.
- **Translation pending banner theming** — Alpha-based colors following the `OfflineBanner` pattern. Works in both light and dark themes.

#### Auth & Onboarding

- **Auth feature restructured into sub-features** — Reorganized flat `lib/features/auth/` into 7 sub-feature directories: `shared/`, `splash/`, `language_select/`, `onboarding/`, `login/`, `register/`, `forgot_password/`, `essential_data/`. All imports updated (~30 files).
- **Essential Data wizard UI refactor** — `AuthScaffoldWithPattern` → `Scaffold` + `CustomAppBar`. Step widgets wrapped in `AppCard`. Step indicator upgraded to segmented bar. Loading shows `EssentialDataWizardSkeleton` instead of plain spinner.
- **Essential Info page UI refactor** — `CustomAppBar`, `AppCard`, shared `TranslationPendingBanner`, `EssentialInfoSkeleton` on load.
- **Step widget dark mode theming** — Uses `Theme.of(context).colorScheme` and `textTheme` instead of hardcoded `AppColors` tokens.
- **`AuthAuthenticated` state** — Added `needsEssentialData` field (default: `true`), `copyWith`, `translationSourceLocale` / `translationTargetLocale`, and `isFirstTimeEssentialData` flag.
- **`AuthBloc`** — Takes `SharedPreferences` dependency. Checks essential data flag on every authentication. New `AuthEssentialDataCompleted` event carries optional locale pair.
- **Router redirect** — `/essential-data` and `/essential-info` routes added. Redirect logic enforces wizard flow.
- **Essential data data source** — `submitEssentialData` returns `EssentialDataSubmitResponseModel` instead of `void`, parsing POST response body.

#### Shared & Settings

- **Nationality dropdown with flags** — `AppSearchableDropdownField` in age/nationality step with flag emojis derived from ISO alpha-2 `code` field.
- **AppSearchableDropdownField enhancements** — `itemLeadingBuilder` callback, `validator` parameter for `FormField` wrapping, `prefixIconConstraints` support.
- **Settings widgets reorganized into subdirectories** — `common/`, `sections/`, `dialogs/` subdirectories. Removed unused `settings_logout_button.dart`.
- **ScaffoldMessenger → AppToast** — Replaced `ScaffoldMessenger` snackbar calls with `AppToast` across the entire app.
- **Phone field countries** — Updated supported countries list and improved country selector dialog.

### Fixed

#### Auth & Onboarding

- **Post-registration navigation bug** — Users incorrectly navigated to `/home` instead of essential data wizard. `_onEssentialDataCompleted` now only clears `needsEssentialData`; `isFirstTimeEssentialData` remains `true` until essential-info page navigates to home.
- **Wizard skipped due to backend skeleton record** — Backend creates partial essential-data record at registration. Added `EssentialDataEntity.isComplete` getter; cubit now emits `EssentialDataNeeded` when the record is a stub.
- **`Localizations.localeOf` crash in essential data wizard** — Moved locale-dependent pre-fill from `initState` to `didChangeDependencies` with one-shot guard.
- **422 on essential data submit (locale mismatch)** — `_preFillFromRegistration` now guards name fields with locale check — Arabic mode skips Latin-character names. Phone always pre-filled (locale-independent).
- **Essential data `getEssentialData` repository** — Added explicit `ValidationException` → `ValidationFailure` mapping.
- **Essential data wizard initial state** — `EssentialDataInitial` no longer briefly renders the wizard form before API check completes.
- **Localized all validation and server error messages** — All auth validation messages and server error strings now go through `context.l10n` with optional localized message parameters on validators.

#### Profile

- **Profile "Pending translation..." shown on all empty fields** — Replaced blanket `isTranslationPending` approach. Styled inline chip now only appears on translation-dependent fields (specialty). Unfilled fields correctly show "-".
- **Edit profile locale validation** — Name fields validate locale-compatible characters, preventing Arabic names from being saved to the English translation row (or vice versa).

#### Core

- **Router error page uses design tokens & l10n** — Replaced hardcoded `Colors.red`, `SizedBox(height:)`, and English strings with `AppColors.error`, `AppSpacing`, and localized strings. Added `pageNotFound` and `goHome` l10n keys.

## [0.3.0] - 2026-03-15

### Added

- **Reusable `AppDateInputSheet`** — Extracted the birth date input bottom sheet into a shared `AppDateInputSheet` widget (`lib/shared/widgets/inputs/app_date_input_sheet.dart`). Accepts `title`, `initial`, `firstDate`, `lastDate` params. Used by birth date, experience start/end dates, and education start/end dates.

### Changed

- **Version**: Bumped from `1.1.0+2` to `1.2.0+3`
- **Add/Edit Experience form UX** — Replaced raw `showDatePicker` with `AppDateField` + `AppDateInputSheet` for start/end dates (DD/MM/YYYY text input with calendar fallback). Added country dropdown (`AppSearchableDropdownField`) fetching from `/lookups/countries`. Added inline validation error for missing start date and missing country. Added hint text to all fields (position, company name, company location, description). Dates display in human-readable `d MMM yyyy` format.
- **Add/Edit Education form UX** — Replaced `TextEditingController`-based date fields and raw `showDatePicker` with `AppDateField` + `AppDateInputSheet` (consistent with experience form). Added inline start-date required validation. End date is automatically cleared if start date changes to after it. Added hint text to all fields: university, degree, field of study, description.
- **Add/Edit Skill dialog UX** — Added hint text (`enterSkillName`), `autofocus: true`, and `onSubmitted` (keyboard submit) to the skill name field.
- **App info dialog changelog** — Added v1.2.0 entry to the in-app changelog covering all unreleased changes since v1.1.0: multi-skill add, in-app video player, searchable nationality, date input improvements, locale-aware profile refresh, skills locale fix, modern bottom nav, and bug fixes. Extracted changelog data models (`VersionEntry`, `ChangeGroup`) and version entries into `app_changelog_data.dart`; extracted company header into `_CompanyHeader` widget. Dialog file is now UI-only.
- **Multi-skill add UX** — The "Add Skill" button now opens a chip-input bottom sheet (`AddSkillDialog.showMulti`) where users can enter multiple skills at once. Key UX details: (1) `+ Add` button embedded as a suffix inside the text field — no awkward external button. (2) Keyboard-shortcut hint pills (`↵ Enter` and `,`) displayed below the field so users discover both entry methods instantly. (3) Duplicate detection — typing an existing pending skill shows a 2-second inline error and keeps focus instead of silently ignoring the input. (4) `AnimatedSize` chips area that smoothly expands/collapses; shows a soft placeholder ("Added skills appear here") when empty. (5) Chips section header row with a count badge (`Skills to add · 3`). (6) Submit button shows `✓ Add · N skills` with a check icon when skills are queued, disabled when the queue is empty. Edit and delete flows are unchanged (single-skill edit mode via `AddSkillDialog.show`). Implemented as extracted sub-widgets: `_AddSuffixButton`, `_KeyHint`, `_EmptyChipsPlaceholder`, `_ChipsSection`.

### Fixed

- **Profile data disappearing on locale switch** — When the user changed language (English ↔ Arabic), profile data would disappear or remain in the old language until a hot restart. Root cause: the `ProfileBloc` cached API responses containing localized strings (nationality, gender, industry, etc.) and never re-fetched on locale change; `EditProfileLookups` also cached locale-dependent lookup values with an `isLoaded` guard that skipped re-fetches. Fix: added a `BlocListener` in `app.dart` that clears the profile local cache, resets `EditProfileLookups`, and triggers `ProfileRefreshRequested` whenever the locale changes.
- **Skills showing empty chips on locale switch** — The backend only eager-loads skill translations for the requested locale. Skills created in English had no Arabic translation, so switching to Arabic returned `null` names, rendering empty circles. Fix: `ProfileRemoteDataSource.getSkills()` now fetches skills for both locales (`en` and `ar`) in parallel and merges them — the first non-empty name wins. Also changed `ApiClient` interceptor to use `putIfAbsent` for locale headers so per-request overrides are respected.
- **`ExperienceEntity` missing `countryId`** — Backend `POST /applicant/experiences` returns 422 when `country_id` is absent. Added `countryId` to `ExperienceEntity`, `ExperienceModel` (`fromJson`/`toJson`), and the experience form submission payload.
- **Misleading "No internet connection" error on timeout** — Repository `NetworkException` handlers were catching the exception without binding it (`on NetworkException { ... }`) so the error message was always the default "No internet connection" even for genuine connection timeouts. Fixed `ProfileRepositoryImpl`, `AttendanceRepositoryImpl`, and `KpiRepositoryImpl` to use `on NetworkException catch (e) { ... }` — users now see the actual message (e.g. "Connection timed out").
- **30-second API hang** — `ApiClient` `connectTimeout` was 30 seconds. Reduced to 15 seconds so users see an error sooner when the backend is unreachable.
- **Duplicate profile requests on startup** — On app launch, `SettingsCubit._loadSettings()` restores the saved locale, which triggered the `BlocListener<SettingsCubit>` in `app.dart` and dispatched `ProfileRefreshRequested`. Simultaneously, `MainShell.initState()` dispatched `ProfileLoadRequested`, causing all 9 profile endpoints to be called twice. Fixed by guarding the refresh dispatch: it is now skipped when the profile is not yet loaded (`ProfileInitial` or `ProfileLoading`) on startup; `MainShell` handles the initial load with the already-correct `ApiClient` locale.
- **Logout takes 15 seconds** — `AuthRepositoryImpl.logout()` awaited `remoteDataSource.logout()`, blocking the user for the full 15-second `connectTimeout` when offline or when the server is slow. Changed to fire-and-forget: the remote logout request is dispatched without `await` and any error is silently swallowed. Local auth data is cleared immediately, so the user is signed out without delay.
- **Register page navigation race condition** — `RegisterPage` (and previously `EssentialDataWizardPage`) called `context.go('/essential-data')` synchronously after dispatching a BLoC event, but BLoC processes events asynchronously. The explicit `context.go()` could race against GoRouter's `refreshListenable` redirect. Fixed by removing all explicit navigation calls; GoRouter's redirect now handles all post-auth routing once `AuthAuthenticated` is emitted.

 — Profile videos now open inside the app instead of launching an external app. A new full-screen `VideoPlayerPage` (using `video_player` + `chewie`) streams the S3 video URL with native playback controls (play/pause, seek bar, full-screen toggle, mute). Added `RouteNames.videoPlayer` and wired `/video-player` into the GoRouter. `ProfilePage._onViewVideo` now pushes this route with the URL and localized title.

- **Searchable nationality dropdown** — Replaced the `AppDropdownField` for Nationality in the edit-profile personal form with the new `AppSearchableDropdownField`. Tapping the field opens a bottom sheet with a live-filter search input, allowing users to quickly find a nationality from the full list. The existing `AppDropdownField` is unchanged for smaller lists.

### Changed

- **Birth date field UI/UX** — Replaced the plain read-only `AppTextField` for birth date with a two-part improvement. (1) The `AppDateField` display widget shows the selected date in human-readable "d MMM yyyy" format with a computed age helper text and a clear (×) button. (2) Tapping the field now opens a custom bottom sheet with an **auto-formatted text input** (DD/MM/YYYY — slashes inserted automatically as digits are typed) as the primary entry mode, a format hint below the field, a "Use Calendar" fallback button, and a "Confirm" action. This replaces the standard `showDatePicker` which defaulted to a calendar and showed unformatted raw digits in its text-entry mode.
- **Edit profile UI/UX improvements** — Tab bar now shows icons alongside text labels for quicker scanning. City and Current Location fields are displayed in a side-by-side row. Monthly Salary and Currency dropdown are grouped in the same row (flex 3:2) since they are logically paired. The Driving License checkbox is replaced with a styled `SwitchListTile` inside a bordered container, consistent with the rest of the form. Background photo camera badge relocated from top-left to top-right of the header, matching the conventional edit-hint placement.

### Fixed

- **Profile video playback on Android 11+** — Videos in the Profile screen were silently not opening because Android 11+ requires apps to declare `<queries>` intent filters before `canLaunchUrl` can detect handlers. Added `https` and `http` scheme intent queries to `AndroidManifest.xml`. The `_onViewVideo` handler was also refactored from `url_launcher` to in-app navigation (now pushes `VideoPlayerPage` directly).
- **Language select cards use card theme color** — `_LanguageCard` now reads `Theme.of(context).cardTheme.color` instead of `colorScheme.surface` for the unselected background. In dark mode `colorScheme.surface` is blue-tinted (`#2F3349`) while `cardTheme.color` is neutral dark (`#383838`), so cards were visually inconsistent with every other `Card` in the app.
- **Phone field RTL layout** — Wrapped `PhoneFormField` in `Directionality(textDirection: TextDirection.ltr)` so the country button, flag, dial code, and digit input always render left-to-right in Arabic (RTL) mode. Phone numbers are internationally LTR and must not flip with locale direction.

### Added

- **Arabic font (Tajawal)** — When the app locale is Arabic, the UI uses the Tajawal font family (from `assets/fonts/`) instead of PublicSans. English and other locales continue to use PublicSans via Google Fonts. Font selection is driven by `AppFonts.forLocale(locale)` and applied through `LightTheme.themeForLocale` and `DarkTheme.themeForLocale`.

### Changed

- **Onboarding screen** — Updated to reflect app features (Profile, KPIs, Attendance). Extracted widgets into separate files: `onboarding_data.dart`, `onboarding_header.dart`, `onboarding_page_content.dart`, `onboarding_progress.dart`, `onboarding_nav_buttons.dart`, `onboarding_dot_indicator.dart`. Page now composes these widgets for cleaner structure.
- **App info dialog changelog** — Updated to reflect latest features: attendance background timer, live home dashboard, offline support, filters, default light/Arabic, production backend, jobs removal. Added March 13, 2026 entry.
- **Default theme and locale** — App now defaults to light theme and Arabic language for new users (when no saved preferences exist). Users can still change theme and language in settings.
- **Switched API target to deployed backend** — Updated `API_BASE_URL` from local network (`http://192.168.100.59:8000`) to the deployed production backend (`https://admin.technology92.com`). Updated default fallback in `EnvConfig` and `.env.example` to match.

### Added

- **Attendance background timer with lock screen notification** — When the user checks in, a persistent Android foreground service starts via `flutter_foreground_task`. The notification shows the live elapsed time (updating every second), the current status label, and is visible on the lock screen and notification center. The timer continues running when the app is backgrounded, the phone is locked, or another app is opened. Checking out stops the service and removes the notification. The `AttendancePage` now receives elapsed seconds from the foreground service isolate instead of running a local `Timer.periodic`, keeping the UI perfectly in sync even after returning from background.
- **Platform configuration for foreground service** — Android: `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_DATA_SYNC`, `POST_NOTIFICATIONS`, `REQUEST_IGNORE_BATTERY_OPTIMIZATIONS`, `WAKE_LOCK` permissions and `ForegroundService` declaration. iOS: `BGTaskSchedulerPermittedIdentifiers` and `UIBackgroundModes` in Info.plist, plugin callback in AppDelegate.swift.

### Changed

- **Home screen refactored into live dashboard** — Replaced the static home screen with a data-driven dashboard that surfaces real-time data from all existing features. New sections: time-based greeting header, live attendance status card with clock timer and quick check-in/out, 4-item quick actions grid, 3-stat summary row (profile completeness, KPI entry count, today's worked hours), recent KPI entries list, and recent attendance records list. All data pulled from existing `ProfileBloc`, `AttendanceBloc`, and `KpiBloc`. Pull-to-refresh reloads all three data sources simultaneously.
- **Main shell now preloads attendance and KPI data** — `MainShell.initState` dispatches `AttendanceLoadRequested` and `KpiLoadRequested` on first mount so data is ready when the user reaches the home screen.
- **Home page extracted into 6 widget files** — `home_greeting_header.dart`, `home_attendance_card.dart`, `home_quick_actions.dart`, `home_stats_row.dart`, `home_recent_kpis.dart`, `home_recent_attendance.dart` under `lib/features/home/presentation/widgets/`.

### Added

- **New l10n keys (EN + AR)** — `goodMorning`, `goodAfternoon`, `goodEvening`, `quickActions`, `yourStats`, `recentKpis`, `recentAttendance`, `kpiEntryCount`, `workedToday`, `notClockedIn`, `noRecentEntries`, `noRecentRecords`, `profileProgress`, `kpiSummary`, `hoursShort`.

### Removed

- **Jobs feature** — Completely removed the jobs feature module from the app. Deleted `lib/features/jobs/` directory (37 files across jobs_list, job_details, job_search, saved_jobs sub-features). Cleaned up all references: DI registrations, BLoC providers, routes, bottom navigation tab, API endpoints, storage keys, l10n keys, home page sections (recent jobs, search jobs, saved jobs quick actions), and changelog entries in the app info dialog.

### Fixed

- **Attendance pull-to-refresh stuck in loading** — `RefreshIndicator.onRefresh` used `stream.firstWhere(...)` to wait for the BLoC to finish reloading. When the refreshed data was identical to the current state, flutter_bloc's Equatable deduplication silently dropped the emission, so the future never resolved and the spinner hung forever. Replaced with a `Completer`-based handshake: `AttendanceLoadRequested` now accepts an optional `Completer<void>` that the BLoC completes in a `try/finally` block, guaranteeing the refresh always finishes.
- **KPI pull-to-refresh stuck** — Same `stream.firstWhere` bug as attendance. Fixed with `Completer`-based pattern.
- **Cache load showing skeleton flash** — All cached BLoCs (Attendance, KPI) now emit the cached state immediately on load instead of skipping the loading emission. Eliminates the brief blank/skeleton flash when cached data exists.

### Changed

- **Attendance offline UX** — When the network fails and cached data exists, the page now shows the cached content with a warning banner at the top (wifi-off icon, error message, retry button) instead of replacing the entire view with a full-screen error. Full-screen error is still shown when no cached data is available (first-ever load).
- **Attendance persistent cache** — Last successful attendance data is now persisted to SharedPreferences via `AttendanceLocalDataSource`. On app restart (or hot restart), the BLoC restores the cache so the offline banner + cached data flow works immediately instead of showing a full-screen error.

### Added

- **Offline cache for KPI** — `KpiLocalDataSource` persists definitions and entries to SharedPreferences. `KpiBloc` restores cache on creation and falls back to cached data with `OfflineBanner` when API calls fail. Added `toJson()` to `KpiDefinitionModel`, `KpiEntryModel`, `KpiNoteModel`.
- **Offline cache for Profile** — `ProfileLocalDataSource` persists the full profile snapshot. `ProfileBloc` restores cache on creation, persists on success, and shows cached data with `OfflineBanner` on network failure. Added `toJson()` to `ExperienceModel`, `EducationModel`, `SkillModel`, `ProfessionalDetailsModel`, `ProfileImagesModel`, `ProfileSummaryModel`, `ResumeModel`, `VideoModel`. Updated `ProfileModel.toJson()` to include all fields for cache round-trip.
- **`PaginationMeta.toJson()`** — Shared serialization for pagination metadata used across features.
- **`OfflineBanner` shared widget** — Reusable connectivity banner (`shared/widgets/banners/offline_banner.dart`) with loading indicator on retry. Accepts async `onRetry` callback, shows a spinner while the retry runs, and supports customisable icon/color. Replaces the private `_OfflineBanner` in the attendance page.
- **Attendance schedule filter** — Filter icon with badge in the attendance app bar. Filter sheet supports status dropdown (available, busy, on break, eating meal, checked out) and sort-by (default, newest first, oldest first, longest duration, shortest duration). Date picker bar below the action button lets users filter schedule entries by work date. All filtering and sorting is applied client-side.
- **`AttendanceFilterEntity` + `AttendanceSortOption`** — New filter entity and sort enum in the attendance domain layer.
- **`AttendanceFilterSheet`** — New widget (`features/attendance/presentation/widgets/attendance_filter_sheet.dart`) for the filter bottom sheet.
- **Shared filter widgets** — Three new shared widgets: `AppDateFilter` (`shared/widgets/filters/app_date_filter.dart`), `FilterSheetActions` (`shared/widgets/filters/filter_sheet_actions.dart`), and `FilterIconButton` (`shared/widgets/filters/filter_icon_button.dart`) — filter icon with badge indicator used by both KPI and Attendance pages.
- **l10n keys** — Added `longestDuration`, `shortestDuration`, `allStatuses`, `attendanceStatus`, `noScheduleForFilter` (EN + AR).

### Changed

- **KPI refactored to use shared filter widgets** — `KpiDateFilter` re-exports `AppDateFilter`. `KpiFilterSheet` uses `FilterSheetActions`. `KpiPage` imports `AppDateFilter` directly.
- **`AttendanceScheduleSection`** — Added `hasActiveFilters` param; shows filter-aware empty state message.

---

## [0.2.0] - 2026-03-11

### Fixed

- **Critical: Attendance BLoC async emit bug** — `_onCheckIn` and `_onCheckOut` used `async` callbacks inside `result.fold()`, causing the inner `Future` to not be awaited. This meant the `emit()` after schedule refresh fired after the handler completed, silently losing the state update and leaving the loading indicator stuck. Replaced `fold()` with explicit `isLeft()`/`getOrElse()` pattern so all `await` and `emit` calls stay in the handler's own async scope.
- **Attendance date/time/status localization** — "Today" was hardcoded in English; now uses `context.l10n.today` (اليوم in AR). `DateFormat` calls now pass the device locale so month/weekday names render in Arabic. Schedule entry status labels now use l10n keys (`statusAvailable`, `statusBusy`, etc.) instead of raw enum strings.

### Added

- **Attendance in-memory caching** — `AttendanceBloc` now caches the last settled `AttendanceLoaded` state via `_cachedState`. On subsequent loads (tab switches, pull-to-refresh), cached data is shown instantly instead of the skeleton loader. Errors during refresh are silently absorbed when cached data exists. Cache auto-updates via `onChange` on every settled state emission.
- **`startedAt` and `today` l10n keys** — Added parameterised `startedAt(time)` and `today` keys to EN/AR ARB files.

### Changed

- **Timer ring: 24h max, live sync, visual polish** — Ring now represents a full 24-hour day (was 12h with modulo wrap). Progress clamps at 100% instead of wrapping. Ring animates in sync with the ticking digits (was frozen at backend-reported value). Added: gradient arc that fades from light to solid, glow dot at the progress tip, tick marks at 6h/12h/18h/24h intervals, "/ 24h" label below digits. Ring size increased to 220px, stroke width to 10px.
- **Attendance timer card date/time display** — Replaced raw server strings (`2026-03-12 • 2026-03-12 01:26:01`) with formatted, human-friendly display: date shows as "Today, Mar 12" (or "Wed, Mar 11" if not today), start time shows as "Started at 1:26 AM". Uses `intl` package `DateFormat` for locale-aware formatting.

#### Attendance Page Widget Extraction

- **Refactored** monolithic `attendance_page.dart` (~470 lines) into 4 focused widget files under `presentation/widgets/`
- **`AttendanceTimerCard`** (`attendance_timer_card.dart`) — Timer display card with status pill, elapsed time, date & start time info
- **`AttendanceStatusSelector`** (`attendance_status_selector.dart`) — Animated status chip selector with wrap layout
- **`AttendanceActionButton`** (`attendance_action_button.dart`) — Check in/out action button with loading state
- **`AttendanceScheduleSection`** (`attendance_schedule_section.dart`) — Schedule history list with entry cards, status dot colours, and formatted durations
- Page now acts as a thin orchestrator (~140 lines) — timer logic + BlocConsumer + composed widgets

#### Attendance UX/UI Improvements

- **Timer Card**: Replaced flat card with circular progress ring (`CustomPaint`) — 12-hour arc, status-coloured, timer icon + monospaced digits, tabular figures
- **Status Pill**: Now uses status-specific colour (green for available, red for busy, etc.) instead of generic green/gray
- **Date & Start Time**: Horizontal row with calendar + clock icons and dot separator instead of stacked text
- **Status Selector**: Added leading icons per status (check_circle, coffee, restaurant, do_not_disturb) with per-status colour coding; uses `updateStatus` l10n string
- **Schedule Section**: Replaced status dots with 40×40 coloured icon containers (KPI-card pattern); duration now displayed in a tinted badge; uses `scheduleHistory` l10n + count badge; empty state uses `EmptyStateWidget` with `event_busy_outlined` icon
- **Skeleton Loader**: New `AttendancePageSkeleton` using `Skeletonizer` — mirrors full page layout (ring, chips, button, card list)
- **Layout**: Added `Divider` and increased vertical spacing (`verticalXXL`) between action area and schedule history
- Uses proper l10n keys: `clockedIn`, `clockedOut`, `updateStatus`, `scheduleHistory`, `noScheduleRecords`

### Added - Settings, KPI & Sub-Feature Refactors

#### Bottom Sheet Selection UX Improvement

- **`BottomSheetOptionItem`**: Generic data class for describing selectable options (value, title, subtitle, leading widget)
- **`BottomSheetOption`**: Polished animated selection tile with highlighted background, border accent, animated scale check indicator, and ink-splash feedback
- **`AppBottomSheet.showOptions()`**: New convenience static method for single-select option list bottom sheets — eliminates boilerplate ListTile patterns
- Migrated Settings theme, language, and contact phone bottom sheets to use the new `showOptions` API

### Changed

#### Settings Screen Restructure

- **Removed** `SettingsGeneralSection` ("Support & Feedback" section) — deleted `settings_general_section.dart`
- **Moved** "Help & Support" tile into Contact Us section (replaces plain email tile, opens mailto with subject line)
- **Moved** "Rate App" tile into About section with real `in_app_review` integration (native review dialog with store fallback)
- **Removed** Notification Settings tile (not applicable)

#### KPI Feature (PR #33)

- **KPI Definitions**: Fetch all KPI definitions with units and value ranges from API
- **KPI Entries CRUD**: Create, read, update, and delete KPI entries
- **Date Filtering**: Filter entries by date with chip-based date filter row
- **Filter Sheet**: Bottom sheet filter with KPI definition dropdown and sort-by options (Newest, Oldest, Highest Value, Lowest Value, Default)
- **KPI Filter Entity**: `KpiFilterEntity` with `definitionId`, `dateFrom`, `dateTo`, `sortBy`, `hasActiveFilters` getter, and `copyWith()`
- **Sort Options**: `KpiSortOption` enum — client-side sorting by date or value
- **Filter Badge**: App bar filter icon with red badge indicator when filters are active
- **Client-Side Definition Filter**: Entries filtered by definition ID client-side after server date-range fetch
- **Add/Edit Sheet**: Bottom sheet form with dynamic inputs based on definition type (numeric, dropdown, text)
- **Delete Confirmation**: Alert dialog with confirmation before deleting entries
- **Skeleton Loading**: Full-page skeleton placeholder using `skeletonizer` on first load
- **State Caching**: Cached `KpiLoaded` state for instant UI on subsequent navigations
- **Pagination**: Paginated KPI definitions fetch support
- **Notes Display**: Per-entry notes section in entry cards
- **Entry Card UX Refactor**: Redesigned `KpiEntryCard` — leading icon container, two-row layout (header + value/date row), locale-formatted date chip, popup menu for delete, chat-bubble notes icons; updated skeleton to match

#### Profile Enhancements (PR #32)

- **Sub-Feature Split**: Refactored into `profile_view/`, `edit_profile/`, `shared/` sub-features
- **9 Profile Section Cards**: Personal, professional, education, experience, skills, resume, video, summary, completeness
- **Edit Profile**: Tabbed edit form (Personal → Professional → More) with form data objects
- **Education/Experience Dialogs**: Full CRUD dialogs for education and experience entries
- **Skill Management**: Add/delete skills with confirmation dialog
- **Resume/Video/Background CRUD**: Upload, fetch, and delete documents and media
- **PDF Viewer**: Full-screen `PdfViewerPage` with download functionality (`pdfx`)
- **Image Handling**: Profile photo upload, crop (`image_cropper`), and removal
- **Profile Skeletons**: Skeleton placeholders for profile page and edit profile page
- **Session Expiration**: Auto-logout on token expiry with redirect to login
- **Caching**: In-memory profile caching with pull-to-refresh invalidation
- **Unsaved Changes Dialog**: Confirmation dialog when leaving edit profile with unsaved changes

#### Settings Feature

- **Privacy Policy & Terms**: Locale-aware links (EN/AR) opening in in-app browser
- **Contact Section**: Company email (`info@technology92.com`), Riyadh phones (2), Jordan phone
- **About Us Page**: Company info, mission statement, core values with icons
- **App Info Dialog**: Branded dialog with logo (dark mode alt logo), company tagline, CR number, version
- **Notification Settings**: Opens system notification settings via `app-settings:notification`
- **Help & Support**: Opens email to `info@technology92.com` via `mailto:`
- **Rate App**: Opens Play Store listing
- **Delete Account**: Confirmation dialog with red styling, triggers logout on confirm
- **Dynamic Version**: Reads version from `package_info_plus` instead of hardcoded string

#### Shared Widgets

- **AppPhoneField**: Phone input with country code picker, flag display, searchable bottom sheet
- **AppDropdownField**: Generic typed dropdown field widget
- **AppBottomSheet**: Themed bottom sheet helper
- **UnsavedChangesDialog**: Reusable discard/save confirmation dialog
- **PhotoPickerBottomSheet**: Camera/gallery image picker bottom sheet

#### Documentation

- **01_folder_structure.md**: Complete rewrite reflecting current codebase (KPI, settings, jobs/profile sub-features, all shared widgets)
- **07_how_to_create_reusable_component.md**: Updated shared widgets listing
- **09_api_endpoints.md**: New file — complete API endpoint reference with all 50+ endpoints

#### Localization

- **~175 new ARB keys** added across both EN and AR files (~330 total keys)
- KPI strings: definitions, entries, date filter, delete confirmation
- Settings strings: privacy, terms, about, contact, delete account, company info
- Profile strings: all section cards, edit forms, education/experience, skills, resume, video

### Changed

- **Version**: Bumped from `1.0.0+1` to `1.1.0+2`
- **Profile Architecture**: Flat structure → `profile_view/`, `edit_profile/`, `shared/` sub-features
- **Settings Architecture**: Single page → 10 extracted widgets (user card, theme, language, general, about, contact, logout, section header, tile, app info dialog)
- **Locale Management**: `SharedPreferences` → `SettingsCubit` for reactive locale updates
- **App Logo**: Dark mode uses `AppImages.logoAlt` (white) in About Us page and app info dialog

### Fixed

- **Edit Profile Dropdowns**: Resolved dropdowns not loading on edit profile page
- **URL Launch**: Removed `canLaunchUrl` guard (fails on Android 11+ due to package visibility) — directly calls `launchUrl`
- **In-App Browser**: Changed from `LaunchMode.externalApplication` to `LaunchMode.inAppBrowserView`
- **Name Persistence**: Fixed via short personal details endpoint, added middle name to registration
- **Error Handling**: Improved null safety across data sources and models

---

## [0.1.0] - 2026-02-17

### Added - Initial Release

#### Core Infrastructure

- **Architecture**: Clean Architecture with 3 layers per feature (data → domain ← presentation)
- **State Management**: `flutter_bloc` (v9.1.0) with BLoC and Cubit patterns
- **Dependency Injection**: `get_it` + `injectable` for service locator setup
- **Networking**: `dio` HTTP client with auth, language, and logger interceptors
- **Local Storage**: `shared_preferences` + `flutter_secure_storage` (encrypted)
- **Navigation**: `go_router` with shell routes and named route constants
- **Environment**: `flutter_dotenv` for runtime secrets (base URL, API version, Google client ID)
- **Logging**: `talker` with Dio logger, BLoC observer, and debug-only output
- **Error Handling**: Custom exceptions → failures pipeline with `dartz` Either returns

#### Design System

- **AppColors**: Brand (`#5C6DB4` primary, `#E9C62B` secondary), neutral, semantic, status, social colours — full light/dark support
- **AppTextStyles**: Material 3 type scale (display → label) with PublicSans font family
- **AppSpacing**: SizedBox and EdgeInsets presets (`xxs`=2 → `xxxl`=40), page/screen padding helpers
- **AppRadius**: Border radius presets (`xs`=4 → `round`=100)
- **Light/Dark Themes**: Full `ThemeData` configurations with `ColorScheme`, component themes

#### Shared Widgets

- **AppButton**: Elevated, outlined, text, icon, and loading variants with size options
- **AppTextField / AppPasswordField**: Themed text inputs with validation, prefix/suffix, visibility toggle
- **AppCard**: Themed card wrapper
- **CustomAppBar**: Themed AppBar with optional back button and actions
- **EmptyStateWidget**: Illustration + title + subtitle + optional action button
- **AppErrorWidget**: Error display with retry callback
- **AppLoading**: Spinner, overlay loading, shimmer placeholder
- **AuthPatternBackground**: Pattern overlay + scaffold wrapper for auth pages
- **ResponsiveLayout**: Mobile/tablet/desktop breakpoint builder

#### Authentication Feature

- **Login Page**: Email/password form with validation and error display
- **Register Page**: 6-field form (first name, middle name, last name, email, phone, password)
- **Forgot Password Page**: Email submission for password reset
- **Google Sign-In**: OAuth flow with backend token exchange
- **Splash Page**: Animated logo with auth state check → auto-navigation
- **Language Select Page**: EN/AR picker shown on every launch
- **Onboarding Page**: 3-page carousel with skip/back/next
- **Auth Widgets**: `AuthHeader` (logo + title + subtitle), `SocialLoginButton` (Google/Apple/LinkedIn)
- **Token Management**: Secure token storage with `FlutterSecureStorage`, user data caching
- **Use Cases**: Login, Register, Logout, ForgotPassword, GoogleSignIn, GetCachedUser

#### Home Feature

- **Main Shell**: Bottom navigation bar with tabs (Home, KPIs, Attendance, Settings)
- **Home Page**: Dashboard with greeting, quick actions, stats

#### Profile Feature

- **Profile Page**: Avatar, completeness bar, personal/professional info display
- **Edit Profile Page**: Pre-populated edit forms for personal and professional details
- **Photo Upload**: Profile photo capture/selection and upload
- **API Integration**: Personal details, professional details, profile completeness

#### Settings Feature

- **Theme Toggle**: Light/Dark/System mode with `SettingsCubit` persistence
- **Language Switcher**: English/Arabic toggle with instant UI update and RTL support
- **Logout**: With confirmation dialog

#### Localization

- **English** (`app_en.arb`): ~155 translation keys
- **Arabic** (`app_ar.arb`): ~155 translation keys
- **RTL Support**: Full right-to-left layout for Arabic locale
- **`context.l10n`**: Extension for easy localized string access

#### Build & Scripts

- **`scripts/build_release.sh`**: Obfuscated release build (`--obfuscate --split-debug-info`)
- **`scripts/build_debug.sh`**: Debug build, run, and utility commands
- **Platform Configs**: Android, iOS, Web, Linux, macOS, Windows

#### Documentation

- **01_folder_structure.md**: Full `lib/` directory map
- **02_architecture.md**: Clean Architecture + BLoC explanation
- **03_how_to_add_new_feature.md**: Step-by-step feature scaffold guide
- **04_how_to_add_new_api.md**: Adding a new API endpoint end-to-end
- **05_how_to_add_new_language.md**: Adding/updating ARB translations
- **06_how_to_change_theme_colors.md**: Theme and colour customisation
- **07_how_to_create_reusable_component.md**: Shared widget creation guide
- **08_security_and_environment.md**: `.env` setup, token storage, obfuscation, OAuth config

#### Testing

- Basic widget test setup with `flutter_test`
- BLoC testing support with `bloc_test` + `mocktail`

### Dependencies (30+ packages)

- **State**: `flutter_bloc`, `equatable`
- **Network**: `dio`, `connectivity_plus`, `internet_connection_checker`
- **DI**: `get_it`, `injectable`
- **Storage**: `shared_preferences`, `flutter_secure_storage`
- **Navigation**: `go_router`
- **UI**: `google_fonts`, `flutter_svg`, `cached_network_image`, `shimmer`, `skeletonizer`, `animate_do`, `flutter_staggered_animations`, `lottie`
- **Forms**: `formz`, `phone_form_field`
- **Files**: `file_picker`, `image_picker`, `image_cropper`, `pdfx`
- **Logging**: `talker`, `talker_dio_logger`, `talker_bloc_logger`, `talker_flutter`
- **Auth**: `google_sign_in`
- **Utils**: `url_launcher`, `package_info_plus`, `device_info_plus`, `permission_handler`, `dartz`, `path_provider`
- **Serialization**: `json_annotation`, `freezed_annotation`

### Build Status

- ✅ Zero compilation errors
- ✅ Clean architecture patterns enforced
- ✅ All navigation flows working
- ✅ Theme and locale persistence verified
- ✅ 5 feature modules implemented (auth, home, profile, settings, attendance scaffold)
- ✅ Android builds successfully
- ✅ Backend API integration live

---

## Planned

- **Dashboard Feature**: Real-time dashboard stats with charts (scaffolded)
- **Push Notifications**: Firebase Cloud Messaging integration
- **App Store Release**: First production release to Google Play and App Store
- **Widget & Integration Tests**: Expanding existing unit test suite

---

## Version History

| Version | Date | Highlights |
|---------|------|------------|
| **0.5.0** | 2026-04-06 | iOS-inspired full UI/UX refactor — frosted glass nav, zero-elevation cards, refined typography, hero animations (avatar + auth logo), attendance status chip redesign, settings account section safety split, bottom nav overlap fix |
| **0.4.1** | 2026-04-05 | Offline-first architecture, connectivity banner, offline queue with auto-sync, Google Sign-In fixes, stale cache cleanup, production security hardening (R8, cleartext, Sentry sampling), 471 passing tests |
| **0.4.0** | 2026-03-26 | Auth selection screen, essential data wizard + review, profile UX overhaul (grouped sections, collapsible portfolio, quick-action chips, sticky save), AppToast, locale validation, delete account, 28 unit test files (~365 cases), localized in-app changelog |
| **0.3.0** | 2026-03-15 | Locale-aware profile refresh, skills locale fix, multi-skill add, in-app video player, searchable nationality, date input improvements, app info dialog split |
| **0.2.0** | 2026-03-11 | KPI feature, profile sub-feature refactor, full settings screen, About Us page |
| **0.1.0** | 2026-02-17 | Initial internal build — auth, profile, settings, Clean Architecture + BLoC |

---

**Legend:**

- `Added` — New features
- `Changed` — Changes to existing functionality
- `Deprecated` — Soon-to-be removed features
- `Removed` — Removed features
- `Fixed` — Bug fixes
- `Security` — Security fixes
