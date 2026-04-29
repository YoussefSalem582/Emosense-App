# 📊 Emosense — Current Project Status

> **Last Updated:** April 29, 2026
> **Version:** Aligns with `pubspec.yaml` / active release branches (prior Technology 92 timeline entries remain in changelog history).
> **Flutter:** 3.38.4 / Dart 3.10.3
> **Status:** ✅ MVP Complete | 📚 Documentation Complete | ✅ Essential Data Wizard | ✅ Offline-First Architecture | 📋 Google Play Ready | 🍎 iOS App Store Setup Done | ✅ Bug Audit Pass (8+3 fixes) | 🚧 Dashboard Scaffolded | 🚧 Production Publish Pending

---

## 🎯 Executive Summary

Emosense is a Flutter mobile application centred on emotion recognition and analytics, with complementary workforce surfaces (profiles, KPIs, attendance, tickets, HR-style flows). The codebase uses **Clean Architecture + BLoC**, bilingual ARB localization, offline-first resilience, and scalable feature modules (`auth`, `analysis`, `employee`, `emotion`, `tickets`, etc.). App-wide shell screens and the central **`screens.dart`** routing barrel live under **`lib/features/shared/presentation/`**; cross-cutting reusable widgets (barrel **`widgets/widgets.dart`**) live under **`lib/core/widgets/`**.

### Key Highlights

- ✅ **8 feature modules** (5 fully implemented, 1 with essential data wizard, 2 scaffolded)
- ✅ **Clean Architecture** across all implemented features (data → domain ← presentation)
- ✅ **18 use cases** wired through GetIt DI
- ✅ **4 BLoCs + 2 Cubits** managing state across the app
- ✅ **26 shared widgets** — reusable, feature-agnostic UI components
- ✅ **~401 localization keys** per language (English + Arabic with RTL)
- ✅ **Light/Dark theme** system with persistent preference
- ✅ **Zero compilation errors** — static analysis passing clean
- ✅ **Comprehensive documentation** — 10 technical guides in `tech_readme_files/` (agent tooling in `AGENTS.md`; mirrored rules in `.agents/`; `project-scope` + `documentation-updates` in `.cursor/rules/` and `.agents/rules/`; folder tree in `01_folder_structure.md`)
- ✅ **Unit test suite** — 29 test files, 471 test cases across all implemented features (all passing)
- ✅ **Bilingual support** (English/Arabic with full RTL) — default locale: Arabic; Arabic uses Tajawal font
- ✅ **Secure token storage** via FlutterSecureStorage (encrypted)
- ✅ **Claude Code hygiene** — signing secrets do not belong in `.claude/settings.json`; `.claude/settings.local.json` is gitignored (`08_security_and_environment.md`)
- ✅ **Environment-driven config** — secrets in `.env` loaded via **`AppConfig`** (`flutter_dotenv`; `AppConfig.loadConfig()` in `lib/main.dart`)
- ✅ **Offline-first architecture** — connectivity monitoring (Google/Apple/Cloudflare captive-portal checks), cache TTL (5 min fresh / 24h expired), offline mutation queue (attendance, KPI, profile resume/video deletes), auto-sync on reconnect, retry interceptor, PDF file caching
- 🚧 **Production publish** pending

---

## 📈 Project Metrics

### Codebase Statistics

| Metric | Count | Status |
|--------|-------|--------|
| **Total Dart Files** | 120+ | ✅ |
| **Feature Modules** | 8 (5 implemented, 1 essential data wizard, 2 scaffolded) | ✅ |
| **Use Cases** | 18 | ✅ |
| **BLoCs / Cubits** | 6 (4 BLoCs + 2 Cubits) | ✅ |
| **Shared Widgets** | 26 | ✅ |
| **Feature-Specific Widgets** | 61+ | ✅ |
| **Pages / Screens** | 18+ | ✅ |
| **Documentation Files** | 14 (+CHANGELOG) | ✅ |
| **Localization Keys** | ~401 per language | ✅ |
| **Supported Languages** | 2 (EN, AR) | ✅ |
| **Dependencies** | 38 runtime + 10 dev | ✅ |
| **API Endpoints Integrated** | 51+ | ✅ |
| **Test Files** | 29 (28 unit + 1 placeholder) | ✅ |
| **Test Cases** | 471 | ✅ |
| **Mock Classes** | 40 | ✅ |
| **Static Analysis Errors** | 0 | ✅ |

### Development Progress

```text
Architecture Setup:     ████████████████████ 100%
Auth Feature:           ████████████████████ 100%
Profile Feature:        ████████████████████ 100%
Settings Feature:       ████████████████████ 100%
KPI Feature:            ████████████████████ 100%
Home / Navigation:      ████████████████████ 100%
Documentation:          ████████████████████ 100%
Attendance Feature:     ████████████████████ 100%
Essential Info Feature: ██░░░░░░░░░░░░░░░░░░  10% (scaffolded)
Dashboard Feature:      ██░░░░░░░░░░░░░░░░░░  10% (scaffolded)
Testing:                ██████████████████░░  90% (29 test files, 471 test cases, widget tests pending)
```

---

## 🏗️ Architecture Overview

**Pattern:** Clean Architecture + BLoC (flutter_bloc)

```
Presentation (BLoC / Cubit → Pages → Widgets)
     ↓ depends on
Domain (Repositories → Use Cases → Entities)
     ↑ implemented by
Data (Remote Data Sources → Models → Repository Impl)
```

### Dependency Injection (GetIt)

| Registration | Components |
|-------------|------------|
| **External** | SharedPreferences, FlutterSecureStorage (encrypted), Talker logger |
| **ApiClient** | Singleton Dio wrapper with auth/language/logger interceptors |
| **Connectivity** | `ConnectivityService`, `ConnectivityCubit` (singleton) |
| **Offline Queue** | `OfflineQueue` (SharedPreferences-backed), `OfflineQueueProcessor` with 7 handlers |
| **Auth** | 2 data sources, 1 repo, 7 use cases, 1 **singleton** BLoC |
| **Essential Data** | 1 data source, 1 repo, 2 use cases, 1 **factory** `EssentialDataCubit` + 1 **factory** `EssentialInfoCubit` |
| **Profile** | 2 data sources, 1 repo, 1 lookups cache, 4 use cases, 1 **factory** BLoC |
| **Attendance** | 2 data sources, 1 timer service, 1 repo, 6 use cases, 1 **factory** BLoC |
| **KPI** | 2 data sources, 1 repo, 4 use cases, 1 **factory** BLoC |
| **Settings** | 1 **factory** Cubit |
| **Security** | 401 auto-logout: `ApiClient.onUnauthorized` → `AuthBloc.add(AuthSessionExpired)` |

---

## ✅ Completed Features

### 1. Authentication ✅ (8 Sub-Features)

- **Status:** Fully Functional
- **Components:** Login, Register, Forgot Password, Google Sign-In, Splash, Language Select, Onboarding, Essential Data Wizard
- **Architecture:** AuthBloc (singleton) + 8 use cases (Login, Register, Logout, ForgotPassword, GoogleSignIn, GetCachedUser, GetEssentialData, SubmitEssentialData) + EssentialDataCubit (factory)
- **Location:** `lib/features/auth/`
- **Sub-Features:**
  - **Shared** (`shared/`): Data sources, models, entities, repository, 6 auth use cases, AuthBloc, common widgets (auth header, social login button)
  - **Splash** (`splash/`): Splash page with animated logo and auto-navigation based on auth state
  - **Language Select** (`language_select/`): Language picker (EN/AR) shown on every launch
  - **Onboarding** (`onboarding/`): 3-page onboarding carousel with skip/back/next
  - **Login** (`login/`): Email/password login with form validation
  - **Register** (`register/`): Registration form with social login
  - **Forgot Password** (`forgot_password/`): Password reset flow
  - **Essential Data** (`essential_data/`): 4-step post-auth wizard (full Clean Architecture sub-feature)
  - **Essential Info** (`essential_info/`): Post-registration review screen showing submitted profile data with AI translation status banner
- **Highlights:**
  - Email/password auth with form validation (email, password, phone, name)
  - Google Sign-In with verified `id_token` exchange via `/auth/google/sign-in` + `/auth/google/sign-up` (`google_sign_in`)
  - Secure token storage via `FlutterSecureStorage` (encrypted)
  - User data caching for offline access
  - **Essential Data Wizard** — 4-step post-auth wizard enforced at router level on every auth (login, register, Google). Collects: name, age, nationality (API dropdown), specialty, phone, resume (PDF/DOC/DOCX upload with Arabic/English toggle). Uses local `SharedPreferences` flag for fast bypass + API check for validation
  - Language select page (EN/AR) shown on every launch
  - 3-page onboarding carousel with skip/back/next

### 2. Home & Navigation ✅

- **Status:** Fully Functional — Live Dashboard
- **Components:** Main shell with bottom nav (Home, KPIs, Attendance, Settings), Home dashboard with 6 extracted widget sections
- **Location:** `lib/features/home/`
- **Highlights:**
  - Employee/admin shells use IndexedStack/tab navigation patterns routed via `AppRouter`
  - Time-based greeting header (Good Morning/Afternoon/Evening) with avatar
  - Live attendance status card with real-time clock timer and quick check-in/out button
  - 4-item quick actions grid (Profile, KPIs, Attendance, Settings)
  - 3-stat summary row: profile completeness (circular progress), KPI entry count, today's worked hours
  - Recent KPI entries list (last 3) with See All navigation
  - Recent attendance records (last 3) with See All navigation
  - Pull-to-refresh reloads all three BLoCs (Profile, Attendance, KPI)
  - Main shell preloads Attendance and KPI data on first mount
  - All sections extracted into dedicated widget files under `presentation/widgets/`

### 3. Profile Feature ✅ (3 Sub-Features)

- **Status:** Fully Functional
- **Architecture:** `ProfileBloc` (factory) + 5 use cases
- **Location:** `lib/features/profile/`
- **Sub-Features:**
  - **Profile View** (`profile_view/`): 9 section cards (personal, professional, education, experience, skills, resume, video, summary, completeness)
  - **Edit Profile** (`edit_profile/`): Tabbed edit form (Personal → Professional → More) with 11 form/tab sections, 4 CRUD dialogs (add skill, delete confirm, education form, experience form)
  - **Shared** (`shared/`): Data sources, models, entities, repository, common widgets (header, info row, section card, date helpers), skeleton widgets
- **Highlights:**
  - Profile photo upload with crop support (`image_cropper`)
  - PDF viewer for resume documents (`pdfx`)
  - **In-app video player** for profile videos — full-screen `VideoPlayerPage` with chewie controls; no external app required
  - Education/experience CRUD with form dialogs
  - **Multi-skill bulk add** — "Add Skill" opens a chip-input bottom sheet (`AddSkillDialog.showMulti`) supporting multiple skills per session: `+Add` suffix button inside field, keyboard-shortcut hints (`↵ Enter` / `,`), duplicate detection with inline error, `AnimatedSize` chips area with empty placeholder and count badge header, `✓ Add · N skills` submit button
  - Skill management with add/delete confirmation
  - Resume/video/background document upload and removal
  - **Specialty display** — Profile professional card shows `specialty` from essential data (`applicant_translations`) as fallback when `industryName` is not yet set
  - **Translation pending banner** — Profile page shows an info hint when name/specialty characters don't match the app locale (AI translation still in progress)
  - **Locale-aware refresh** — Changing language while profile is loading now queues a deferred re-fetch (`_pendingLocaleRefresh`) so names update to the correct locale
  - **Offline cache:** Profile data persisted to SharedPreferences via `ProfileLocalDataSource`. Cached data shown with `OfflineBanner` on network failure; cache clears on logout. Resume/video metadata cached with profile. PDF files cached in temp directory after first view. Resume/video deletes queued via `OfflineQueue` when offline; uploads require connectivity.
  - In-memory profile caching with pull-to-refresh invalidation
  - Skeleton loading on profile and edit profile pages
  - Unsaved changes dialog when leaving edit with pending changes
  - Session expiration handling with auto-logout redirect

### 4. KPI Feature ✅

- **Status:** Fully Functional
- **Architecture:** `KpiBloc` (factory) + 4 use cases
- **Location:** `lib/features/kpi/`
- **Highlights:**
  - KPI definitions with units and value ranges from API
  - KPI entries CRUD (create, read, update, delete)
  - Date filtering with chip-based date filter row
  - Add/edit bottom sheet form with dynamic inputs (numeric, dropdown, text)
  - Delete confirmation dialog
  - Full-page skeleton placeholder on first load
  - **Offline cache:** KPI data persisted to SharedPreferences via `KpiLocalDataSource`. Cached data shown with `OfflineBanner` on network failure.
  - **Refresh:** Pull-to-refresh uses `Completer`-based handshake (avoids Equatable deduplication hang)
  - Cached `KpiLoaded` state for instant UI on subsequent navigations
  - Paginated definitions fetch
  - Per-entry notes display in entry cards
  - Refactored entry card UX: leading icon, two-row layout, popup menu delete, locale-formatted date, chat-bubble notes
  - 5 custom widgets: `AddKpiEntrySheet`, `KpiFilterSheet`, `KpiDeleteDialog`, `KpiEntryCard`, `KpiPageSkeleton`

### 5. Settings Feature ✅

- **Status:** Fully Functional
- **Architecture:** `SettingsCubit` (factory) — presentation-only, no data/domain layers
- **Location:** `lib/features/settings/`
- **Pages:** Settings page + About Us page
- **Widgets (11):**
  - `SettingsUserCard` — user info card at top
  - `SettingsThemeSection` — light/dark/system mode toggle
  - `SettingsLanguageSection` — EN/AR language switcher
  - `SettingsAccountSection` — delete account with danger-zone styling
  - `SettingsAboutSection` — about us, privacy policy, terms, app version
  - `SettingsContactSection` — company email, Riyadh phones (2), Jordan phone
  - `SettingsDevOptionsSection` — developer options (debug-only features)
  - `SettingsSectionHeader` — section title widget
  - `SettingsTile` — reusable tile row widget
  - `AppInfoDialog` — branded bottom sheet with logo, tagline, CR, version, and changelog (UI-only; data sourced from `app_changelog_data.dart`)
  - `app_changelog_data.dart` — `VersionEntry` / `ChangeGroup` models + `appChangelog` const list
- **Highlights:**
  - Privacy policy & terms links — locale-aware (EN/AR), in-app browser view
  - Dynamic version from `package_info_plus`
  - Dark mode logo support (`AppImages.logoAlt`) in About Us and App Info Dialog
  - Delete account confirmation with red styling
  - Notification settings opens system settings
  - Help opens `mailto:info@technology92.com`
  - Rate app opens Play Store listing

### 6. Attendance Feature ✅ (Implemented)

- **Status:** Fully implemented — clock in/out, live timer, status management, schedule history, in-memory caching, background timer with lock screen notification
- **Location:** `lib/features/attendance/`
- **Layers:** data (remote data source, local data source, timer service, models, repository impl) → domain (entities, repository, 6 use cases) → presentation (BLoC, page, 5 widgets incl. skeleton)
- **Widgets (5):** `AttendanceTimerCard`, `AttendanceStatusSelector`, `AttendanceActionButton`, `AttendanceScheduleSection`, `AttendancePageSkeleton`
- **Navigation:** Integrated into bottom nav bar (tab 4 of 5)
- **Endpoints (6):** statuses, current, check-in, status/update, check-out, Schedule — all 1:1 mapped
- **Caching:** In-memory `_cachedState` in BLoC — instant UI on tab switch/refresh, error resilience. Persisted to SharedPreferences via `AttendanceLocalDataSource` so cache survives app/hot restarts.
- **Refresh:** Pull-to-refresh uses `Completer`-based handshake (avoids Equatable deduplication hang)
- **Offline UX:** Cached data shown with warning banner (wifi-off icon + retry) when network fails; full-screen error only on first-ever load (no prior cache)
- **Background timer:** Android foreground service (`flutter_foreground_task`) shows persistent notification with live elapsed time and status label. Visible on lock screen and notification center. Starts on check-in, stops on check-out. Page receives elapsed from service isolate instead of local `Timer.periodic`.

### 7. Essential Info Feature ✅ (Implemented)

- **Status:** Complete — presentation-only sub-feature under `auth/`
- **Location:** `lib/features/auth/essential_info/`
- **What it does:** Shown after first-time registration + essential data submission. Displays the submitted profile fields (name, age, nationality, specialty, phone) and an AI translation status banner. "Continue to Home" dispatches `AuthEssentialDataCompleted` and navigates to `/home`.
- **Reuses:** `GetEssentialDataUseCase` and `EssentialDataEntity` from `auth/essential_data/` — no new data/domain layers needed.

---

## 🎨 Design System

### Colours (`AppColors`)

| Token | Value | Usage |
|-------|-------|-------|
| **Primary** | `#5B6EF5` | Brand blue — buttons, links, active states |
| **Primary Light** | `#8B96F9` | Lighter primary variant |
| **Primary Dark** | `#3D4ED4` | Darker primary variant |
| **Primary Tint** | `#EEF0FE` | Subtle primary background tint |
| **Secondary** | `#E9C62B` | Accent yellow — highlights |
| **Background Light** | `#F2F2F7` | iOS-style system grouped background |
| **Background Dark** | `#000000` | True black dark mode scaffold |
| **Dark Surface** | `#1C1C1E` | iOS-style elevated dark surface |
| **Frosted Glass** | `frostedLight` / `frostedDark` | Backdrop filter glass effect |
| **Separator** | `#C6C6C8` | iOS-style separator lines |
| **Status** | success (#34C759), error (#FF3B30), warning (#FF9500), info (#5AC8FA) | Each with light variant |

### Typography (`AppTextStyles`)

- **Font:** PublicSans (EN) / Tajawal (AR) — locale-aware via `AppFonts.forLocale`; fallback: Roboto
- **Scale:** Material 3 type scale (`displayLarge` → `labelSmall`)
- **iOS HIG-inspired:** negative `letterSpacing` on headlines, increased `fontWeight` contrast between hierarchy levels

### Spacing (`AppSpacing`)

- **Presets:** `xxs`=2, `xs`=4, `sm`=8, `md`=12, `base`=16, `lg`=20, `xl`=24, `xxl`=32, `xxxl`=40
- **SizedBox Helpers:** `AppSpacing.verticalBase`, `AppSpacing.horizontalSM`, etc.
- **Padding Helpers:** `AppSpacing.pagePadding`, `AppSpacing.screenPadding`, `AppSpacing.paddingAll16`

### Radius (`AppRadius`)

- **Presets:** `xs`=4, `sm`=6, `md`=8, `base`=10, `lg`=12, `xl`=16, `xxl`=20, `round`=100

---

## 🧩 Shared Widgets (26)

| Widget | File | Description |
|--------|------|-------------|
| `CustomAppBar` | `app_bar/custom_app_bar.dart` | Themed AppBar with optional blur backdrop + chevron back button |
| `AuthPatternBackground` | `background/auth_pattern_background.dart` | Subtle radial gradient overlay for auth screens |
| `AppButton` | `buttons/app_button.dart` | Elevated / outlined / text / icon / loading button with scale animation |
| `AppCard` | `cards/app_card.dart` | Zero-elevation card with subtle border |
| `AppBottomSheet` | `dialogs/app_bottom_sheet.dart` | Themed bottom sheet helper |
| `UnsavedChangesDialog` | `dialogs/unsaved_changes_dialog.dart` | Discard/save confirmation dialog |
| `EmptyStateWidget` | `empty/empty_state_widget.dart` | Illustration + title + subtitle + optional action |
| `AppErrorWidget` | `error/error_widget.dart` | Error display with retry button |
| `AppTextField` | `inputs/app_text_field.dart` | Text field + password field with validation |
| `AppDropdownField` | `inputs/app_dropdown_field.dart` | Generic typed dropdown field |
| `AppSearchableDropdownField` | `inputs/app_searchable_dropdown_field.dart` | Dropdown that opens a live-filter search bottom sheet |
| `AppPhoneField` | `inputs/app_phone_field.dart` | Phone input with country code picker |
| `AppDateField` | `inputs/app_date_field.dart` | Date picker input field |
| `AppDateInputSheet` | `inputs/app_date_input_sheet.dart` | Bottom sheet date input |
| `ConnectivityBanner` | `banners/connectivity_banner.dart` | Network status banner |
| `OfflineBanner` | `banners/offline_banner.dart` | Offline warning with retry |
| `AppToast` | `banners/app_toast.dart` | Themed toast notification |
| `TranslationPendingBanner` | `banners/translation_pending_banner.dart` | AI translation in-progress hint |
| `AppDateFilter` | `filters/app_date_filter.dart` | Date filter chip row |
| `FilterIconButton` | `filters/filter_icon_button.dart` | Filter toggle button |
| `FilterSheetActions` | `filters/filter_sheet_actions.dart` | Filter bottom sheet action buttons |
| `AppLoading` | `loading/app_loading.dart` | CupertinoActivityIndicator, overlay loading, shimmer placeholder |
| `PdfViewerPage` | `pdf_viewer/pdf_viewer_page.dart` | Full-screen PDF viewer with download |
| `VideoPlayerPage` | `video_player/video_player_page.dart` | Full-screen in-app video player (video_player + chewie) |
| `PhotoPickerBottomSheet` | `photo_picker/photo_picker_bottom_sheet.dart` | Camera/gallery picker bottom sheet |
| `ResponsiveLayout` | `responsive/responsive_layout.dart` | Mobile/tablet/desktop breakpoint builder |

---

## 🧪 Testing

### Test Suite Summary

| Category | Files | Tests | Coverage |
|----------|-------|-------|----------|
| BLoC / Cubit | 5 | ~95 | Auth, Attendance, KPI, Profile, Settings |
| Repository Impl | 4 | ~70 | Auth, Attendance, KPI, Profile |
| Model Serialization | 4 | ~65 | User, Attendance (3), KPI (3), Profile (9) |
| Use Cases | 4 | ~55 | Auth (7), Attendance (6), KPI (4), Profile (4) |
| Entities | 4 | ~60 | User, Attendance, KPI, Profile (8 sub-entities) |
| Core Utilities | 7 | ~65 | Validators, StringExt, Failures, Exceptions, ApiResponse, ApiEndpoints, StorageKeys |
| Essential Data | 1 | ~61 | Cubit, repository, models, use cases |
| **Total** | **29** | **~471** | **All implemented features** |

### Test Infrastructure

- **Mock Library:** `mocktail` (40 mock classes in `test/helpers/mocks.dart`)
- **Fixture Files:** 4 fixture files with sample entities, models, and JSON (`test/fixtures/`)
- **BLoC Testing:** `bloc_test` package for `blocTest` helper
- **Reference:** See [10_testing.md](10_testing.md) for full testing guide

### Remaining Coverage

- Widget tests (shared widgets, feature widgets)
- Integration tests (end-to-end flows)
- Scaffolded features (Essential Info, Dashboard) — no implementation to test yet

---

## 🔧 Technical Stack

### Dependencies (38 runtime)

| Category | Packages |
|----------|----------|
| **State** | `flutter_bloc` ^9.1.0, `equatable` ^2.0.7 |
| **Network** | `dio` ^5.7.0, `connectivity_plus` ^6.1.4, `internet_connection_checker` |
| **DI** | `get_it` ^9.2.1, `injectable` ^2.5.0 |
| **Storage** | `shared_preferences` ^2.5.3, `flutter_secure_storage` ^10.0.0 |
| **Navigation** | `go_router` ^17.1.0 |
| **UI** | `google_fonts`, `flutter_svg`, `cached_network_image`, `shimmer`, `skeletonizer`, `animate_do`, `flutter_staggered_animations`, `lottie` |
| **Forms** | `formz`, `phone_form_field` |
| **Files** | `file_picker`, `image_picker`, `image_cropper`, `pdfx`, `video_player`, `chewie` |
| **Logging** | `talker`, `talker_dio_logger`, `talker_bloc_logger`, `talker_flutter` |
| **Auth** | `google_sign_in` |
| **Utils** | `url_launcher`, `package_info_plus`, `device_info_plus`, `permission_handler`, `dartz`, `path_provider` |
| **Serialization** | `json_annotation`, `freezed_annotation` |
| **Env** | `AppConfig` (`flutter_dotenv`, loaded in `main.dart`) |
| **Monitoring** | `firebase_core`, `sentry_flutter` |

### Dev Dependencies (10)

| Package | Purpose |
|---------|---------|
| `flutter_lints` | Lint rules |
| `build_runner` | Code generation |
| `json_serializable` | JSON model generation |
| `freezed` | Immutable data classes |
| `injectable_generator` | DI code generation |
| `bloc_test` | BLoC unit testing |
| `mocktail` | Mocking library |
| `flutter_launcher_icons` | App icon generation |
| `flutter_native_splash` | Splash screen |

---

## 🌐 API Integration

- **Base URL:** `https://admin.technology92.com` — configured via `.env` (`API_BASE_URL`)
- **API Version:** `v1` — configured via `.env` (`API_VERSION`)
- **Auth:** Bearer token in `Authorization` header via Dio interceptor
- **Language:** `Accept-Language` header set from app locale
- **Endpoints:** 50+ across Auth, Jobs, Profile, KPI, Attendance, Lookups, Essential Info, Dashboard
- **Reference:** See [09_api_endpoints.md](09_api_endpoints.md) for full endpoint documentation

---

## 🔒 Security

- **Tokens:** Stored in `FlutterSecureStorage` with `encryptedSharedPreferences: true`
- **Secrets:** All in `.env` (git-ignored); accessed via getters on **`AppConfig`** (see `08_security_and_environment.md`)
- **Session Expiry:** 401 responses trigger `AuthSessionExpired` → auto-logout
- **Release Builds:** Obfuscated with `--obfuscate --split-debug-info`
- **Reference:** See [08_security_and_environment.md](08_security_and_environment.md)

---

## 📚 Documentation Status

### Documentation Files (100% Complete)

| # | File | Topic |
|---|------|-------|
| 01 | `01_folder_structure.md` | Full `lib/` directory map |
| 02 | `02_architecture.md` | Clean Architecture + BLoC explanation |
| 03 | `03_how_to_add_new_feature.md` | Step-by-step feature scaffold guide |
| 04 | `04_how_to_add_new_api.md` | Adding a new API endpoint end-to-end |
| 05 | `05_how_to_add_new_language.md` | Adding/updating ARB translations |
| 06 | `06_how_to_change_theme_colors.md` | Theme and colour customisation |
| 07 | `07_how_to_create_reusable_component.md` | Shared widget creation guide |
| 08 | `08_security_and_environment.md` | `.env` setup, token storage, obfuscation |
| 09 | `09_api_endpoints.md` | Complete API endpoint reference (50+) |
| 10 | `10_testing.md` | Testing guide, patterns, coverage |
| — | `GOOGLE_PLAY_DATA_SAFETY_PLAN.md` | Complete Google Play Data Safety questionnaire plan |
| — | `TEST_COVERAGE_ANALYSIS.md` | Original coverage analysis and priorities |
| — | `CHANGELOG.md` | Version history (v0.1.0 → v1.0.0) |
| — | `CURRENT_STATUS.md` | This file |
| — | `DOCUMENTATION_UPDATE_SUMMARY.md` | Change log per documentation session |

---

## 🔀 Git & Branch Status

### Branches

| Branch | Status | Description |
|--------|--------|-------------|
| `master` | Production base | v0.4.0 — last merge: `feat/profile-ux-refactor-toast-localization` — 2026-03-26 |

### Merged Pull Requests

| PR | Branch | Date | Summary |
|----|--------|------|---------|
| #50 | `refactor/auth-sub-features` | 2026-03-22 | Auth restructured into sub-features, essential data wizard, essential info review |
| #49 | `claude/analyze-test-coverage` | 2026-03-20 | Test coverage analysis + 4-phase unit test suite (~365 cases) |
| #48 | `claude/implement-todo-item` | 2026-03-19 | Home skeleton, empty states, router error page fix |
| #47 | `feature/profile-sub-features` | 2026-03-16 | Profile sub-features, locale refresh, translation banner, specialty, delete account |
| #46 | `feature/kpi` | 2026-03-14 | KPI filter sheet, attendance filter, offline cache, background timer |
| #45 | `feature/profile-sub-features` | 2026-03-13 | Multi-skill add, video player, searchable nationality |
| #44 | `feature/profile-sub-features` | 2026-03-12 | Experience/education form UX, country field, date input |
| #33 | `feature/kpi` | 2026-03-11 | KPI definitions, entries CRUD, date filter, skeleton, pagination |
| #32 | `feature/profile-sub-features` | 2026-03-10 | Profile sub-feature split, 9 section cards, edit profile CRUD |
| #31 | `feature/fix-job-endpoints` | 2026-03-05 | Job endpoint fixes, sub-feature split, skeleton loaders, saved jobs |

---

## 🔮 Planned Features

### Immediate Priority (Ready for Submission)

- ✅ **Google Play Data Safety Questionnaire**: Complete plan document created with exact answers for all 5 steps, full data inventory (50+ data points), third-party disclosures, and compliance verification checklists. Account deletion and granular data deletion already implemented.

### Near-Term

- **Dashboard Feature**: Real-time stats, charts, activity feed (scaffolded)
- **Push Notifications**: Firebase Cloud Messaging integration
- **App Store / Play Store release**: First production publish

### Future

- Widget & integration tests (expanding existing unit test suite)
- Advanced search and filtering across features
- Data export feature (GDPR compliance)
- Certificate pinning for enhanced security
- User opt-out for Sentry crash reporting
