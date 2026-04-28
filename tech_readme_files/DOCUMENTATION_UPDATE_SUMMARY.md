# Documentation Update Summary

---

## April 29, 2026 — Claude settings security + gitignore

**Status:** Complete

**What changed:** Removed plaintext release signing credentials from `.claude/settings.json`. Added `.claude/settings.local.json` to root `.gitignore`. Extended **Agent tooling layout** in `AGENTS.md` / `.agents/AGENTS.md` with `.claude/settings.json` and `.claude/settings.local.json` rows. Added **Claude Code / AI editor settings** subsection to `tech_readme_files/08_security_and_environment.md`.

**Files modified:** `.claude/settings.json`, `.gitignore`, `AGENTS.md`, `.agents/AGENTS.md`, `CLAUDE.md`, `.cursor/rules/security.mdc`, `.agents/rules/security.md`, `CHANGELOG.md`, `tech_readme_files/08_security_and_environment.md`, `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`, `tech_readme_files/CURRENT_STATUS.md`

---

## April 29, 2026 — Agent tooling layout (AGENTS.md)

**Status:** Complete

**What changed:** Added a repository-root **Agent tooling layout** table to `AGENTS.md` listing `.agents/`, `.claude/`, `.cursor/`, all agent-related `*ignore` files, and `AGENTS.md` / `CHANGELOG.md` / `CLAUDE.md` / `tech_readme_files/`. Updated the skills pointer to include `.cursor/skills/` alongside `.agents/skills/` and `.claude/commands/`. **Follow-up:** Mirrored the same table in `.agents/AGENTS.md` (for tools that only read that file). Added a pointer section in `CLAUDE.md` to `AGENTS.md` for the layout; **Custom Commands** now mentions `.agents/skills/` and `.cursor/skills/` in addition to `.claude/commands/`.

**Second follow-up:** Added `# Full inventory: AGENTS.md — "Agent tooling layout (repository root)"` to headers of all assistant `*ignore` files (`.agentignore`, `.aiderignore`, `.claudeignore`, `.copilotignore`, `.cursorignore`, `.cursorindexingignore`, `.geminiignore`, `.windsurfignore`). New **Agent & AI tooling (repository root)** subsection in `tech_readme_files/01_folder_structure.md`. `.cursor/rules/documentation-updates.mdc` now links to the layout section in `AGENTS.md`.

**Third follow-up:** Mirrored the documentation-updates link in `.agents/rules/documentation-updates.md`. Added **Agent tooling (repository root)** to `.cursor/rules/project-scope.mdc` and `.agents/rules/project-scope.md`. Extended the **Top-Level** tree in `01_folder_structure.md` with `AGENTS.md` / `CLAUDE.md` / `CHANGELOG.md` and `.agents/` / `.claude/` / `.cursor/` entries.

**Files modified (agent tooling doc pass, April 29, 2026):** `AGENTS.md`, `CLAUDE.md`, `.agents/AGENTS.md`, all `*ignore` headers, `tech_readme_files/01_folder_structure.md`, `.cursor/rules/documentation-updates.mdc`, `.cursor/rules/project-scope.mdc`, `.agents/rules/documentation-updates.md`, `.agents/rules/project-scope.md`, `CHANGELOG.md`, `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`, `tech_readme_files/CURRENT_STATUS.md`

---

## April 8, 2026 — Profile & Attendance Bug Fixes (v0.5.2)

**Status:** Complete — 4 bugs fixed (currency icon, edit profile data loss, cache field loss, attendance missed checkout)

**What changed:**
1. Replaced dollar sign icon with Saudi Riyal SVG in edit profile compensation currency dropdown
2. Fixed edit profile opening with empty fields when BLoC was in a transient state
3. Fixed profile cache fallback dropping 12 fields, which caused data overwrite on save
4. Attendance schedule entries with no checkout now show warning indicator instead of misleading "0m"

**Files created:**
- `assets/icons/saudi-riyal.svg` — Saudi Riyal currency SVG icon

**Files modified:**
- `lib/shared/assets/app_assets.dart` — Added `AppIcons.saudiRiyal` constant
- `lib/shared/widgets/inputs/app_dropdown_field.dart` — Added `prefixWidget` parameter
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_professional_tab.dart` — Saudi Riyal SVG
- `lib/features/profile/edit_profile/presentation/pages/edit_profile_page.dart` — Dispatch `ProfileLoadRequested` when no cached data
- `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — Fixed `_persistProfileCache` fallback
- `lib/features/attendance/presentation/widgets/attendance_schedule_section.dart` — Detect missed checkout
- `lib/l10n/arb/app_en.arb`, `lib/l10n/arb/app_ar.arb` — Added `missedCheckout` key

---

## April 8, 2026 — Documentation Audit & Sync (v0.5.2)

**Status:** Complete — 20+ discrepancies identified and fixed across all documentation, agent rules, and skills

**What changed:** Comprehensive audit of all documentation files, AI agent instruction files (CLAUDE.md, AGENTS.md, .agents/AGENTS.md), Cursor rules (.cursor/rules/), .agents/rules/, and tech_readme_files/ against actual codebase state. Accumulated drift since the v0.5.0 iOS-style UI refactor was corrected.

**Files modified:**

- `CLAUDE.md` — Fixed colors (#5B6EF5), added new design tokens (frosted, separator, neutral, shimmer), updated typography (Tajawal + iOS HIG), added spacing tokens (huge/massive), removed stale jobs/ widget references, fixed auth widget paths, added flutter_foreground_task + Offline-First to overview, corrected all widget counts
- `AGENTS.md` — Added flutter_foreground_task to overview, added spacing tokens (huge/massive)
- `.agents/AGENTS.md` — Same fixes as CLAUDE.md: colors, tokens, typography, widget table (removed jobs/, fixed auth paths, corrected settings count to 11), added attendance/home widgets
- `tech_readme_files/CURRENT_STATUS.md` — Fixed primary color (#5B6EF5), background (#F2F2F7), expanded color table with new tokens, shared widgets count 16→26 with complete table, DI table expanded (added Connectivity, OfflineQueue, EssentialData, Attendance), settings widgets corrected (10→11 with accurate names), KPI widgets 6→5, test section reconciled (471 cases / 29 files), typography updated
- `.cursor/rules/ui-design-system.mdc` — Fixed colors, added new tokens, spacing (huge/massive), typography (Tajawal, iOS HIG)
- `.agents/rules/ui-design-system.md` — Mirror of .cursor/rules/ fixes
- `CHANGELOG.md` — Added v0.5.2 entry documenting this audit

**Key decisions:**

- Removed all `features/jobs/` references since no jobs feature exists in `lib/features/`
- Corrected `AuthHeader` and `SocialLoginButton` paths from `auth/presentation/` to `auth/shared/presentation/`
- Added 9 missing shared widgets to CURRENT_STATUS table (banners, filters, date inputs)
- Expanded DI table to reflect all 6 feature registrations + core services
- Used actual file counts from codebase glob results rather than outdated estimates

---

## April 7, 2026 — Comprehensive Bug Audit & Fixes (v0.5.1)

**Status:** Complete — 8 bugs identified, fixed, and verified with runtime evidence

**What changed:** Systematic bug audit across all features. Identified 8 issues (2 high, 4 medium, 2 low) using static analysis and runtime instrumentation. All fixes verified with before/after log comparison.

**Files modified:**

- `lib/features/home/presentation/pages/home_page.dart` — H1: Completer-based refresh instead of stream listener race
- `lib/features/profile/profile_view/presentation/bloc/profile_event.dart` — H1: Added `Completer<void>?` to `ProfileLoadRequested`
- `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — H1: Complete event completer in `finally` block
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — H2: Captured bloc ref before async, added 10s timeout
- `lib/features/auth/register/presentation/pages/register_page.dart` — H3: `mounted` guard after photo picker
- `lib/features/attendance/presentation/pages/attendance_page.dart` — H3: `mounted` guard after date picker
- `lib/features/kpi/presentation/pages/kpi_page.dart` — H3/H5: `mounted` guard + actionError toast
- `lib/features/profile/edit_profile/presentation/pages/edit_profile_page.dart` — H3: `mounted` guards after photo pickers and back handler
- `lib/features/profile/edit_profile/presentation/widgets/dialogs/education_form_dialog.dart` — H3: `mounted` guard
- `lib/features/profile/edit_profile/presentation/widgets/dialogs/experience_form_dialog.dart` — H3: `mounted` guard
- `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — H4/H6: scheduleResult error check + offline queue for status update
- `lib/features/kpi/presentation/bloc/kpi_bloc.dart` — H5: actionError emission on failure
- `lib/features/kpi/presentation/bloc/kpi_state.dart` — H5: Added `actionError` field to `KpiLoaded`
- `lib/shared/widgets/banners/app_toast.dart` — H7: Removed unused `isDark`
- `lib/features/auth/shared/data/repositories/auth_repository_impl.dart` — H8: Added `AuthException` catch

**Key decisions:**

- Used `Completer` pattern (matching existing Attendance/KPI convention) instead of stream listeners to avoid Equatable deduplication
- Captured BLoC references before async operations to prevent deactivated widget crashes
- 10s timeout chosen as safe ceiling for profile refresh (API has 15s connect timeout + 2 retries)

---

## April 6, 2026 — iOS App Store Publishing Setup

**Status:** In progress — code-side changes complete; user actions pending

**What changed:** Prepared the iOS target for App Store submission.

**Files created:**

- `ios/ExportOptions.plist` — App Store archive export configuration (fill in `YOUR_TEAM_ID`)

**Files modified:**

- `ios/Runner.xcodeproj/project.pbxproj` — Fixed bundle ID from `com.example.technologyNinetyTwo` → `com.technology92.employee` in all 5 build configurations (Debug, Release, Profile for Runner; Debug, Release, Profile for RunnerTests → `.RunnerTests`)
- `ios/Runner/GoogleService-Info.plist` — Updated `BUNDLE_ID` key to `com.technology92.employee`
- `ios/Runner/Info.plist` — Added 5 required iOS permission keys: `NSPhotoLibraryUsageDescription`, `NSCameraUsageDescription`, `NSPhotoLibraryAddUsageDescription`, `NSMicrophoneUsageDescription`, `LSApplicationQueriesSchemes`
- `CHANGELOG.md` — Documented iOS publishing setup under v0.5.0
- `tech_readme_files/CURRENT_STATUS.md` — Added iOS App Store setup status badge

**Key decisions:**

- Bundle ID aligned with Android `com.technology92.employee` for consistency across platforms
- `LSApplicationQueriesSchemes` covers https/http/tel/mailto for `url_launcher`
- `ExportOptions.plist` uses `signingStyle: automatic` — team should set `teamID` before first archive

**Remaining user actions before App Store submission:**

1. Register `com.technology92.employee` in Apple Developer Console
2. Regenerate `GoogleService-Info.plist` from Firebase Console for the new iOS bundle ID
3. Create app in App Store Connect
4. On Mac: `flutter pub get` → `cd ios && pod install` → Xcode archive
5. Fill in `YOUR_TEAM_ID` in `ios/ExportOptions.plist`

---

## April 6, 2026 — v0.5.0 Release

**Status:** Released as v0.5.0+10

**What changed:** Comprehensive iOS-inspired UI/UX redesign with hero animations, UX safety improvements, and status chip refinement.

**Hero animations added:**

- `profile-avatar` tag: `HomeGreetingHeader` (28px) → `ProfileHeader` (44px) → `EditPersonalTab`. Also on `SettingsUserCard` (30px) for Settings → Profile navigation.
- `auth-logo` tag: `SplashPage` (220px) → `LanguageSelectPage` (160px). Also chains across `AuthHeader` in Auth Select → Login → Register → Forgot Password.

**UX fixes:**

- Removed `extendBody: true` from `MainShell` Scaffold — bottom nav no longer overlaps scrollable content
- Split Logout and Delete Account into separate visual sections with spacing — prevents accidental destructive action
- Refined attendance status chips: colored dot + neutral text replaces colored icon + colored text + colored border

**Version bumped:** `0.4.4+9` → `0.5.0+10` in `pubspec.yaml`

---

## April 6, 2026 — iOS-Inspired Full UI/UX Refactor

**Status:** ✅ Complete

**What changed:** Complete visual overhaul of the app following Apple HIG-inspired design principles — frosted glass, muted palette, refined typography, zero-elevation cards, subtle animations.

**Files modified:**

- `lib/config/theme/app_colors.dart` — iOS system colors, frosted glass tokens, better dark surface hierarchy
- `lib/config/theme/app_text_styles.dart` — Tight headline tracking, 17px body, iOS large title style
- `lib/config/theme/light_theme.dart` — Zero-elevation cards, transparent app bars, rounded bottom sheets, InkSparkle
- `lib/config/theme/dark_theme.dart` — True dark (#000000), Apple-style surface layers
- `lib/shared/widgets/app_bar/custom_app_bar.dart` — Frosted glass blur option, chevron back button
- `lib/shared/widgets/buttons/app_button.dart` — 54px height, scale-down press animation, theme-aware loading
- `lib/shared/widgets/cards/app_card.dart` — No InkWell when non-tappable, 16px radius
- `lib/shared/widgets/inputs/app_text_field.dart` — 12px radius, 20px icon size
- `lib/shared/widgets/empty/empty_state_widget.dart` — Circular icon container, theme-driven colors
- `lib/shared/widgets/loading/app_loading.dart` — CupertinoActivityIndicator, AbsorbPointer overlay
- `lib/shared/widgets/background/auth_pattern_background.dart` — Radial gradient replacing tiled tech pattern
- `lib/features/home/presentation/pages/main_shell.dart` — Frosted BackdropFilter nav bar, haptic feedback
- `lib/features/home/presentation/widgets/home_greeting_header.dart` — InkWell, larger avatar, em-dash placeholder
- `lib/features/home/presentation/widgets/home_quick_actions.dart` — Monochrome primary icons
- `lib/features/home/presentation/widgets/home_stats_row.dart` — Unified primary accent, simple percentage
- `lib/features/home/presentation/widgets/home_attendance_card.dart` — Tabular figures, outlined chips
- `lib/features/home/presentation/widgets/home_recent_kpis.dart` — Unified icon well color
- `lib/features/home/presentation/widgets/home_recent_attendance.dart` — Unified icon well color
- `lib/features/auth/splash/presentation/pages/splash_page.dart` — Clean background, CupertinoActivityIndicator
- `lib/features/auth/language_select/presentation/pages/language_select_page.dart` — Fixed bilingualScheme bug
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — Design-token chips
- `lib/features/profile/edit_profile/presentation/pages/edit_profile_page.dart` — Thinner tab indicator
- `lib/features/kpi/presentation/pages/kpi_page.dart` — AppSpacing tokens
- `lib/features/settings/presentation/widgets/common/settings_tile.dart` — Smaller icon containers
- `lib/features/settings/presentation/widgets/common/settings_section_header.dart` — Lighter weight
- `lib/features/settings/presentation/pages/about_us_page.dart` — Smaller icon containers

**Key decisions:**

- Kept iOS-system color palette (e.g. `#34C759` success, `#FF3B30` error) for semantic colors
- Used `BackdropFilter` for frosted glass on nav bar and optional app bar
- Replaced tiled pattern with single radial gradient to eliminate "AI template" look
- Monochrome icons on home dashboard to reduce visual noise

---

## April 6, 2026 — KPI Page Design Token Refinement

**Status:** ✅ Complete

**What changed:** Replaced the last hardcoded padding in `kpi_page.dart` with `AppSpacing` tokens. The attendance page was audited and found already fully tokenized — no changes needed.

**Files modified:**

- `lib/features/kpi/presentation/pages/kpi_page.dart` — `EdgeInsets.fromLTRB(16, 8, 16, 0)` → `EdgeInsets.fromLTRB(AppSpacing.base, AppSpacing.sm, AppSpacing.base, 0)`
- `CHANGELOG.md` — Added entry under `[Unreleased]`

**Key decisions:**

- Attendance page already uses `AppSpacing.pagePadding` and spacing helpers throughout — no modifications required.

---

## April 4, 2026 — App-Wide Bug Audit & Fixes

**Status:** ✅ Complete

**What changed:** Full-codebase bug audit following the Dio/GoRouter work. Three parallel Explore agents audited the data layer, UI lifecycle, and BLoC state management. Findings were manually verified to filter false positives; 10 real defects were fixed.

**Fixes by severity:**

- **HIGH** — `response.data!` force-unwraps in 16 datasource call sites replaced with `ApiResponse.requireData()` (new helper in `api_response.dart`) to throw typed `ServerException` instead of NPE.
- **HIGH** — `experience_form_dialog._fetchCountries` now guards `setState` with `mounted` to prevent "setState called after dispose".
- **MEDIUM** — Added `listenWhen` filters to 5 `BlocListener`s (main_shell, settings_page, profile_page, edit_profile_page, attendance_page) so listeners only run on the exact states they handle.
- **MEDIUM** — Added `context.mounted` guards to async listeners in `essential_data_wizard_page` and `forgot_password_page`.
- **MEDIUM** — Hardcoded English strings in `add_skill_dialog` replaced with new l10n keys (`toAddASkill`, `addedSkillsAppearHere`, `skillsToAdd`, `skillCountSingular`, `skillCountPlural`).
- **MEDIUM** — `launchUrl` in `settings_about_section` wrapped in try/catch, surfaces `couldNotOpenLink` snackbar on failure.
- **LOW** — Repository error mappings now forward `AuthException.message` + `statusCode` to `AuthFailure` instead of hardcoded "Session expired" (39 sites in Profile/Attendance/KPI repos).
- **LOW** — `ProfileModel.fromJson` avatarUrl operator-precedence fix: `(json['avatar_url'] ?? json['image']) as String?`.
- **LOW** — Removed 3 dead `OfflineActionType` constants (`profileUpdatePersonal`, `profileUpdateProfessional`, `profileUpdateSummary`).

**Rejected false positives** (no change made):

- `?middleName` null-aware map syntax — valid Dart 3.3+.
- `home_attendance_card.dart` timer — already cancelled correctly before reassignment.
- `OfflineQueueProcessor` concurrency — `_processing` flag already prevents re-entrancy.

**Files modified:**

- `lib/core/api/api_response.dart` — added `requireData()` helper.
- `lib/features/auth/shared/data/datasources/auth_remote_datasource.dart`
- `lib/features/profile/shared/data/datasources/profile_remote_datasource.dart`
- `lib/features/auth/essential_data/data/datasources/essential_data_remote_datasource.dart`
- `lib/features/profile/edit_profile/presentation/widgets/dialogs/experience_form_dialog.dart`
- `lib/features/home/presentation/pages/main_shell.dart`
- `lib/features/settings/presentation/pages/settings_page.dart`
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart`
- `lib/features/profile/edit_profile/presentation/pages/edit_profile_page.dart`
- `lib/features/attendance/presentation/pages/attendance_page.dart`
- `lib/features/auth/essential_data/presentation/pages/essential_data_wizard_page.dart`
- `lib/features/auth/forgot_password/presentation/pages/forgot_password_page.dart`
- `lib/features/profile/edit_profile/presentation/widgets/dialogs/add_skill_dialog.dart`
- `lib/features/settings/presentation/widgets/sections/settings_about_section.dart`
- `lib/features/profile/shared/data/models/profile_model.dart`
- `lib/features/profile/shared/data/repositories/profile_repository_impl.dart`
- `lib/features/attendance/data/repositories/attendance_repository_impl.dart`
- `lib/features/kpi/data/repositories/kpi_repository_impl.dart`
- `lib/core/network/offline_queue.dart`
- `lib/l10n/arb/app_en.arb`, `lib/l10n/arb/app_ar.arb`

---

## April 4, 2026 — Dio & GoRouter Audit and Fixes

**Status:** ✅ Complete

**What changed:** Comprehensive audit of Dio HTTP client and GoRouter routing implementations. Fixed critical bugs, improved type safety, and standardized navigation patterns.

**Key fixes:**

1. **Critical 401 bug** — Auth token was unconditionally deleted on any 401, including failed login attempts with wrong credentials. Moved token deletion inside the `wasAuthenticated` guard.
2. **Unsafe validation error cast** — `value.cast<String>()` replaced with `whereType<String>()` to prevent TypeError on unexpected backend responses.
3. **Production debug logging** — GoRouter `debugLogDiagnostics` gated behind `EnvConfig.current.enableLogging`.
4. **Route type safety** — Migrated pdf-viewer, video-player, and edit-profile routes from untyped `state.extra` to query parameters.
5. **Navigation consistency** — All hardcoded `context.go('/path')` calls migrated to `context.goNamed(RouteNames.x)` across 12 files.
6. **Dead code cleanup** — Removed 12 unused RouteNames constants.
7. **OfflineQueue logging** — Added error logging for queue deserialization failures.

**Files modified:**

- `lib/core/api/api_client.dart` — 401 fix + validation cast fix
- `lib/config/routes/app_router.dart` — Debug logging gate, query params migration, EnvConfig import
- `lib/config/routes/route_names.dart` — Removed 12 unused constants
- `lib/core/network/offline_queue.dart` — Added deserialization error logging
- `lib/features/home/presentation/pages/main_shell.dart` — Named routes
- `lib/features/home/presentation/widgets/home_quick_actions.dart` — Named routes
- `lib/features/home/presentation/widgets/home_recent_kpis.dart` — Named routes
- `lib/features/home/presentation/widgets/home_recent_attendance.dart` — Named routes
- `lib/features/home/presentation/widgets/home_attendance_card.dart` — Named routes
- `lib/features/settings/presentation/pages/settings_page.dart` — Named routes
- `lib/features/settings/presentation/widgets/sections/settings_user_card.dart` — Named routes
- `lib/features/auth/onboarding/presentation/pages/onboarding_page.dart` — Named routes
- `lib/features/auth/auth_select/presentation/pages/auth_select_page.dart` — Named routes
- `lib/features/auth/login/presentation/pages/login_page.dart` — Named routes + RouteNames constant
- `lib/features/auth/language_select/presentation/pages/language_select_page.dart` — Named routes
- `lib/features/auth/splash/presentation/pages/splash_page.dart` — Named routes
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — Query params
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_resume_section.dart` — Query params
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_video_section.dart` — Query params

---

## April 2, 2026 — v0.4.1 Hotfixes (Attendance, Notifications, Cache)

**Status:** ✅ Complete

**What changed:** Fixed three bugs reported during Google Play Console testing:

1. **Attendance status language bug** — Status chip labels (Available, Busy, etc.) did not update when switching locale. Added `AttendanceResetRequested` event that clears in-memory + local cache and re-fetches with the new locale header.
2. **Notification persistence on logout/delete** — Foreground timer service kept running after logout or account deletion. `MainShell` now dispatches reset events for Attendance and KPI BLoCs on both `AuthUnauthenticated` and `AuthAccountDeleted`.
3. **Stale cache after account switch** — Old user's name/data persisted after account deletion and re-login. `AuthAccountDeleted` was not handled in `MainShell`, leaving in-memory BLoC caches stale. Added `clear()` to Attendance and KPI local datasources; BLoC reset handlers now wipe both memory and SharedPreferences.

**Files modified:**

- `lib/features/attendance/presentation/bloc/attendance_event.dart` — Added `AttendanceResetRequested`
- `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — Added `_onReset` handler
- `lib/features/attendance/data/datasources/attendance_local_datasource.dart` — Added `clear()` method
- `lib/features/kpi/presentation/bloc/kpi_event.dart` — Added `KpiResetRequested`
- `lib/features/kpi/presentation/bloc/kpi_bloc.dart` — Added `_onReset` handler
- `lib/features/kpi/data/datasources/kpi_local_datasource.dart` — Added `clear()` method
- `lib/features/home/presentation/pages/main_shell.dart` — Reset all BLoCs on `AuthAccountDeleted`
- `lib/app.dart` — Refresh attendance on locale change

## April 2, 2026 — Version Renaming for Google Play Console Testing

**Status:** ✅ Complete

**What changed:** Renumbered all versions so that **1.0.0 is the first Play Store (production) release** and all prior internal milestones are 0.x.x. The old versioning (1.0.0–1.3.0) was internal-only; no builds had been submitted to Google Play Console.

**Version mapping:**

| Old | New | Description |
| --- | --- | ----------- |
| 1.3.0+4 | 0.4.0+5 | Google Play internal testing build (versionCode must exceed previously uploaded +4) |
| 1.3.0 | 0.4.0 | Changelog entry |
| 1.2.0 | 0.3.0 | Internal milestone 3 |
| 1.1.0 | 0.2.0 | Internal milestone 2 |
| 1.0.0 | 0.1.0 | Internal milestone 1 |

**Files modified:**

- `pubspec.yaml` — `version: 1.3.0+4` → `version: 1.0.0+1`
- `CHANGELOG.md` — All 4 version headers renamed; accidental user message removed from header; Version History table updated
- `tech_readme_files/CURRENT_STATUS.md` — Header version, CHANGELOG reference, branch status updated
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — This entry added

---

## January 18, 2025 — Google Play Data Safety Questionnaire Plan

**Status:** ✅ Complete

**What changed:** Created comprehensive implementation plan for Google Play Console Data Safety questionnaire submission. Based on full codebase audit, the document provides exact answers for all 5 questionnaire steps, complete data inventory (50+ data points), third-party service disclosures, and compliance verification checklists.

**Files created:**

- `tech_readme_files/GOOGLE_PLAY_DATA_SAFETY_PLAN.md` — 900+ line comprehensive plan with:
  - **Executive Summary**: Current state (existing deletion features, encryption, HTTPS)
  - **Step-by-Step Answers**: Exact selections for Google Play Console (5 steps)
  - **Complete Data Inventory**: Personal info, professional data, media files, attendance/KPI tracking, third-party services
  - **Data Security Practices**: HTTPS/TLS encryption, FlutterSecureStorage (AES-256), token handling
  - **Third-Party Disclosures**: Sentry (error monitoring), Firebase (backend services), Google Sign-In (OAuth)
  - **Account Deletion**: Settings → Account → Delete Account (`DELETE /delete/account`)
  - **Granular Deletion**: Profile images, resumes, videos, skills, experience, education, KPIs
  - **Pre-Submission Checklist**: 50+ verification steps
  - **Post-Launch Maintenance**: Quarterly audits, dependency monitoring, user support templates

**Key findings:**

- ✅ **Account deletion fully implemented** (BLoC, API, UI)
- ✅ **Granular data deletion** for all user-generated content
- ✅ **Encrypted storage** for auth tokens (FlutterSecureStorage + AES-256)
- ✅ **HTTPS/TLS** for all network traffic
- ✅ **Privacy policy linked** in-app (Settings → About)
- ⚠️ **Sentry shares crash/error data** (20% sample in production, no opt-out)
- ⚠️ **Firebase initialized** (actual usage needs verification)
- ⚠️ **User cache unencrypted** in SharedPreferences (email, phone, profile data)

**Decisions documented:**

- Declare **YES** for "Does your app collect user data?" (50+ data points collected)
- Declare **YES** for "Encrypted in transit?" (HTTPS base URL enforced)
- Declare **YES** for "Users can delete data?" (account + individual item deletion)
- Disclose **Sentry** as third-party service (error monitoring, 20% trace sampling)
- Disclose **Google Sign-In** data sharing (email, ID token via OAuth)
- Privacy policy URL: `https://technology92.com/privacy-policy/`
- Data types: Personal info (name, email, phone, DOB, address), financial (salary), professional (experience, education, skills), media (photos, videos, resumes), attendance/KPI tracking, crash/error logs

**Files modified:**

- `CHANGELOG.md` — Added entry for Google Play Data Safety plan creation

---

## March 30, 2026 — Google Sign-In: fix masked error messages and loading state

**Status:** ✅ Complete

**What changed:** Google Sign-In errors were always displayed as "Network Error" because the UI error-handling logic treated all errors without an HTTP status code (including PlatformExceptions from the Google SDK) as network errors. Fixed the BLoC to parse `PlatformException` separately (handling cancellation gracefully and extracting meaningful messages) and updated all three auth pages to show the actual error message.

**Files modified:**

- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — Added `PlatformException` import; split catch block into `on PlatformException` (handles `sign_in_canceled`, extracts `e.message`) and generic `catch` (clean fallback message)
- `lib/features/auth/login/presentation/pages/login_page.dart` — `_localizeError` now shows `state.message` when `statusCode` is null instead of hardcoded "Network Error"; Google button wrapped with `BlocBuilder` to disable during loading
- `lib/features/auth/auth_select/presentation/pages/auth_select_page.dart` — Error handler now shows `state.message` directly instead of mapping to generic strings
- `lib/features/auth/register/presentation/widgets/register_footer.dart` — Google button wrapped with `BlocBuilder` to disable during loading

**Key decisions:**

- BLoC emits `AuthUnauthenticated` (not `AuthError`) for `sign_in_canceled` PlatformException, matching the existing `googleUser == null` cancellation path
- UI shows `state.message` directly for all errors, falling back to localized generic messages only when `message` is empty

---

## March 28, 2026 — Google Sign-In: switch to id_token + correct backend endpoints

**Status:** ✅ Complete

**What changed:** Google Sign-In was sending `email`/`name` to the old `/oauth/exchange` endpoint which timed out. Switched the entire flow to use the new `FlutterGoogleAuthController` backend endpoints (`/auth/google/sign-in` + `/auth/google/sign-up`) that accept a verified Google `id_token`. Added `serverClientId` to `GoogleSignIn` to obtain the ID token from Google's native SDK.

**Files modified:**

- `lib/core/api/api_endpoints.dart` — Added `googleSignIn` and `googleSignUp` endpoint constants
- `lib/features/auth/shared/data/datasources/auth_remote_datasource.dart` — Replaced `googleOAuthExchange(email, name, locale)` with `googleAuthenticate(idToken)`, tries sign-in first then falls back to sign-up on 404
- `lib/features/auth/shared/domain/repositories/auth_repository.dart` — Changed `googleSignIn` contract from `email/name/locale` to `idToken`
- `lib/features/auth/shared/domain/usecases/google_sign_in_usecase.dart` — Changed `GoogleSignInParams` from `email/name/locale` to `idToken`
- `lib/features/auth/shared/data/repositories/auth_repository_impl.dart` — Updated to call `googleAuthenticate(idToken:)`
- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — Added `serverClientId` from `EnvConfig`, gets `idToken` via `googleUser.authentication`, passes to use case
- `test/helpers/mocks.dart` — Added `MockGoogleSignInAuthentication`
- `test/features/auth/presentation/bloc/auth_bloc_test.dart` — Updated Google sign-in test to mock `authentication` and `idToken`
- `test/features/auth/domain/usecases/auth_usecases_test.dart` — Updated `GoogleSignInParams` to use `idToken`
- `test/features/auth/data/repositories/auth_repository_impl_test.dart` — Updated to use `googleAuthenticate`
- `test/core/api/api_endpoints_test.dart` — Added assertions for new endpoints

**Key decisions:**

- Data source tries `/auth/google/sign-in` first (existing user), catches `NotFoundException` (404) and falls back to `/auth/google/sign-up` (new user) — transparent to the caller
- `serverClientId` uses `EnvConfig.googleServerClientId` (compile-time from `.env`), with null fallback when empty
- Requires full rebuild via `scripts/build_debug.ps1` since `--dart-define` values are compile-time

---

## March 28, 2026 — Fix test suite (471 tests passing)

**Status:** ✅ Complete

**What changed:** The test suite had widespread failures after auth feature restructuring (moved under `auth/shared/`) and offline-first architecture additions (new BLoC constructor params). Fixed all compilation errors and assertion mismatches across 12 test files.

**Files modified:**

- `test/helpers/mocks.dart` — Rewrote: consolidated imports at top, updated auth paths, added `MockDeleteAccountUseCase`, `MockConnectivityCubit`, `MockOfflineQueue`
- `test/fixtures/auth_fixtures.dart` — Updated auth import paths
- `test/fixtures/profile_fixtures.dart` — Fixed `yearsOfExperience`/`monthsOfExperience` types (int → String)
- `test/features/auth/presentation/bloc/auth_bloc_test.dart` — Added `deleteAccountUseCase`/`sharedPreferences` params, updated state expectations
- `test/features/auth/domain/entities/user_entity_test.dart` — Fixed import path
- `test/features/auth/domain/usecases/auth_usecases_test.dart` — Fixed 6 usecase import paths
- `test/features/auth/data/repositories/auth_repository_impl_test.dart` — Added `registerFallbackValue`, fixed logout test
- `test/features/auth/data/models/user_model_test.dart` — Fixed import path
- `test/features/profile/data/models/profile_model_test.dart` — Fixed ID expectations (int → String)
- `test/features/profile/domain/usecases/profile_usecases_test.dart` — Fixed failure class named params
- `test/features/profile/data/repositories/profile_repository_impl_test.dart` — Added model import
- `test/features/profile/presentation/bloc/profile_bloc_test.dart` — Added connectivity/offline mocks, removed `ProfileLoading` from CRUD expectations, added `ConnectivityStatus` state stub
- `test/features/attendance/presentation/bloc/attendance_bloc_test.dart` — Added connectivity/offline mocks, timer stubs, cache fallback
- `test/features/kpi/presentation/bloc/kpi_bloc_test.dart` — Added connectivity/offline mocks, cache fallback
- `test/features/settings/presentation/cubit/settings_cubit_test.dart` — Converted constructor emission tests to plain `test`

**Key decisions:**

- Profile CRUD tests updated to match new `_refreshAfterMutation` pattern (no intermediate `ProfileLoading` state)
- `MockConnectivityCubit` extends `MockCubit<ConnectivityStatus>` for proper cubit mocking
- Settings cubit initial-load tests use plain `test` since synchronous constructor emissions aren't captured by `blocTest`

---

## March 28, 2026 — Fix Google Sign-In and new-user navigation

**Status:** ✅ Complete

**What changed:** Google Sign-In was failing with `ApiException: 10` (DEVELOPER_ERROR) due to a `serverClientId` mismatch between `.env` and `google-services.json`. Also, new users signing in via Google from the login screen were skipping the essential data wizard and review page.

**Files modified:**

- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — (1) Pass `null` instead of empty string for `serverClientId` so the plugin falls back to `google-services.json`. (2) Set `isFirstTimeEssentialData: true` for new Google users and clear stale `essentialDataComplete` flag, mirroring the registration flow.
- `.env` — Updated `GOOGLE_SERVER_CLIENT_ID` to the web client ID (client_type: 3) from the Firebase project in `google-services.json`.

**Key decisions:**

- New Google users are detected locally by the absence of the `essentialDataComplete` flag — the backend `oauthExchange` endpoint uses `firstOrCreate` and does not return an `is_new` flag.
- The essential data flow for Google sign-in now matches registration: wizard → review → home.

---

## March 27, 2026 — Fix KPI localization (bottom sheet + entry cards)

**Status:** ✅ Complete

**What changed:** The KPI add-entry bottom sheet and some entry cards displayed English names ("dial speed", "Inbound Calls", etc.) even when the app language was Arabic. Two issues: (1) the bottom sheet dropdown used raw backend `name` field without localization; (2) the `dial_speed` key was missing from the entry card's localization map.

**Files modified:**

- `lib/features/kpi/presentation/widgets/add_kpi_entry_sheet.dart` — Added `_localizedDefName()` static helper that maps definition keys to `context.l10n` strings; used in dropdown items
- `lib/features/kpi/presentation/widgets/kpi_entry_card.dart` — Added `'dial_speed' => l10n.kpiDialSpeed` to `_localizedName()` switch map
- `lib/l10n/arb/app_en.arb` — Added `kpiDialSpeed: "Dial Speed"`
- `lib/l10n/arb/app_ar.arb` — Added `kpiDialSpeed: "سرعة الاتصال"`
- `lib/l10n/generated/app_localizations*.dart` — Regenerated via `flutter gen-l10n`

**Key decisions:**

- KPI definition names are localized client-side by mapping the backend `key` field to l10n strings. This ensures instant locale switching without needing to re-fetch definitions from the API.
- Unknown/future KPI keys fall back to the backend `name` field as a reasonable default.

---

## March 27, 2026 — Fix profile image not showing on Home/Settings

**Status:** ✅ Complete

**What changed:** The uploaded profile image appeared on the Profile page but showed a plain initial-letter circle on Home and Settings. Root cause: both screens used `NetworkImage()` which silently fails on local file paths from pending S3 uploads. Added `FileImage` fallback for local paths, matching the existing `ProfileHeader` logic.

**Files modified:**

- `lib/features/home/presentation/widgets/home_greeting_header.dart` — Added `dart:io` import and `FileImage(File(...))` branch for local-path avatar URLs
- `lib/features/settings/presentation/widgets/sections/settings_user_card.dart` — Same fix

---

## March 27, 2026 — Profile resume/video offline support

**Status:** ✅ Complete

**What changed:** Resume and video features now work fully offline with caching and graceful degradation. PDF viewer checks connectivity before downloading and serves cached files. Video player shows a clear offline message. Resume/video deletes are queued via OfflineQueue when offline with optimistic UI. Uploads show a user-friendly "requires internet" error. EditVideoSection switched from url_launcher to in-app VideoPlayerPage.

**Files modified:**

- `lib/shared/widgets/pdf_viewer/pdf_viewer_page.dart` — Added connectivity check before download; shows wifi-off icon and "file not available offline" when PDF not cached
- `lib/shared/widgets/video_player/video_player_page.dart` — Added connectivity check before streaming; shows offline message with wifi-off icon
- `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — Resume/video upload handlers guard on connectivity; delete handlers queue via OfflineQueue when offline with optimistic UI
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_video_section.dart` — Replaced url_launcher with in-app VideoPlayerPage via GoRouter
- `lib/core/network/offline_queue.dart` — Added `profileDeleteResume` and `profileDeleteVideo` action types
- `lib/injection_container.dart` — Registered OfflineQueueProcessor handlers for resume/video deletes
- `lib/l10n/arb/app_en.arb` + `app_ar.arb` — Added 4 l10n keys: uploadRequiresInternet, deleteQueuedOffline, fileNotAvailableOffline, videoRequiresInternet

**Key decisions:**

- File uploads (resume/video) cannot be queued offline because OfflineQueue stores JSON payloads in SharedPreferences — local file paths may be cleaned by the OS. Instead, uploads show a clear error message.
- Deletes only need a `type` string, so they can be safely queued and replayed on reconnect.
- PdfViewerPage already caches downloaded PDFs in the temp directory, so previously-viewed files work offline automatically.
- Videos stream from network and are too large to cache locally; graceful offline messaging is the right approach.

---

## March 27, 2026 — Fix false offline banner (ConnectivityService)

**Status:** ✅ Complete

**What changed:** The "No internet connection" banner appeared on devices with working internet because `InternetConnectionChecker` v3's default check addresses (`dummyapi.online`, `jsonplaceholder.typicode.com`, `fakestoreapi.com`) are unreliable free APIs that often fail. Replaced them with highly-available captive-portal endpoints. Also fixed a race condition where `init()` did not await the initial connectivity check.

**Files modified:**

- `lib/core/network/connectivity_service.dart` — Replaced default `InternetConnectionChecker.instance` with `createInstance()` using Google generate_204, Apple captive portal, and Cloudflare endpoints. Changed `init()` from `void` to `Future<void>` and awaited the initial `isOnline` check.
- `lib/injection_container.dart` — Added `await` to `connectivityService.init()` call.

**Key decisions:**

- Used HTTPS captive-portal endpoints (Google, Apple, Cloudflare) because they are designed for connectivity checks, respond fast, and have near-100% uptime
- Awaiting `init()` ensures `lastKnownStatus` is accurate before `ConnectivityCubit` reads it, eliminating the race condition

## March 26, 2026 — v1.3.0 Release Documentation

**Status:** ✅ Complete

**What changed:**

1. **CHANGELOG.md consolidated** — Merged the fragmented `[Unreleased]` section (4 duplicate `### Added`, 4 `### Changed`, 3 `### Fixed` headers + orphaned items) into a single clean `[1.3.0] - 2026-03-26` release section organized by feature area (Auth & Onboarding, Profile, Home, Shared & Core, Testing). Added empty `[Unreleased]` placeholder. Updated Version History table and Planned section.
2. **In-app changelog expanded** — `app_changelog_data.dart` v1.3.0 entry rewritten to cover all user-visible changes: Get Started screen, post-registration wizard, review screen, profile UX overhaul (grouped sections, collapsible portfolio, quick-action chips, detail dialogs), AppToast banner, delete account, locale validation, nationality flags, and bug fixes. Previously only covered the profile UX subset.
3. **CURRENT_STATUS.md cleaned up** — Removed duplicate metric rows (7 duplicated lines), updated Git & Branch Status (master now at v1.3.0 with full PR history), updated Planned Features (removed completed items: Attendance, Essential Info, offline support), updated CHANGELOG reference to `v1.0.0 → v1.3.0`.

**Files modified:**

- `CHANGELOG.md`
- `lib/features/settings/presentation/widgets/dialogs/app_changelog_data.dart`
- `tech_readme_files/CURRENT_STATUS.md`
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md`

**Key decisions:**

- v1.3.0 CHANGELOG organized by feature area (#### sub-headers) within each `### Added`/`### Changed`/`### Fixed` section, matching the level of detail in v1.2.0 and v1.1.0 but with better grouping for the larger change set.
- In-app changelog kept user-friendly (plain language, no technical jargon) while covering significantly more changes than the previous version.

---

## March 26, 2026 — Settings Changelog Localization

**Status:** ✅ Complete

**What changed:**

1. **`app_changelog_data.dart` refactored** — Introduced `Bi` (bilingual string) helper class storing EN + AR text. `VersionEntry.date` and `ChangeGroup.items` are now `Bi` instances resolved to the active locale at render time.
2. **`ChangeGroup.titleOf`** — Group titles (`New`, `Better`, `Fixed`, `Simplified`, `Welcome!`) replaced with `String Function(AppLocalizations l10n)` builder resolved via `group.titleOf(context.l10n)`. Five new ARB keys added (`changelogGroupNew`, `changelogGroupBetter`, `changelogGroupFixed`, `changelogGroupSimplified`, `changelogGroupWelcome`).
3. **`AppInfoDialog` updated** — `_VersionHeader` resolves `entry.date.resolve(locale)`. `_ChangeGroupWidget` calls `group.titleOf(context.l10n)` and `item.resolve(locale)` for each bullet.
4. **v1.3.0 changelog entry added** — Covers profile UX refactor (grouped sections, collapsible portfolio, quick-action chips, empty states), AppToast banner, validation/server error localization, and phone RTL fix.

**Files modified:**

- `lib/features/settings/presentation/widgets/dialogs/app_changelog_data.dart`
- `lib/features/settings/presentation/widgets/dialogs/app_info_dialog.dart`
- `lib/l10n/arb/app_en.arb`, `lib/l10n/arb/app_ar.arb`
- `lib/l10n/generated/` (regenerated)

---

## March 24, 2026 — AppPhoneField: Countries & Selector Refactor

**Status:** ✅ Complete

**What changed:** Narrowed `kSupportedCountries` in `AppPhoneField` from 7 countries to 2 (SA + JO only), aligning with the backend `PhoneHelper::isValid()` validation. Switched the country selector from `modalBottomSheet` to a compact `dialog` (220×320 px) since only 2 items are listed.

**Files modified:**

- `lib/shared/widgets/inputs/app_phone_field.dart` — Removed YE, EG, SY, US, GB from `kSupportedCountries`; switched `CountrySelectorNavigator` from `modalBottomSheet` to `dialog` with fixed dimensions

**Key decisions:**

- Backend only validates SA (+966) and JO (+962) — offering other countries produced silent 422 errors at the API level
- A dialog fits 2 items better than a full bottom sheet; `searchAutofocus: false` since there's nothing to search

---

## March 24, 2026 — Offline-First Architecture

**Status:** ✅ Complete

**What changed:**

Complete offline-first infrastructure enabling the app to work fully offline. Implemented 5 phases: connectivity monitoring, cache freshness/TTL, auto-sync on reconnect, offline mutation queue, and retry interceptor.

**Files created:**

- `lib/core/network/connectivity_service.dart` — Wraps connectivity_plus + internet_connection_checker for actual internet verification
- `lib/core/network/connectivity_cubit.dart` — Global Cubit emitting ConnectivityStatus (online/offline/unknown)
- `lib/core/network/connectivity_state.dart` — ConnectivityStatus enum
- `lib/core/network/offline_queue.dart` — Persistent FIFO queue for offline mutations (SharedPreferences-backed)
- `lib/core/network/offline_queue_processor.dart` — Processes queued mutations on reconnect with retry logic
- `lib/core/network/cache_policy.dart` — Cache freshness helper (fresh/stale/expired tiers)
- `lib/core/api/retry_interceptor.dart` — Dio retry interceptor for transient GET failures
- `lib/shared/widgets/banners/connectivity_banner.dart` — Animated global offline banner

**Files modified:**

- `lib/injection_container.dart` — Registered ConnectivityService, ConnectivityCubit, OfflineQueue, OfflineQueueProcessor with handlers
- `lib/app.dart` — Added ConnectivityCubit BlocProvider
- `lib/core/api/api_client.dart` — Added RetryInterceptor to Dio chain
- `lib/core/constants/app_constants.dart` — Added cache TTL constants (5 min fresh, 24h expired)
- `lib/features/home/presentation/pages/main_shell.dart` — Added ConnectivityBanner, auto-sync BlocListener, connection restored toast
- `lib/features/attendance/data/datasources/attendance_local_datasource.dart` — Added cachedAt to AttendanceCacheSnapshot
- `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — Added cache TTL logic, offline queue for check-in/out
- `lib/features/kpi/data/datasources/kpi_local_datasource.dart` — Added cachedAt to KpiCacheSnapshot
- `lib/features/kpi/presentation/bloc/kpi_bloc.dart` — Added cache TTL logic, offline queue for upsert/delete
- `lib/features/profile/shared/data/datasources/profile_local_datasource.dart` — Added cachedAt to ProfileCacheSnapshot
- `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — Added cache TTL logic
- `lib/l10n/arb/app_en.arb` — Added 8 offline-related l10n keys
- `lib/l10n/arb/app_ar.arb` — Added 8 offline-related l10n keys (Arabic translations)

**Key decisions:**

- Used SharedPreferences (not a database) for offline queue — keeps it simple, consistent with existing cache pattern
- Cache TTL: 5 min fresh (skip API), 5 min–24h stale (show cache + background refresh), >24h expired (must fetch)
- Only GET requests are retried by RetryInterceptor; mutations go through the offline queue
- Server-wins conflict resolution (last-write-wins) — appropriate for this single-user mobile app
- Queue processor processes items sequentially (FIFO) with max 3 retries before discarding

---

## March 25, 2026 — Profile Detail Dialogs & Edit Profile Collapsible Sections

**Status:** ✅ Complete

**What changed:**

1. **Edit Personal & Professional tabs** — Replaced single `ProfileSectionCard(EditPersonalForm/EditProfessionalForm(...))` wrappers with multiple `CollapsibleProfileSection` widgets per tab (5 sections for Personal, 4 for Professional) matching the Portfolio tab pattern. Each tab now has a sticky save button always visible at the bottom.
2. **Experience & Education add/edit forms** — Converted from `AppBottomSheet` modal bottom sheets to full-screen pages (`MaterialPageRoute(fullscreenDialog: true)`) with `Scaffold`, `CustomAppBar` (×-close button), collapsible form sections, and sticky `AppButton` at bottom. Experience form: 4 sections (Position, Company, Time Period, Description). Education form: 3 sections (Institution, Time Period, Description).
3. **Profile view — tappable experience/education items** — Wrapped each `_ExperienceItem` and `_EducationItem` in `InkWell`. Tapping opens a styled `showDialog` detail view showing all recorded information. Items with edit/delete buttons show those icons; items without (read-only mode) show a chevron `›`.
4. **Detail dialog UI improvements** — Experience dialog: primary-colored header band, 48×48 icon, job type badge (tertiary) + duration badge (secondary + clock icon), card-style `_DetailRow` rows, description section. Education dialog: secondary-colored header band, "Still Studying" badge (primary + bookmark icon) + duration badge, same detail row pattern.
5. **Added `timePeriod` localization key** — EN: "Time Period", AR: "الفترة الزمنية". Ran `flutter gen-l10n`.

**New files created:** None

**Files modified:**

- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_tab.dart` — Collapsible sections + sticky save
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_professional_tab.dart` — Collapsible sections + sticky save
- `lib/features/profile/edit_profile/presentation/widgets/dialogs/experience_form_dialog.dart` — Full-screen page with collapsible sections
- `lib/features/profile/edit_profile/presentation/widgets/dialogs/education_form_dialog.dart` — Full-screen page with collapsible sections
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_experience_card.dart` — Tappable items, `_ExperienceDetailDialog`, `_Badge`, `_DetailRow`
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_education_card.dart` — Tappable items, `_EducationDetailDialog`, `_Badge`, `_DetailRow`
- `lib/l10n/arb/app_en.arb` — Added `timePeriod`
- `lib/l10n/arb/app_ar.arb` — Added `timePeriod`

**Key decisions:**

- Detail views use `showDialog` (centered `Dialog` with `clipBehavior: Clip.antiAlias`) rather than bottom sheets for better visual hierarchy on both short and tall screens.
- Duration is computed client-side from `startDate`/`endDate` (or `DateTime.now()` if still working/studying) — no backend field needed.
- Country name excluded from experience detail dialog since `ExperienceEntity` only carries `countryId`, not the resolved name.

---

## March 25, 2026 — Profile & Edit Profile UX Overhaul

**Status:** ✅ Complete

**What changed:**

1. Profile view: grouped personal/professional card rows into labeled sub-sections using new `ProfileSubSectionLabel`. Added actionable advice tiles to completeness card. Replaced empty states in 5 section cards with `ProfileEmptyState` (icon + CTA). Added quick-action chips below header. Removed edit button from header, added specialty display.
2. Edit profile: grouped form fields into labeled sections using new `FormSectionHeader`. Added `isRequired` asterisk to input widgets. Sticky save button on Personal/Professional tabs. Renamed "More" → "Portfolio" with collapsible sections (`CollapsibleProfileSection`). Deep-link navigation via GoRouter `extra` to open specific tab.
3. Added ~30 new localization keys (EN + AR) for section headers, empty states, and tips.

**New files created:**

- `lib/features/profile/shared/presentation/widgets/common/profile_sub_section_label.dart`
- `lib/features/profile/shared/presentation/widgets/common/form_section_header.dart`
- `lib/features/profile/shared/presentation/widgets/common/profile_empty_state.dart`
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/collapsible_profile_section.dart`

**Files modified:**

- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — Quick-action chips, empty state callbacks, advice pass-through
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_personal_card.dart` — Sub-section grouping
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_professional_card.dart` — Sub-section grouping
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_completeness_card.dart` — Advice tiles
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_skills_card.dart` — ProfileEmptyState
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_experience_card.dart` — ProfileEmptyState
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_education_card.dart` — ProfileEmptyState
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_resume_card.dart` — ProfileEmptyState
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_video_card.dart` — ProfileEmptyState
- `lib/features/profile/shared/presentation/widgets/common/profile_header.dart` — Removed edit button, added specialty
- `lib/features/profile/shared/presentation/widgets/common/profile_section_card.dart` — Added subtitle param
- `lib/features/profile/edit_profile/presentation/pages/edit_profile_page.dart` — initialTabIndex param, Portfolio tab label
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_form.dart` — FormSectionHeader grouping
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_professional_form.dart` — FormSectionHeader grouping
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_tab.dart` — Sticky save button
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_professional_tab.dart` — Sticky save button
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_more_tab.dart` — CollapsibleProfileSection wrappers
- `lib/config/routes/app_router.dart` — Extract initialTabIndex from extra
- `lib/shared/widgets/inputs/app_text_field.dart` — isRequired asterisk
- `lib/shared/widgets/inputs/app_dropdown_field.dart` — isRequired asterisk
- `lib/shared/widgets/inputs/app_searchable_dropdown_field.dart` — isRequired asterisk
- `lib/l10n/arb/app_en.arb` / `lib/l10n/arb/app_ar.arb` — ~30 new keys

---

## March 23, 2026 — Specialty Row + Pending Translation Chip UI

**Status:** ✅ Complete

**What changed:**

1. Added a dedicated "Specialty" row to the personal details card in profile view and a specialty text field to the edit personal form. Previously specialty was merged with `industryName` in the professional card — now they are separate fields (specialty in personal, industry in professional).
2. Replaced the blanket "Pending translation..." text that appeared on ALL empty fields with a styled inline chip (`_PendingTranslationChip`) that only shows on translation-dependent fields (specialty). Unfilled fields correctly show "-".
3. Added `enterSpecialty` l10n key to both EN and AR ARB files.

**Files modified:**

- `lib/features/profile/profile_view/presentation/widgets/profile/profile_personal_card.dart` — Added specialty row with `isPendingTranslation` support
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_professional_card.dart` — Removed specialty fallback, changed to show `industryName` as "Industry"
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — Passes `isTranslationPending` to personal card, removed `specialty` from professional card
- `lib/features/profile/shared/presentation/widgets/common/profile_info_row.dart` — Added `isPendingTranslation` flag + `_PendingTranslationChip` styled widget
- `lib/features/profile/edit_profile/presentation/helpers/edit_profile_form_data.dart` — Added `specialtyCtrl`, populate, and build data
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_form.dart` — Added specialty text field
- `lib/l10n/arb/app_en.arb` / `lib/l10n/arb/app_ar.arb` — Added `enterSpecialty` key

---

## March 23, 2026 — Nationality Searchable Dropdown with Flags + Dark Mode Theming

## March 21, 2026 — Testing Documentation

## March 21, 2026 — Router Error Page Design Tokens & Localization

**Status:** ✅ Complete

**What changed:**

Three improvements: (1) Replaced `AppDropdownField` with `AppSearchableDropdownField` in the nationality step — the searchable bottom sheet scales better for the full list of nationalities and now shows flag emojis derived from the ISO alpha-2 `code` field. (2) Enhanced `AppSearchableDropdownField` with `itemLeadingBuilder` (renders a leading widget per item), `validator` (form integration via `FormField`), and `prefixIconConstraints`. (3) All step widgets and essential info page now use `Theme.of(context).colorScheme` / `textTheme` instead of hardcoded `AppColors` light-mode-only tokens.

**Files created:**

- `lib/core/utils/country_flag.dart` — `countryCodeToFlag()` converts ISO alpha-2 codes to flag emojis

**Files modified:**

- `lib/shared/widgets/inputs/app_searchable_dropdown_field.dart` — Added `itemLeadingBuilder`, `validator`, `FormField` wrapping
- `lib/features/auth/essential_data/presentation/widgets/age_nationality_step.dart` — Switched to `AppSearchableDropdownField` with flag builder
- `lib/features/auth/essential_data/presentation/widgets/name_step.dart` — Theme-aware colors
- `lib/features/auth/essential_data/presentation/widgets/specialty_phone_step.dart` — Theme-aware colors
- `lib/features/auth/essential_data/presentation/widgets/resume_step.dart` — Theme-aware colors via `colorScheme`
- `lib/features/auth/essential_info/presentation/pages/essential_info_page.dart` — Dark-mode success icon, theme-aware text
- `lib/features/auth/essential_info/presentation/widgets/essential_info_field_row.dart` — Theme-aware colors
- `CHANGELOG.md` — Added entries

**Key decisions:**

- Used `itemLeadingBuilder` callback rather than a hardcoded `codeKey` to keep the widget generic and reusable for non-flag use cases.
- Flag emojis use Unicode Regional Indicator Symbols — zero runtime dependencies, works cross-platform.
- Existing `AppSearchableDropdownField` usages in profile forms are unaffected (all new params are optional).

---

## March 23, 2026 — Essential Data & Essential Info UI/UX Refactor + Skeletons

Created comprehensive testing guide documentation and updated existing docs to reflect the complete test suite (29 files, ~365 test cases).

**Files created (1):**

- `tech_readme_files/10_testing.md` — Full testing guide: overview, running tests, directory structure, coverage by layer (BLoC/Cubit, repository, model, use case, entity, core), test infrastructure (37 mocks, 4 fixture files), patterns for writing new tests (BLoC, repository, model), coverage summary table, remaining coverage areas, best practices

**Files modified (3):**

- `tech_readme_files/01_folder_structure.md` — Added full `test/` directory tree with descriptions for all 29 test files, helpers, and fixtures
- `tech_readme_files/CURRENT_STATUS.md` — Updated: last updated date, added unit test suite highlight, added test metrics (files, cases, mocks) to codebase statistics, added Testing section with suite summary table and infrastructure details, added 10_testing.md to documentation table, updated planned features section
- `CHANGELOG.md` — Added testing documentation entry under [Unreleased] Added

---

## March 21, 2026 — Unit Test Suite (Phase 4)

**Status:** ✅ Complete

**What changed:**

Refactored both essential_data wizard and essential_info review screens to match the UI/UX patterns used across the rest of the app. Replaced auth-specific scaffolding with standard `Scaffold` + `CustomAppBar`, wrapped step content in `AppCard`, added skeleton loading states (using `skeletonizer` package), upgraded the wizard step indicator to a segmented bar, and replaced the inline translation banner with the shared `TranslationPendingBanner` widget.

**Files created:**

- `lib/features/auth/essential_data/presentation/widgets/essential_data_wizard_skeleton.dart` — Skeleton placeholder mirroring wizard layout (step indicator + card with fields + nav buttons)
- `lib/features/auth/essential_info/presentation/widgets/essential_info_skeleton.dart` — Skeleton placeholder mirroring review page layout (icon + title + banner + data card + button)

**Files modified:**

- `lib/features/auth/essential_data/presentation/pages/essential_data_wizard_page.dart` — `AuthScaffoldWithPattern` → `Scaffold` + `CustomAppBar`; loading → skeleton
- `lib/features/auth/essential_data/presentation/widgets/name_step.dart` — Wrapped in `AppCard`, use `AppColors` tokens
- `lib/features/auth/essential_data/presentation/widgets/age_nationality_step.dart` — Wrapped in `AppCard`, use `AppColors` tokens
- `lib/features/auth/essential_data/presentation/widgets/specialty_phone_step.dart` — Wrapped in `AppCard`, use `AppColors` tokens
- `lib/features/auth/essential_data/presentation/widgets/resume_step.dart` — Wrapped in `AppCard`, use `AppColors` tokens and `AppRadius`
- `lib/features/auth/essential_data/presentation/widgets/wizard_step_indicator.dart` — Segmented progress bar instead of `LinearProgressIndicator`
- `lib/features/auth/essential_info/presentation/pages/essential_info_page.dart` — `CustomAppBar` + `AppCard` + `TranslationPendingBanner` + skeleton
- `lib/l10n/arb/app_en.arb` — Added `essentialDataWizardTitle` key
- `lib/l10n/arb/app_ar.arb` — Added `essentialDataWizardTitle` key
- `CHANGELOG.md` — Added entries

**Key decisions:**

- Used `CustomAppBar` with `showBackButton: false` since these are post-registration flow screens (no back navigation).
- Step widgets each wrap their own content in `AppCard`, keeping each step self-contained and visually consistent.
- Skeletons mirror the real layout structure for smooth loading transitions.

---

## March 23, 2026 — Edit Profile Locale Validation + Banner Theming

Implemented the fourth phase of the unit test suite: 6 test files with ~75 test cases covering ApiResponse/PaginationMeta, ProfileEntity and all sub-entities, Profile use cases (5 use cases), ApiEndpoints (static and dynamic paths), Exceptions (all 6 types), and StorageKeys (prefix/uniqueness). Note: Jobs feature tests were skipped as the feature has not been implemented yet.

**Files created (6):**

- `test/core/api/api_response_test.dart` — 18 test cases (ApiResponse fromJson with/without transformer, missing keys, pagination parsing, hasPagination, hasData, Equatable; PaginationMeta fromJson, defaults, navigation helpers, toJson, round-trip, Equatable)
- `test/core/api/api_endpoints_test.dart` — 10 test cases (static auth/profile/attendance/kpi paths + dynamic path builders for deleteImage, deleteResume, deleteVideo, skill, experience, education, kpiEntry, adminApplicant)
- `test/core/error/exceptions_test.dart` — 15 test cases (ServerException, NetworkException, CacheException, AuthException, ValidationException, NotFoundException — toString, default values, custom values)
- `test/core/constants/storage_keys_test.dart` — 4 test cases (tech92_ prefix consistency, uniqueness, specific key values, pending image keys)
- `test/features/profile/domain/entities/profile_entity_test.dart` — 20 test cases (ProfileEntity fullName for all name combinations + Equatable, ProfessionalDetailsEntity, ExperienceEntity, EducationEntity, SkillEntity, ProfileImagesEntity, ProfileSummaryEntity, ResumeEntity, VideoEntity)
- `test/features/profile/domain/usecases/profile_usecases_test.dart` — 12 test cases (5 use cases: GetPersonalDetails, GetProfessionalDetails, GetProfileCompleteness, UpdatePersonalDetails, UpdateProfessionalDetails + Params equality)

**Files modified:**

- `test/helpers/mocks.dart` — Added MockGetProfileCompletenessUseCase (37 mock classes total)
- `CHANGELOG.md` — Added Phase 4 entry under [Unreleased]
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — This entry
- `tech_readme_files/CURRENT_STATUS.md` — Updated Testing progress from 75% to 90%

---

## March 21, 2026 — Unit Test Suite (Phase 3)

**Status:** ✅ Complete

**What changed:**

Two improvements: (1) Added locale-character validation to the edit profile form's name fields (first, middle, last), matching the registration form. This prevents Arabic names from being saved with `lang: en` header, which was permanently corrupting the English `applicant_translations` row. (2) Improved the `TranslationPendingBanner` widget to use alpha-based colors (`info.withValues(alpha: 0.10)` bg, `alpha: 0.30` border) following the `OfflineBanner` pattern, so it renders correctly in both light and dark themes.

**Files modified:**

- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_form.dart` — Added `Validators.name()` + `Validators.localeChars()` to first/middle/last name fields
- `lib/shared/widgets/banners/translation_pending_banner.dart` — Replaced hardcoded `AppColors.infoLight` with alpha-based accent colors + border
- `CHANGELOG.md` — Added entries

**Key decisions:**

- First/last name use both `Validators.name()` (required + max 100) and `Validators.localeChars()` (locale match). Middle name uses only `localeChars()` (optional field).
- Banner uses same alpha pattern as `OfflineBanner` for visual consistency across the app.

---

## March 22, 2026 — Translation Pending Hint Banner

**Status:** ✅ Complete

**What changed:**

Added an info banner on the profile page that appears when the user's name or specialty contains characters from a different locale than the app's current language. This detects when the backend's async AI translation hasn't completed yet (e.g. Arabic name displayed in English mode) and explains to the user that fields are still being translated.

**Files created:**

- `lib/shared/widgets/banners/translation_pending_banner.dart` — Reusable info banner widget (icon + message, `AppColors.info` styling)

**Files modified:**

- `lib/core/utils/validators.dart` — Added `Validators.isLocaleMismatch()` public helper (reuses existing `_latinRegex` / `_arabicRegex`)
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — Added `_hasLocaleMismatch()` check + `TranslationPendingBanner` display
- `lib/l10n/arb/app_en.arb` — Added `profileTranslationPending` key
- `lib/l10n/arb/app_ar.arb` — Added Arabic equivalent
- `CHANGELOG.md` — Added entry

**Key decisions:**

- Character-based detection (Arabic chars in English mode) rather than API status field — the GET endpoint doesn't expose `translation_status`, and character detection is reliable without backend changes.
- Banner placed on profile page only (not home/settings) to avoid UI clutter.
- Widget placed in `shared/widgets/banners/` alongside `OfflineBanner` for consistency.

---

## March 22, 2026 — Profile Specialty Display + Locale Refresh Fix

Implemented the third phase of the unit test suite: 7 test files with ~120 test cases covering ProfileBloc, ProfileRepositoryImpl, ProfileModel serialization (9 model types), Attendance entity tests, KPI entity tests, Attendance use cases, and KPI use cases. Expanded test infrastructure to 36 mock classes with a new profile fixture file.

**Files created (8):**

- `test/features/profile/presentation/bloc/profile_bloc_test.dart` — 25 test cases (load success/failure/partial, refresh, personal/professional update, experience/education/skill CRUD, bulk skill add, image upload, resume/video CRUD, summary update, reset)
- `test/features/profile/data/repositories/profile_repository_impl_test.dart` — 16 test cases (exception-to-failure mapping for getPersonalDetails, getProfessionalDetails, updatePersonalDetails, addExperience, deleteExperience, getSkills, addSkill, uploadImage, deleteProfileImage, getProfileSummary, uploadResume, deleteResume)
- `test/features/profile/data/models/profile_model_test.dart` — 22 test cases (ProfileModel, ExperienceModel, EducationModel, SkillModel, ProfileSummaryModel, ProfileImagesModel, ResumeModel, VideoModel — fromJson/toJson/round-trip)
- `test/features/attendance/domain/entities/attendance_entity_test.dart` — 12 test cases (StatusEntity, CurrentEntity, ScheduleEntity Equatable; FilterEntity hasActiveFilters, copyWith, clear flags)
- `test/features/kpi/domain/entities/kpi_entity_test.dart` — 14 test cases (DefinitionEntity, EntryEntity.displayValue, NoteEntity, FilterEntity hasActiveFilters, copyWith, clear flags)
- `test/features/attendance/domain/usecases/attendance_usecases_test.dart` — 12 test cases (6 use cases: GetStatuses, GetCurrent, CheckIn, CheckOut, UpdateStatus, GetSchedule + Params equality)
- `test/features/kpi/domain/usecases/kpi_usecases_test.dart` — 11 test cases (4 use cases: GetDefinitions, GetEntries, UpsertEntry, DeleteEntry + Params equality)
- `test/fixtures/profile_fixtures.dart` — Sample entities, models, and JSON for profile tests

**Files modified:**

- `test/helpers/mocks.dart` — Added 7 mock classes for Profile feature (MockProfileRepository, MockGetPersonalDetailsUseCase, MockGetProfessionalDetailsUseCase, MockUpdatePersonalDetailsUseCase, MockUpdateProfessionalDetailsUseCase, MockProfileRemoteDataSource, MockProfileLocalDataSource)
- `CHANGELOG.md` — Added Phase 3 entry under [Unreleased]
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — This entry
- `tech_readme_files/CURRENT_STATUS.md` — Updated Testing progress from 55% to 75%

---

## March 21, 2026 — Unit Test Suite (Phase 2)

**Status:** ✅ Complete

**What changed:**

Two profile feature fixes: (1) Specialty from essential data (`applicant_translations`) is now displayed on the profile page in the Professional Details card as a fallback for `industryName`. The profile remote datasource now fetches `/applicant/essential/info` alongside the existing two personal details endpoints. (2) Fixed a race condition where changing language while the profile was still loading caused the refresh to be silently skipped — the in-flight requests kept the old locale headers and the profile showed names in the wrong language. Added a `_pendingLocaleRefresh` mechanism so the bloc re-fetches after the current load completes, and updated `app.dart` to fire refresh even when profile is in `ProfileLoading` state.

**Files modified:**

- `lib/features/profile/shared/domain/entities/profile_entity.dart` — Added `specialty` field
- `lib/features/profile/shared/data/models/profile_model.dart` — Added `specialty` to fromJson/toJson
- `lib/features/profile/shared/data/datasources/profile_remote_datasource.dart` — `getPersonalDetails()` now fetches essential info endpoint in parallel, merges specialty
- `lib/features/profile/profile_view/presentation/widgets/profile/profile_professional_card.dart` — Added `specialty` param, used as fallback for `industryName`
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — Passes `profile.specialty` to `ProfileProfessionalCard`
- `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — Added `_pendingLocaleRefresh` flag and `_drainPendingRefresh()` helper
- `lib/app.dart` — BlocListener now handles `ProfileLoading` state for locale changes
- `CHANGELOG.md` — Added entries

**Key decisions:**

- Fetching essential info inline in `getPersonalDetails()` (3rd parallel call) rather than adding a separate use case — keeps the change minimal and avoids new DI wiring.
- Specialty shown as fallback for `industryName` (not a separate row) since they represent the same concept from different sources.
- Used `_pendingLocaleRefresh` flag + `_drainPendingRefresh()` instead of a more complex event queue — simple and covers the race condition.

---

## March 22, 2026 — Profile BLoC: Eliminate Duplicate API Calls

**Status:** ✅ Complete

**What changed:**

Fixed excessive duplicate API calls in the profile feature. Two issues were addressed: (1) `_onRefresh` handler lacked the `_isLoading` guard that `_onLoad` had, allowing concurrent full-profile fetches when locale change and MainShell init fired together. (2) All 15 CRUD handlers called `add(ProfileLoadRequested())` after mutations, triggering a full 11-endpoint reload for every single edit. Replaced with a new `_refreshAfterMutation()` helper that only fetches the changed section + summary/completeness (2 API calls instead of 11).

**Files modified:**

- `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — Added `_isLoading` guard to `_onRefresh`, added `_refreshAfterMutation()` helper, replaced all `add(ProfileLoadRequested())` in CRUD handlers with targeted section refresh.
- `CHANGELOG.md` — Added entry for this optimization.

**Key decisions:**

- Used section-based flags (`personal`, `experiences`, `skills`, etc.) rather than an enum to keep the API simple and avoid a new type.
- Always refetch summary/completeness after any mutation since any profile change can affect the percentage.
- Fall back to full `_fetchProfileData` if no cached state exists (first-load edge case).

---

## March 22, 2026 — Applicant Translations Support + Locale Fixes

Implemented the second phase of the unit test suite: 7 test files with ~95 test cases covering AttendanceBloc, KpiBloc, AttendanceRepositoryImpl, KpiRepositoryImpl, AttendanceModel serialization, KpiModel serialization, and Auth use cases. Expanded shared test infrastructure with 16 new mock classes and 2 new fixture files.

**Files created (9):**

- `test/features/attendance/presentation/bloc/attendance_bloc_test.dart` — 16 test cases (load success/failure/cached+offline, check-in success/failure, check-out success/failure, status update, refresh current, schedule refresh, completer completion on success/error)
- `test/features/kpi/presentation/bloc/kpi_bloc_test.dart` — 18 test cases (load success/failure/pagination, upsert insert/update/failure, delete success/failure, refresh entries, filter by definitionId/sort, completer)
- `test/features/attendance/data/repositories/attendance_repository_impl_test.dart` — 14 test cases (getStatuses, getCurrent, checkIn, updateStatus, checkOut, getSchedule — each with success + exception mapping)
- `test/features/kpi/data/repositories/kpi_repository_impl_test.dart` — 14 test cases (getDefinitions, getEntries, upsertEntry, deleteEntry — with Auth/Network/Server/Validation/NotFound/Unexpected mapping)
- `test/features/attendance/data/models/attendance_model_test.dart` — 13 test cases (StatusModel, CurrentModel, ScheduleModel — fromJson, toJson, round-trip, defaults, null handling)
- `test/features/kpi/data/models/kpi_model_test.dart` — 14 test cases (DefinitionModel, NoteModel, EntryModel — fromJson with nested structures, toJson, round-trip, edge cases)
- `test/features/auth/domain/usecases/auth_usecases_test.dart` — 16 test cases (all 6 use cases: param forwarding, success, failure, Params equality)
- `test/fixtures/attendance_fixtures.dart` — Sample entities, models, and JSON for attendance tests
- `test/fixtures/kpi_fixtures.dart` — Sample definitions, entries for KPI tests

**Files modified:**

- `test/helpers/mocks.dart` — Added 16 mock classes (attendance + KPI use cases, data sources, timer service)
- `CHANGELOG.md` — Added Phase 2 entry under [Unreleased]
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — This entry
- `tech_readme_files/CURRENT_STATUS.md` — Updated Testing progress from 35% to 55%

---

## March 20, 2026 — Unit Test Suite (Phase 1)

**Status:** ✅ Complete

**What changed:**

Implemented full support for the backend's `applicant_translations` pattern. The POST `/applicant/essential/info` response (containing `source_locale`, `target_locale`, `translation_status`) is now parsed and carried through the entire stack to the essential-info review page. The translation banner now shows the specific locale pair (e.g. "Translating your profile from Arabic to English"). Also fixed the `Localizations.localeOf(context)` crash in the wizard's `initState`, and added locale validation to the register form's name fields.

**Files created:**

- `lib/features/auth/essential_data/domain/entities/essential_data_submit_response_entity.dart`
- `lib/features/auth/essential_data/data/models/essential_data_submit_response_model.dart`

**Files modified:**

- `lib/features/auth/essential_data/data/datasources/essential_data_remote_datasource.dart` — Returns parsed `EssentialDataSubmitResponseModel` instead of `void`.
- `lib/features/auth/essential_data/domain/repositories/essential_data_repository.dart` — Return type changed to `Either<Failure, EssentialDataSubmitResponseEntity>`.
- `lib/features/auth/essential_data/data/repositories/essential_data_repository_impl.dart` — Returns `Right(result)`.
- `lib/features/auth/essential_data/domain/usecases/submit_essential_data_usecase.dart` — Return type updated.
- `lib/features/auth/essential_data/presentation/cubit/essential_data_state.dart` — `EssentialDataSubmitted` now carries `sourceLocale` / `targetLocale`.
- `lib/features/auth/essential_data/presentation/cubit/essential_data_cubit.dart` — Passes response locale data to state.
- `lib/features/auth/essential_data/presentation/pages/essential_data_wizard_page.dart` — Passes locale to `AuthEssentialDataCompleted`. Pre-fill moved to `didChangeDependencies`.
- `lib/features/auth/shared/presentation/bloc/auth_event.dart` — `AuthEssentialDataCompleted` now has optional locale fields.
- `lib/features/auth/shared/presentation/bloc/auth_state.dart` — `AuthAuthenticated` now has `translationSourceLocale` / `translationTargetLocale`.
- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — `_onEssentialDataCompleted` copies locale into state.
- `lib/features/auth/essential_info/presentation/cubit/essential_info_cubit.dart` — Accepts and forwards locale params.
- `lib/features/auth/essential_info/presentation/cubit/essential_info_state.dart` — `EssentialInfoLoaded` carries locale.
- `lib/features/auth/essential_info/presentation/pages/essential_info_page.dart` — `_TranslationBanner` shows locale-specific text.
- `lib/config/routes/app_router.dart` — Reads locale from `AuthAuthenticated` and passes to `EssentialInfoCubit`.
- `lib/features/auth/register/presentation/widgets/register_form_fields.dart` — Added locale validation to name fields.
- `lib/l10n/arb/app_en.arb` — Added 3 keys: `essentialInfoTranslationNoteWithLocales`, `localeNameEn`, `localeNameAr`.
- `lib/l10n/arb/app_ar.arb` — Added same 3 keys in Arabic.

**Key decisions:**

- Used `AuthAuthenticated` state as the data bridge between wizard and review page, since GoRouter redirect cannot pass `extra` data.
- Locale display names (`localeNameEn`/`localeNameAr`) are l10n keys, not hardcoded, so they show correctly in both app languages.
- `_TranslationBanner` gracefully falls back to the generic message when locale data is unavailable (e.g., returning users).

---

## March 22, 2026 — Essential Data Wizard Locale Validation

Implemented the first phase of the unit test suite: 8 test files with ~75 test cases covering AuthBloc, SettingsCubit, AuthRepositoryImpl, UserModel, UserEntity, Validators, StringExtensions, and Failure classes. Created shared test infrastructure (mocks + fixtures).

**Files created (10):**

- `test/helpers/mocks.dart` — 13 mock classes (MockAuthRepository, MockLoginUseCase, MockRegisterUseCase, MockLogoutUseCase, MockForgotPasswordUseCase, MockGetCachedUserUseCase, MockGoogleSignInUseCase, MockAuthRemoteDataSource, MockAuthLocalDataSource, MockGoogleSignIn, MockGoogleSignInAccount, MockSharedPreferences)
- `test/fixtures/auth_fixtures.dart` — Sample entities, models, and JSON fixtures for auth testing
- `test/features/auth/presentation/bloc/auth_bloc_test.dart` — 15 test cases (login, register, logout, forgot password, Google sign-in, session expiry, user data update, error clearing)
- `test/features/auth/data/repositories/auth_repository_impl_test.dart` — 14 test cases (exception-to-failure mapping for login, register, logout, forgotPassword, getCachedUser, googleSignIn)
- `test/features/auth/data/models/user_model_test.dart` — 9 test cases (fromJson flat/nested/minimal, toJson, round-trip, AuthResponseModel)
- `test/features/auth/domain/entities/user_entity_test.dart` — 8 test cases (fullName, initials, Equatable)
- `test/features/settings/presentation/cubit/settings_cubit_test.dart` — 4 test cases (load defaults, load saved prefs, setThemeMode, setLocale)
- `test/core/utils/validators_test.dart` — 19 test cases (required, email, password, confirmPassword, phone, name, minLength, maxLength)
- `test/core/extensions/string_extensions_test.dart` — 16 test cases (capitalize, titleCase, isValidEmail, truncate, initials, isNullOrEmpty, isNotNullOrEmpty)
- `test/core/error/failures_test.dart` — 12 test cases (all 8 failure types, Equatable equality, getFieldError)

**Files modified:**

- `CHANGELOG.md` — Added unit test suite entry under [Unreleased]
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — This entry
- `tech_readme_files/CURRENT_STATUS.md` — Updated Testing progress

---

## March 20, 2026 — Test Coverage Analysis

**Status:** ✅ Complete

**What changed:**

Added client-side locale-aware validation to the essential data wizard. The backend's `OpenAIApplicantRequest` rejects string fields that don't match the request locale (Arabic mode rejects Latin characters; English mode rejects Arabic characters). Previously, only the pre-fill guard checked this — users could still manually type mismatched characters and hit a 422 on submit. Now `first_name`, `last_name`, and `specialty` are validated at form level before submission.

**Files created:**

- None

**Files modified:**

- `lib/core/utils/validators.dart` — Added `Validators.localeChars()` static method with `_latinRegex` and `_arabicRegex` patterns.
- `lib/features/auth/essential_data/presentation/widgets/name_step.dart` — Added locale-aware validation to first_name and last_name fields using `Validators.localeChars()`.
- `lib/features/auth/essential_data/presentation/widgets/specialty_phone_step.dart` — Added locale-aware validation to specialty field using `Validators.localeChars()`.
- `lib/l10n/arb/app_en.arb` — Added `invalidLocaleChars` key.
- `lib/l10n/arb/app_ar.arb` — Added `invalidLocaleChars` key.
- `CHANGELOG.md` — Added entry under `[Unreleased] > Added`.

**Key decisions:**

- Validation mirrors the backend's `validateLanguage()` rule exactly: Arabic locale checks for `[a-zA-Z]`, English locale checks for `[\u0600-\u06FF]`.
- Nationality is excluded from locale validation since it comes from a server-populated dropdown that already returns locale-appropriate names.
- Phone is excluded since it's locale-independent (digits only).

---

## March 20, 2026 — Post-Registration Navigation Fix + Phone Pre-fill

**Status:** ✅ Complete

**What changed:**

Fixed the critical post-registration navigation bug where newly registered users were sent to `/home` instead of the essential data wizard. Also extended the wizard's pre-population to include the phone number from the registration response, ensuring the backend AI translation receives the full dataset on first submit.

**Files modified:**

- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — `_onEssentialDataCompleted` no longer clears `isFirstTimeEssentialData`; it only sets `needsEssentialData: false`. This keeps the first-time flag alive so the router correctly redirects `/essential-data` → `/essential-info` after wizard submission.
- `lib/features/auth/essential_data/presentation/pages/essential_data_wizard_page.dart` — `_preFillFromRegistration` now also parses `UserEntity.phone` via `PhoneNumber.parse` and passes it as the `PhoneController` initial value. Phone parsing is wrapped in try/catch; falls back to the Saudi placeholder on failure.

**Key decisions:**

- `isFirstTimeEssentialData` is intentionally left `true` after the wizard submits — the essential-info page navigates to `/home` directly, so the flag is never re-evaluated on the home route.
- Phone pre-fill uses `PhoneNumber.parse(e164)` from `phone_form_field`; no new dependencies needed.

---

## March 20, 2026 — Essential Info Screen + Essential Data Bug Fixes

**Status:** ✅ Complete

**What changed:**

Built the `auth/essential_info/` sub-feature — a post-registration review screen that opens after the essential data wizard is completed for the first time. Also fixed several bugs in the existing wizard and wired the first-time registration navigation flow end-to-end.

**Files created:**

- `lib/features/auth/essential_info/presentation/cubit/essential_info_state.dart`
- `lib/features/auth/essential_info/presentation/cubit/essential_info_cubit.dart`
- `lib/features/auth/essential_info/presentation/pages/essential_info_page.dart`
- `lib/features/auth/essential_info/presentation/widgets/essential_info_field_row.dart`

**Files modified:**

- `lib/features/auth/essential_data/presentation/pages/essential_data_wizard_page.dart` — Show `AppLoading` for `EssentialDataInitial` state; pre-populate name fields from `AuthBloc` user entity
- `lib/features/auth/essential_data/data/datasources/essential_data_remote_datasource.dart` — Already used correct null-aware `?resumeType` syntax (Dart 3+)
- `lib/features/auth/essential_data/data/repositories/essential_data_repository_impl.dart` — Added `ValidationException` mapping to `getEssentialData`
- `lib/features/auth/shared/presentation/bloc/auth_state.dart` — Added `isFirstTimeEssentialData` field to `AuthAuthenticated`
- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — Set `isFirstTimeEssentialData: true` on registration; clear on `AuthEssentialDataCompleted`
- `lib/config/routes/app_router.dart` — Updated redirect: first-time → `/essential-info`; added `/essential-info` route
- `lib/config/routes/route_names.dart` — Added `essentialInfo` constant
- `lib/injection_container.dart` — Registered `EssentialInfoCubit` factory
- `lib/l10n/arb/app_en.arb` + `app_ar.arb` — Added 4 new keys: `essentialInfoTitle`, `essentialInfoSubtitle`, `essentialInfoContinue`, `essentialInfoTranslationNote`

**Key decisions:**

- `essential_info` is an `auth/` sub-feature (not top-level) to stay consistent with `auth/essential_data/`
- No new data/domain layers — reuses `GetEssentialDataUseCase` from `essential_data`
- The `isFirstTimeEssentialData` flag lives only on registration (not login/Google), so returning users skip the review screen

---

## March 17, 2026 — Delete Account Feature

Analyzed the entire codebase (~195 Dart files) against the existing test suite (1 placeholder test). Created a comprehensive test coverage analysis document identifying 6 priority areas with estimated test counts, recommended implementation order, and proposed test directory structure.

**Files created:**

- `tech_readme_files/TEST_COVERAGE_ANALYSIS.md` — Full test coverage analysis with priority matrix, test scenarios per component, and infrastructure plan

**Files modified:**

- `CHANGELOG.md` — Added test coverage analysis entry under [Unreleased]
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — This entry
- `tech_readme_files/CURRENT_STATUS.md` — Updated Testing progress

**Key findings:**

- 0% actual test coverage (1 placeholder test)
- ~280-370 test cases identified across 6 priority tiers
- BLoC tests (P1) and repository tests (P3) offer best coverage-to-effort ratio
- `bloc_test` and `mocktail` already in dev dependencies but unused
Fixed the GoRouter `errorPageBuilder` to follow project conventions — replaced hardcoded `Colors.red`, `SizedBox(height:)` values, and English string literals with design tokens and localized strings.

**Files created:**

- None

**Files modified:**

- `lib/config/routes/app_router.dart` — Replaced `Colors.red` with `AppColors.error`, `SizedBox(height: 16/8/24)` with `AppSpacing.verticalBase/SM/XL`, `'Page not found'`/`'Go Home'` with `context.l10n.pageNotFound`/`context.l10n.goHome`. Added imports for `AppColors`, `AppSpacing`, and `context_extensions.dart`.
- `lib/l10n/arb/app_en.arb` — Added `pageNotFound` and `goHome` keys.
- `lib/l10n/arb/app_ar.arb` — Added `pageNotFound` and `goHome` keys (Arabic translations).
- `lib/l10n/generated/app_localizations.dart` — Added abstract getters for new keys.
- `lib/l10n/generated/app_localizations_en.dart` — Added EN implementations.
- `lib/l10n/generated/app_localizations_ar.dart` — Added AR implementations.

**Key decisions:**

- Used `AppColors.error.withValues(alpha: 0.7)` to match the existing `AppErrorWidget` style.
- Reused `context.textTheme` via `context_extensions.dart` for consistency.

---

## March 20, 2026 — Home Screen Skeletonizer & Empty States

**Status:** ✅ Complete

**What changed:**

Integrated the backend `DELETE /delete/account` endpoint end-to-end. The feature soft-deletes the user on the server, revokes the Google Sign-In session, clears all local auth data, and redirects the user to the login screen.

**Files created:**

- `lib/features/auth/shared/domain/usecases/delete_account_usecase.dart`

**Files modified:**

- `lib/core/api/api_endpoints.dart` — Added `deleteAccount = '/delete/account'`
- `lib/features/auth/shared/data/datasources/auth_remote_datasource.dart` — Added `deleteAccount()` abstract + impl
- `lib/features/auth/shared/domain/repositories/auth_repository.dart` — Added `deleteAccount()` contract
- `lib/features/auth/shared/data/repositories/auth_repository_impl.dart` — Implemented `deleteAccount()`
- `lib/features/auth/shared/presentation/bloc/auth_event.dart` — Added `AuthDeleteAccountRequested`
- `lib/features/auth/shared/presentation/bloc/auth_state.dart` — Added `AuthAccountDeleted`
- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — Added `deleteAccountUseCase` field + `_onDeleteAccountRequested` handler
- `lib/injection_container.dart` — Registered `DeleteAccountUseCase`, wired into `AuthBloc`
- `lib/features/settings/presentation/widgets/sections/settings_account_section.dart` — Added delete account tile + confirmation dialog
- `lib/features/settings/presentation/pages/settings_page.dart` — BlocListener now handles `AuthAccountDeleted` → navigate to `/`

**Key decisions:**

- Used `AuthAccountDeleted` state separate from `AuthUnauthenticated` so future code can distinguish deletion from plain logout
- Delete account hits the API (not fire-and-forget like logout) since the server must soft-delete before the client clears local data
- Google Sign-In is revoked before the API call to ensure cleanup even on failure
- Both confirmation `l10n` keys (`deleteAccount`, `deleteAccountConfirmation`) were already present in EN + AR ARBs — no `flutter gen-l10n` run needed

---

## March 17, 2026 — Auth Navigation Refactor + Bug Fixes

**Status:** ✅ Complete

**What changed:**

### 1. New Auth Selection Screen

Inserted `/auth-select` between onboarding and login/register. Onboarding now ends at auth-select instead of going directly to login. Shows logo header, Login (primary) + Create Account (outlined) buttons, Google Sign-In option, and a back arrow returning to onboarding. Login and register are pushed from auth-select so the system back button returns naturally.

**Navigation flow:**
`Splash → /language-select → /onboarding → /auth-select → /login or /register`

**Files created:**

- `lib/features/auth/auth_select/presentation/pages/auth_select_page.dart`

**Files modified:**

- `lib/config/routes/route_names.dart` — Added `authSelect`
- `lib/config/routes/app_router.dart` — Added `/auth-select` route + public path
- `lib/features/auth/onboarding/presentation/pages/onboarding_page.dart` — Routes to `/auth-select`
- `lib/features/auth/shared/presentation/widgets/auth_header.dart` — Added `authSelectTitle`/`authSelectSubtitle` cases
- `lib/l10n/arb/app_en.arb`, `app_ar.arb` — Added `authSelectTitle`, `authSelectSubtitle`
- `lib/l10n/generated/` — Regenerated via `flutter gen-l10n`

### 2. Register → Essential Data Bug Fixed

`_onRegisterRequested` now always emits `needsEssentialData: true` and clears any stale `essentialDataComplete` flag, so fresh registrations always land on the essential data wizard regardless of device history.

**Files modified:**

- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart`

### 3. Login & Register Page Refinements

- Login: added back button (pops to auth-select), kept register link + explicit `context.go('/home')`
- Register footer: retained Google sign-up and "Already have an account?" link

**Files modified:**

- `lib/features/auth/login/presentation/pages/login_page.dart`
- `lib/features/auth/register/presentation/widgets/register_footer.dart`

---

## March 17, 2026 — Auth & Profile Bug Fixes (5 items)

**Status:** ✅ Complete

**What changed:**

### 1. Duplicate Profile Requests on Startup — Fixed

`SettingsCubit._loadSettings()` restores the saved locale on startup, firing the `BlocListener<SettingsCubit>` in `app.dart` and dispatching `ProfileRefreshRequested`. This raced against `MainShell.initState()` dispatching `ProfileLoadRequested`, doubling all 9 profile API calls. Fixed by guarding the dispatch: `ProfileRefreshRequested` is only sent when the profile is already in `ProfileLoaded` or `ProfileRefreshing` state — meaning it was a manual locale change, not startup restore.

**Files modified:**

- `lib/app.dart` — Added `ProfileState` guard in `BlocListener<SettingsCubit>` listener; added `profile_state.dart` import

### 2. Logout Takes 15 Seconds — Fixed

`AuthRepositoryImpl.logout()` awaited the remote logout call, blocking for the full 15-second `connectTimeout` when offline or the server was slow. Changed to fire-and-forget: `remoteDataSource.logout().catchError((_) {})` dispatches the request without blocking. Local auth data is cleared immediately.

**Files modified:**

- `lib/features/auth/shared/data/repositories/auth_repository_impl.dart` — Removed `try/catch`, replaced `await remoteDataSource.logout()` with fire-and-forget

### 3. Misleading "No Internet Connection" Error on Timeout — Fixed

`ProfileRepositoryImpl`, `AttendanceRepositoryImpl`, and `KpiRepositoryImpl` caught `NetworkException` without binding the variable, discarding the actual message. Changed to `on NetworkException catch (e)` so the real message (e.g. "Connection timed out") propagates to the UI.

**Files modified:**

- `lib/features/profile/shared/data/repositories/profile_repository_impl.dart`
- `lib/features/attendance/data/repositories/attendance_repository_impl.dart`
- `lib/features/kpi/data/repositories/kpi_repository_impl.dart`

### 4. connectTimeout Reduced from 30s to 15s

**Files modified:**

- `lib/core/api/api_client.dart`

### 5. Register Page Refactored + Navigation Race Condition Fixed

Extracted the 436-line `RegisterPage` into focused widget files. Removed explicit `context.go('/essential-data')` and `context.go('/home')` calls (previously in both `RegisterPage` and `EssentialDataWizardPage`) that could race against GoRouter's async redirect.

**Files created:**

- `lib/features/auth/register/presentation/widgets/register_avatar_picker.dart`
- `lib/features/auth/register/presentation/widgets/register_form_fields.dart`
- `lib/features/auth/register/presentation/widgets/register_footer.dart`

**Files modified:**

- `lib/features/auth/register/presentation/pages/register_page.dart` — 436 → ~165 lines; navigation delegated to GoRouter redirect
- `lib/features/auth/essential_data/presentation/pages/essential_data_wizard_page.dart` — Removed explicit `context.go()` calls

---

## March 16, 2026 — Auth Sub-Feature Restructure + Essential Data Wizard

**Status:** ✅ Complete

**What changed:**

### 1. Auth Feature Restructured into Sub-Features

Reorganized the flat `lib/features/auth/` directory into 7 sub-feature directories following the profile feature pattern. The `shared/` directory holds the data layer, domain layer, bloc, and common widgets used across all auth sub-features. Each page-level sub-feature (splash, login, register, etc.) contains only its presentation layer.

**New directory structure:**

```
features/auth/
├── shared/                  # Shared data, domain, bloc, widgets
│   ├── data/datasources/    # auth_local_datasource, auth_remote_datasource
│   ├── data/models/         # user_model
│   ├── data/repositories/   # auth_repository_impl
│   ├── domain/entities/     # user_entity
│   ├── domain/repositories/ # auth_repository (abstract)
│   ├── domain/usecases/     # 6 use cases
│   ├── presentation/bloc/   # auth_bloc, auth_event, auth_state
│   └── presentation/widgets/# auth_header, social_login_button
├── splash/presentation/pages/
├── language_select/presentation/pages/
├── onboarding/presentation/pages/ + widgets/
├── login/presentation/pages/
├── register/presentation/pages/
├── forgot_password/presentation/pages/
└── essential_data/          # NEW — full Clean Architecture sub-feature
```

### 2. Essential Data Wizard (New Feature)

4-step post-auth wizard enforced at the router level on every authentication (login, register, Google sign-in). Collects required profile data before granting app access.

**Steps:**

1. First Name + Last Name
2. Age + Nationality (dropdown fetched from API)
3. Specialty + Phone
4. Resume upload (PDF/DOC/DOCX, 5MB) with Arabic/English toggle

**Architecture:** Full Clean Architecture — entity, 2 use cases (`GetEssentialDataUseCase`, `SubmitEssentialDataUseCase`), remote datasource with multipart upload, repository impl, `EssentialDataCubit` (factory).

**Auth flow changes:**

- `AuthAuthenticated` state gains `needsEssentialData` flag (default: `true`) + `copyWith`
- `AuthBloc` now depends on `SharedPreferences`, checks local `essentialDataComplete` flag
- New `AuthEssentialDataCompleted` event
- Router redirect: authenticated + `needsEssentialData` → `/essential-data`

**Files created (essential_data/):**

- `domain/entities/essential_data_entity.dart`
- `domain/repositories/essential_data_repository.dart`
- `domain/usecases/get_essential_data_usecase.dart`
- `domain/usecases/submit_essential_data_usecase.dart`
- `data/models/essential_data_model.dart`
- `data/datasources/essential_data_remote_datasource.dart`
- `data/repositories/essential_data_repository_impl.dart`
- `presentation/cubit/essential_data_cubit.dart`
- `presentation/cubit/essential_data_state.dart`
- `presentation/pages/essential_data_wizard_page.dart`
- `presentation/widgets/wizard_step_indicator.dart`
- `presentation/widgets/name_step.dart`
- `presentation/widgets/age_nationality_step.dart`
- `presentation/widgets/specialty_phone_step.dart`
- `presentation/widgets/resume_step.dart`

**Files modified:**

- `lib/config/routes/app_router.dart` — new `/essential-data` route, redirect logic
- `lib/config/routes/route_names.dart` — added `essentialData` constant
- `lib/core/constants/storage_keys.dart` — added `essentialDataComplete` key
- `lib/injection_container.dart` — added `_initEssentialData()`, updated AuthBloc with SharedPreferences
- `lib/features/auth/shared/presentation/bloc/auth_bloc.dart` — essential data flag logic
- `lib/features/auth/shared/presentation/bloc/auth_state.dart` — `needsEssentialData` field
- `lib/features/auth/shared/presentation/bloc/auth_event.dart` — `AuthEssentialDataCompleted` event
- `lib/l10n/arb/app_en.arb` — 22 new keys
- `lib/l10n/arb/app_ar.arb` — 22 new keys
- ~30 files with updated import paths from auth restructure (settings, home, profile, DI, router)
Added a full-page skeleton loading state and inline empty states to the home screen.

**Files created:**

- `lib/features/home/presentation/widgets/home_page_skeleton.dart` — Full-page `Skeletonizer` widget mirroring the home page layout (greeting header, attendance card, quick actions, stats row, recent KPIs section, recent attendance section). Uses private `StatelessWidget` helpers: `_MiniStatCardSkeleton`, `_EntryRowCardSkeleton`.

**Files modified:**

- `lib/features/home/presentation/pages/home_page.dart` — Wraps body in nested `BlocBuilder`s (Profile, Attendance, KPI); shows `HomePageSkeleton` when all three are in initial/loading state.
- `lib/features/home/presentation/widgets/home_recent_kpis.dart` — Now shows an inline `EmptyStateWidget` (bar chart icon + `noRecentEntries` label) when `KpiLoaded` but entries list is empty, instead of `SizedBox.shrink()`.
- `lib/features/home/presentation/widgets/home_recent_attendance.dart` — Now shows an inline `EmptyStateWidget` (clock icon + `noRecentRecords` label) when `AttendanceLoaded` but schedule list is empty, instead of `SizedBox.shrink()`.

**Key decisions:**

- Skeleton is shown only when **all three** BLoCs are in initial/loading state simultaneously — once any one resolves, the real page renders and each widget handles its own loading state.
- Empty sections (KPIs, attendance) still render their section header + "See All" button when loaded but empty, so users have a navigation affordance.
- No new l10n keys needed — reused existing `noRecentEntries` and `noRecentRecords` keys.

---

## March 15, 2026 — Settings Widgets Directory Refactor

**Status:** ✅ Complete

**What changed:**

Reorganized the flat `lib/features/settings/presentation/widgets/` directory into three subdirectories by responsibility:

- `common/` — shared primitives used across sections and pages (`settings_tile.dart`, `settings_section_header.dart`)
- `sections/` — full page sections composed into `settings_page.dart` (7 widget files)
- `dialogs/` — app info dialog and its supporting changelog data (2 files)

Removed the unused `settings_logout_button.dart`. All internal cross-imports and page imports updated accordingly.

**Files deleted:**

- `lib/features/settings/presentation/widgets/settings_tile.dart` (moved to `common/`)
- `lib/features/settings/presentation/widgets/settings_section_header.dart` (moved to `common/`)
- `lib/features/settings/presentation/widgets/settings_about_section.dart` (moved to `sections/`)
- `lib/features/settings/presentation/widgets/settings_account_section.dart` (moved to `sections/`)
- `lib/features/settings/presentation/widgets/settings_contact_section.dart` (moved to `sections/`)
- `lib/features/settings/presentation/widgets/settings_dev_options_section.dart` (moved to `sections/`)
- `lib/features/settings/presentation/widgets/settings_language_section.dart` (moved to `sections/`)
- `lib/features/settings/presentation/widgets/settings_theme_section.dart` (moved to `sections/`)
- `lib/features/settings/presentation/widgets/settings_user_card.dart` (moved to `sections/`)
- `lib/features/settings/presentation/widgets/app_info_dialog.dart` (moved to `dialogs/`)
- `lib/features/settings/presentation/widgets/app_changelog_data.dart` (moved to `dialogs/`)
- `lib/features/settings/presentation/widgets/settings_logout_button.dart` (deleted — unused)

**Files modified:**

- `lib/features/settings/presentation/pages/settings_page.dart` — updated all widget imports to new subdirectory paths
- `lib/features/settings/presentation/pages/dev_options_page.dart` — updated widget imports to `common/` subdirectory

---

**Status:** ✅ Complete

**What changed:**

Added a new `v1.2.0` (March 15, 2026) entry to the in-app changelog in `AppInfoDialog`. The entry covers all unreleased changes since v1.1.0: multi-skill add, in-app video player, searchable nationality dropdown, improved date inputs, country field in experience, locale-aware profile refresh, skills locale fix, modern bottom nav, button style unification, and 4 bug fixes (profile locale switch, skills empty circles, phone field RTL, Android 11+ video). Also split data models and version entries out of the dialog widget into a dedicated data file for cleaner separation.

**Files created:**

- `lib/features/settings/presentation/widgets/app_changelog_data.dart` — Public `VersionEntry` and `ChangeGroup` models + `appChangelog` const list with all version entries

**Files modified:**

- `lib/features/settings/presentation/widgets/app_info_dialog.dart` — Removed inline data models and changelog list; imports from `app_changelog_data.dart`; extracted `_CompanyHeader` widget; file is now UI-only

---

## March 15, 2026 — Profile Locale Refresh Bug Fix

**Status:** ✅ Complete

**What changed:**

Fixed a bug where profile data disappeared or stayed in the old language when the user switched locales (English ↔ Arabic). Four root causes were addressed:

1. **`ProfileBloc` cached stale localized data** — The BLoC cached API responses containing localized strings (nationality, gender, industry names, etc.) and never re-fetched when the locale changed.
2. **`ProfileLocalDataSource` persisted locale-specific data** — The SharedPreferences cache stored localized API responses. On app restart, the cached data could be in the wrong language.
3. **`EditProfileLookups.isLoaded` guard** — Once fetched for one locale, lookups were never re-fetched because `if (isLoaded) return;` skipped API calls.
4. **Skills showed empty circles on locale switch** — The backend `SkillRepository` only eager-loads skill translations matching the requested locale. Skills created in English had no Arabic translation row, so switching to Arabic returned `name: null`, rendering empty chip circles.

**Fix:**

- Added a `BlocListener<SettingsCubit, SettingsState>` in `app.dart` that fires on locale changes. It clears the profile local cache, resets `EditProfileLookups`, and triggers `ProfileRefreshRequested` to re-fetch all profile data with the new locale header.
- `ProfileRemoteDataSource.getSkills()` now fetches skills for **both** locales (`en` and `ar`) in parallel and merges results — the first non-empty name wins.
- `ApiClient` interceptor changed from `headers['lang'] =` to `headers.putIfAbsent('lang', ...)` so per-request locale overrides are respected.

**Files modified:**

- `lib/app.dart` — Added `BlocListener` for locale changes; new imports for `ProfileLocalDataSource`, `EditProfileLookups`, `ProfileEvent`
- `lib/features/profile/edit_profile/presentation/helpers/edit_profile_lookups.dart` — Added `reset()` method to clear cached lookup data
- `lib/features/profile/shared/data/datasources/profile_remote_datasource.dart` — `getSkills()` now fetches both locales and merges
- `lib/core/api/api_client.dart` — Interceptor uses `putIfAbsent` for locale headers to allow per-request overrides

---

## March 15, 2026 — Multi-Skill Add UX (improved)

**Status:** ✅ Complete

**What changed:**

Follow-up polish pass on the multi-skill chip-input bottom sheet. The original implementation had an external `IconButton` next to the field and a plain chips list. This pass extracted all UI into sub-widgets and improved discoverability and feedback.

- **`_AddSuffixButton`** — Compact `+ Add` pill rendered as the text field's `suffixIcon`. Replaces the floating `IconButton.filled` sitting next to the field.
- **`_KeyHint`** — Styled keyboard-badge widget (uses `surfaceContainerHighest` + `outlineVariant` border). Rendered twice below the field: `↵ Enter` and `,`, followed by "to add a skill" hint text.
- **Duplicate detection** — `_tryAddPending` now checks `_pending.contains(raw)` before adding; if duplicate, sets `_duplicateError` string (displayed as `errorText` on `AppTextField`) and auto-clears after 2 seconds.
- **`_EmptyChipsPlaceholder`** — Soft bordered container with a `star_border_rounded` icon and "Added skills appear here" text. Shown when `_pending` is empty.
- **`_ChipsSection`** — Chips container with: (1) header row showing `✓ Skills to add` + count badge pill; (2) chips rendered in a primary-tinted `DecoratedBox`.
- **`AnimatedSize`** — Wraps the chips area; smoothly transitions between empty placeholder and chips section height.
- **Submit button** — Shows `✓ Add · N skills` (`Icons.check_rounded` + count label) when skills are queued; plain disabled `Add` otherwise.

**Files modified:**

- `lib/features/profile/edit_profile/presentation/widgets/dialogs/add_skill_dialog.dart` — full multi-mode redesign; 4 new private sub-widgets extracted

---

## March 15, 2026 — Multi-Skill Add UX

**Status:** ✅ Complete

**What changed:**

The "Add Skill" button in Edit Profile now opens a chip-input bottom sheet for adding multiple skills at once instead of one at a time.

- **`AddSkillDialog.showMulti()`** — New static method that opens a multi-mode bottom sheet. Users type a skill and press Enter or comma to add it as a pending chip. Chips can be removed before submitting. The "Add (N)" button is disabled until at least one skill is pending.
- **`AddSkillDialog.show()`** — Unchanged; used for single-skill editing.
- **`SkillsBulkAddRequested`** — New BLoC event carrying `List<String> names`. Handled in `ProfileBloc._onBulkAddSkills` which adds each skill sequentially, emits `ProfileUpdateSuccess`, and triggers a profile reload.
- **`EditSkillsSection._onAdd`** — Now calls `showMulti()` and dispatches `SkillsBulkAddRequested`.
- **3 new l10n keys** — `addSkills`, `typeSkillAndEnter`, `skillsAdded` in both EN and AR ARB files.

**Files modified:**

- `lib/features/profile/edit_profile/presentation/widgets/dialogs/add_skill_dialog.dart` — added `multiMode` flag, `showMulti()` static method, chip-input build path
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_skills_section.dart` — `_onAdd` now uses `showMulti` + `SkillsBulkAddRequested`
- `lib/features/profile/profile_view/presentation/bloc/profile_event.dart` — added `SkillsBulkAddRequested`
- `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — added `_onBulkAddSkills` handler
- `lib/l10n/arb/app_en.arb` — added `addSkills`, `typeSkillAndEnter`, `skillsAdded`
- `lib/l10n/arb/app_ar.arb` — same keys in Arabic

---

## March 15, 2026 — In-App Video Player for Profile Videos

**Status:** ✅ Complete

**What changed:**

Profile videos previously failed to open on Android 11+ due to missing `<queries>` intent filters in the manifest, and the `canLaunchUrl` guard silently swallowed the failure. Videos now open inside the app via a new full-screen `VideoPlayerPage`.

- **Root cause fixed** — Added `https` and `http` scheme intent queries to `android/app/src/main/AndroidManifest.xml` (required since Android 11 / API 30 for package visibility).
- **New shared widget `VideoPlayerPage`** — Full-screen in-app video player using `video_player` (Flutter official) + `chewie` (controls UI). Streams the remote S3 URL directly. Shows `AppLoading` while initializing, error state with Retry on failure. Uses app design tokens (`AppColors`, `AppSpacing`, `context.textTheme`) and localization (`context.l10n`). Black scaffold background for immersive playback.
- **New route `RouteNames.videoPlayer`** (`/video-player`) — Added to `route_names.dart` and `app_router.dart`, same pattern as `/pdf-viewer`.
- **`ProfilePage._onViewVideo` refactored** — Now pushes `RouteNames.videoPlayer` with `url` and localized `title` extra. Removed `url_launcher` import from `profile_page.dart`.
- **New l10n keys** `failedToLoadVideo` (EN + AR), `couldNotOpenFile` (EN + AR) added to both ARB files and regenerated.

**Files created:**

- `lib/shared/widgets/video_player/video_player_page.dart` — new shared full-screen video player widget

**Files modified:**

- `android/app/src/main/AndroidManifest.xml` — added `https`/`http` intent queries inside `<queries>`
- `lib/config/routes/route_names.dart` — added `videoPlayer` constant
- `lib/config/routes/app_router.dart` — added `/video-player` GoRoute + `VideoPlayerPage` import
- `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — `_onViewVideo` now uses `context.pushNamed`; removed `url_launcher` import
- `lib/l10n/arb/app_en.arb` — added `failedToLoadVideo`, `couldNotOpenFile`
- `lib/l10n/arb/app_ar.arb` — same keys in Arabic
- `pubspec.yaml` — added `video_player: ^2.9.2`, `chewie: ^1.10.0`

**Key decisions:**

- `video_player` + `chewie` chosen over `better_player` / VLC for simplicity and Flutter-team maintenance.
- `VideoPlayerPage` is a shared widget (not feature-specific) because it is the video equivalent of `PdfViewerPage` and may be reused by other features.
- Kept `url_launcher` in `pubspec.yaml` — still used elsewhere in the app (e.g. settings, external links).

---

## March 15, 2026 — Searchable Nationality Dropdown

**Status:** ✅ Complete

**What changed:**

Added a new `AppSearchableDropdownField` shared widget and applied it to the Nationality field in the edit-profile personal form:

- **New widget** `AppSearchableDropdownField` — looks identical to `AppDropdownField` (label + prefixIcon + chevron) but opens a searchable bottom sheet on tap instead of a native dropdown menu.
- **Search sheet** — auto-focuses a search `TextField` at the top; filters the list live as the user types (case-insensitive contains match); shows a check icon next to the currently selected item; shows "No results" state when nothing matches; tapping an item pops the sheet and calls `onChanged`.
- **Clear search** — a × button appears in the search field when it has text.
- **Loading state** — shows a small spinner in the suffix area while `isLoading` is true.
- Nationality in `edit_personal_form.dart` switched from `AppDropdownField` to `AppSearchableDropdownField`.

**Files created:**

- `lib/shared/widgets/inputs/app_searchable_dropdown_field.dart` — new reusable widget

**Files modified:**

- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_form.dart` — import + nationality field swap

**Key decisions:**

- `AppDropdownField` unchanged — kept for short lists (gender, marital status, work shift). `AppSearchableDropdownField` is the option for long lists where search adds value.
- Sheet uses `showModalBottomSheet` directly (same drag handle + header visual as `AppBottomSheet`) to allow returning a typed value via `Navigator.pop`.
- No new ARB keys needed — reuses existing `"search"` key for the search hint.

---

## March 15, 2026 — Birth Date Auto-Format Input Sheet

**Status:** ✅ Complete

**What changed:**

Replaced the standard `showDatePicker` (which opened a calendar by default and showed unformatted digits in text-entry mode) with a custom bottom sheet that makes **typed input the primary experience**:

- **Auto-formatting** — `_DateTextInputFormatter` strips non-digits and auto-inserts `/` after the day and month positions, so typing `23062003` renders live as `23/06/2003`.
- **Input is primary** — the bottom sheet opens with the formatted text field auto-focused; the native calendar picker is demoted to a secondary "Use Calendar" `TextButton` + header icon button.
- **Format hint** — a small ℹ️ row below the field shows the localized `dateFormatHint` (e.g. "Format: Day / Month / Year").
- **Inline validation** — tapping Confirm when the input is incomplete or not a real date shows an inline error using `invalidDate` localization key.
- **Pre-fills existing value** — if a date is already stored it is converted to DD/MM/YYYY and pre-filled in the input controller.
- **`AppTextField.inputFormatters`** — added optional `List<TextInputFormatter>?` parameter to the shared `AppTextField` widget so formatters can be passed through cleanly.

**Files modified:**

- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_tab.dart` — replaced `_pickBirthDate` + added `_DateTextInputFormatter` + `_BirthDateInputSheet` private classes
- `lib/shared/widgets/inputs/app_text_field.dart` — added `inputFormatters` parameter
- `lib/l10n/arb/app_en.arb` — added `invalidDate`, `useCalendar`, `dateFormatHint`, `dateInputHint`
- `lib/l10n/arb/app_ar.arb` — same keys in Arabic

**Key decisions:**

- Format is DD/MM/YYYY (day-first, international / Middle East standard).
- `_DateTextInputFormatter` re-derives the formatted string from raw digits on every keystroke, making deletions/edits naturally correct without cursor management.
- The `_BirthDateInputSheet` is a private class inside the tab file — it's used in exactly one place and keeping it co-located avoids file proliferation.

---

## March 15, 2026 — Birth Date Field UI/UX Improvement

**Status:** ✅ Complete

**What changed:**

Replaced the plain read-only `AppTextField` used for birth date selection in the edit profile personal tab with a dedicated `AppDateField` widget:

- **Human-readable format** — Date displays as "15 Jan 1998" instead of raw `yyyy-MM-dd`. The backend payload is unaffected (still `yyyy-MM-dd` from `birthDateCtrl`).
- **Visual affordance** — Chevron-down icon signals the field opens a picker; once a date is set, the chevron is replaced with a clear (×) button.
- **Age helper text** — A small helper text below the field shows the computed age (e.g. "Age: 27") using the existing localized `age` key, giving immediate feedback after picking.
- **Clear action** — Tapping × clears the date and marks the form as dirty, consistent with other form flows.

**Files created:**

- `lib/shared/widgets/inputs/app_date_field.dart` — New reusable `AppDateField` widget

**Files modified:**

- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_form.dart` — Added `onClearBirthDate`, `_displayDate()`, `_age()` helpers; swapped `AppTextField` → `AppDateField`
- `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_tab.dart` — Passes `onClearBirthDate` closure

**Key decisions:**

- `AppDateField` is purely presentational; date state remains in `birthDateCtrl` (`TextEditingController`) so change-tracking and dirty-flagging continue to work automatically via existing listeners.
- Age calculation uses exact year/month/day comparison, not just year subtraction.
- No new ARB keys added — age display uses the existing `"age"` key from both locale files.

---

## March 15, 2026 — Edit Profile UI/UX Improvements

**Status:** ✅ Complete

**What changed:**

Improved clarity and usability of the edit profile screen across all three tabs:

- **Tab bar icons** — Each tab now shows a small icon (`person_outline`, `work_outline`, `layers_outlined`) above the label for faster visual identification.
- **City + Location row** — Personal form now groups City and Current Location in a side-by-side row, reducing vertical scroll.
- **Salary + Currency row** — Professional form groups Monthly Salary (flex 3) and Currency dropdown (flex 2) in the same row — they are logically paired and this halves the vertical space needed.
- **Driving License toggle** — `CheckboxListTile` replaced with a `SwitchListTile` inside a `DecoratedBox` with `outlineVariant` border and `borderRadiusMD` — matches the visual language of the other input fields.
- **Background camera badge** — Moved from top-left to top-right of the profile header so it doesn't overlap with avatar content and aligns with the conventional edit-hint position.

**Files created:** None

**Files modified (4):**

1. `lib/features/profile/edit_profile/presentation/pages/edit_profile_page.dart` — Tab widgets now include icons
2. `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_personal_form.dart` — City + Location in a row
3. `lib/features/profile/edit_profile/presentation/widgets/edit_profile/edit_professional_form.dart` — Salary + Currency row, `SwitchListTile` for driving license
4. `lib/features/profile/shared/presentation/widgets/common/profile_header.dart` — Background camera badge moved to top-right

**Key decisions:**

- Used `SwitchListTile` (not a bare `Switch`) to preserve built-in tap-anywhere-to-toggle behavior.
- Salary flex 3, Currency flex 2 — salary needs more width for number entry; currency label/value is short.
- `AppRadius.borderRadiusMD` for the driving license border matches the text field border radius used by `AppTextField`.

---

## March 15, 2026 — Language Card Theme Color Fix

**Status:** ✅ Complete

**What changed:**

`_LanguageCard` in `language_select_page.dart` was reading `colorScheme.surface` for its unselected background. In dark mode `colorScheme.surface` is `#2F3349` (blue-tinted) while `cardTheme.color` is `#383838` (neutral dark), causing language cards to look different from every other `Card` widget. Changed to `Theme.of(context).cardTheme.color ?? colorScheme.surface`.

**Files created:** None

**Files modified (1):**

1. `lib/features/auth/presentation/pages/language_select_page.dart` — `_LanguageCard` background uses `cardTheme.color` instead of `colorScheme.surface`

**Key decision:** Use the single fallback `?? colorScheme.surface` so the widget degrades gracefully if `cardTheme.color` is ever null.

---

## March 15, 2026 — Phone Field RTL Fix

**Status:** ✅ Complete

**What changed:**

Wrapped `PhoneFormField` in `Directionality(textDirection: TextDirection.ltr)` inside `AppPhoneField`. This prevents the country button, flag, dial code, and digit input from mirroring/flipping in Arabic RTL mode. Phone numbers are always left-to-right regardless of locale.

**Files created:** None

**Files modified (1):**

1. `lib/shared/widgets/inputs/app_phone_field.dart` — Added `Directionality` wrapper around `PhoneFormField`

**Key decision:** Force LTR only on the `PhoneFormField` child. The outer `Column` (label) continues to inherit RTL from the app locale so the label aligns correctly in Arabic screens.

---

## March 13, 2026 — Arabic Font (Tajawal)

**Status:** ✅ Complete

**What changed:**

Added locale-aware font selection: when the app locale is Arabic, the UI uses the Tajawal font family (local assets) instead of PublicSans. English and other locales continue to use PublicSans via Google Fonts.

**Files created:** None

**Files modified (6):**

1. `pubspec.yaml` — Added Tajawal font declarations (Regular, Medium, Bold)
2. `lib/config/theme/app_text_styles.dart` — Added `AppFonts.arabic`, `AppFonts.forLocale(Locale)`
3. `lib/config/theme/light_theme.dart` — Added `themeForLocale(Locale)`, locale-aware font in all theme components
4. `lib/config/theme/dark_theme.dart` — Same as light theme
5. `lib/app.dart` — Uses `LightTheme.themeForLocale(settings.locale)` and `DarkTheme.themeForLocale(settings.locale)`

**Key decisions:**

- Tajawal loaded from local assets (`assets/fonts/Tajawal-*.ttf`) — no runtime download
- Theme rebuilds when locale changes (via BlocBuilder on SettingsState)
- All themed components (buttons, inputs, app bar, navigation, etc.) use the locale font

---

## March 13, 2026 — Onboarding Widgets Extraction

**Status:** ✅ Complete

**What changed:**

Consolidated onboarding widgets into `lib/features/auth/presentation/widgets/onboarding_widgets/onboarding_widgets.dart`. Single file contains: `OnboardingData`, `OnboardingHeader`, `OnboardingPageContent`, `OnboardingDotIndicator`, `OnboardingProgress`, `OnboardingNavButtons`.

**Files created (1):**

1. `widgets/onboarding_widgets/onboarding_widgets.dart` — All onboarding widgets in one file

**Files deleted (6):**

- onboarding_data.dart, onboarding_header.dart, onboarding_page_content.dart, onboarding_progress.dart, onboarding_nav_buttons.dart, onboarding_dot_indicator.dart

**Files modified (1):**

1. `onboarding_page.dart` — Import from onboarding_widgets/onboarding_widgets.dart

---

## March 13, 2026 — Onboarding Screen Improvements

**Status:** ✅ Complete

**What changed:**

Redesigned onboarding to align with actual app features (Profile, KPIs, Attendance). Replaced job-focused content with workforce management features. UX/UI improvements: app logo in top bar, feature icons (person_outline, bar_chart, schedule), softer icon circles with shadow, full-width Next button on first page, smoother page transitions.

**Files modified (4):**

1. `lib/features/auth/presentation/pages/onboarding_page.dart` — Logo, icons, layout, styling
2. `lib/l10n/arb/app_en.arb` — onboardingTitle1–3, onboardingDesc1–3
3. `lib/l10n/arb/app_ar.arb` — Arabic translations
4. `lib/l10n/generated/*` — Regenerated via flutter gen-l10n

---

## March 13, 2026 — App Info Dialog Changelog Update

**Status:** ✅ Complete

**What changed:**

Synced `app_info_dialog.dart` changelog with DOCUMENTATION_UPDATE_SUMMARY, CURRENT_STATUS, and CHANGELOG. Added new March 13, 2026 entry at the top covering: attendance background timer, live home dashboard, offline support, attendance/KPI filters, default light theme + Arabic, production backend, pull-to-refresh fixes, jobs removal. Kept March 11, 2026 entry for 1.1.0 base features.

**Files modified (1):**

1. `lib/features/settings/presentation/widgets/app_info_dialog.dart` — New changelog entry, Removed section for jobs

---

## March 13, 2026 — Default Theme Light, Default Locale Arabic

**Status:** ✅ Complete

**What changed:**

Updated app defaults so new users see light theme and Arabic language. Modified `SettingsCubit` and `SettingsState` to use `ThemeMode.light` and `Locale('ar')` when no saved preferences exist. Users can still change theme and language in settings.

**Files modified (2):**

1. `lib/features/settings/presentation/cubit/settings_cubit.dart` — Default theme `ThemeMode.system` → `ThemeMode.light`, default locale `'en'` → `'ar'`
2. `lib/features/settings/presentation/cubit/settings_state.dart` — Default `ThemeMode.light`, default `Locale('ar')`

---

## March 13, 2026 — Switched API Target to Deployed Backend

**Status:** ✅ Complete

**What changed:**

Switched the app from the local development backend (`http://192.168.100.59:8000`) to the deployed production backend at `https://admin.technology92.com`. Updated the `.env` file, `.env.example`, and the default fallback URL in `EnvConfig`.

**Files modified (3):**

1. `.env` — Changed `API_BASE_URL` to `https://admin.technology92.com`
2. `.env.example` — Changed `API_BASE_URL` to `https://admin.technology92.com`
3. `lib/config/environment/env_config.dart` — Changed `defaultValue` from `http://localhost:8000` to `https://admin.technology92.com`

**Key decisions:**

- Updated the default fallback URL in `env_config.dart` so the app targets the deployed backend even when the `.env` file is not passed via `--dart-define-from-file`
- The full API base URL resolves to `https://admin.technology92.com/api/v1`

---

## March 13, 2026 — Attendance Background Timer with Lock Screen Notification

**Status:** ✅ Complete

**What changed:**

Implemented a foreground service that keeps the attendance timer running in the background using `flutter_foreground_task`. A persistent notification shows the live elapsed time and status label, visible on the lock screen and notification center. The timer continues when the app is backgrounded, the phone is locked, or another app is opened. The `AttendancePage` now receives elapsed seconds from the service isolate instead of running a local `Timer.periodic`.

**Files created (1):**

1. `lib/features/attendance/data/services/attendance_timer_service.dart` — `AttendanceTimerService` (init, start, stop, updateStatus), `AttendanceTaskHandler` (1s repeat, notification updates, main isolate communication), top-level `attendanceTimerCallback`

**Files modified (9):**

1. `pubspec.yaml` — Added `flutter_foreground_task: ^9.2.1`
2. `android/app/src/main/AndroidManifest.xml` — Permissions and foreground service declaration
3. `ios/Runner/Info.plist` — Background modes and task scheduler IDs
4. `ios/Runner/AppDelegate.swift` — Plugin registrant callback for background isolate
5. `ios/Runner/Runner-Bridging-Header.h` — FlutterForegroundTaskPlugin import
6. `lib/main.dart` — `FlutterForegroundTask.initCommunicationPort()` before `runApp`
7. `lib/injection_container.dart` — Register `AttendanceTimerService`, inject into `AttendanceBloc`
8. `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — `timerService` field, `_syncTimerService()` called on load/check-in/check-out/status-update
9. `lib/features/attendance/presentation/pages/attendance_page.dart` — Replaced `Timer.periodic` with `FlutterForegroundTask.addTaskDataCallback`

**Key decisions:**

- Used `dataSync` foreground service type (Android 14+ requirement)
- 1-second repeat interval for real-time notification updates
- Two-way communication: service sends elapsed seconds to main isolate, main isolate sends status label updates to service
- Notification visibility set to `VISIBILITY_PUBLIC` for lock screen display
- Battery optimization exemption requested for reliable background operation

---

## March 13, 2026 — Home Screen UX/UI Refactor

**Status:** ✅ Complete

**What changed:**

Refactored the home screen from a static placeholder into a live, data-driven dashboard. The home page now surfaces real-time data from ProfileBloc, AttendanceBloc, and KpiBloc. Added a time-based greeting, live attendance clock with check-in/out, quick actions grid, stats summary, recent KPI entries, and recent attendance records. Extracted all sections into dedicated widget files for maintainability.

**Files created (6):**

1. `lib/features/home/presentation/widgets/home_greeting_header.dart` — Time-based greeting header with avatar and name
2. `lib/features/home/presentation/widgets/home_attendance_card.dart` — Live attendance status card with timer and check in/out
3. `lib/features/home/presentation/widgets/home_quick_actions.dart` — 4-item quick action grid
4. `lib/features/home/presentation/widgets/home_stats_row.dart` — 3-stat summary row (profile %, KPI count, worked today)
5. `lib/features/home/presentation/widgets/home_recent_kpis.dart` — Last 3 KPI entries with See All
6. `lib/features/home/presentation/widgets/home_recent_attendance.dart` — Last 3 attendance records with See All

**Files modified (6):**

1. `lib/features/home/presentation/pages/home_page.dart` — Rewritten to compose new widget sections with multi-BLoC pull-to-refresh
2. `lib/features/home/presentation/pages/main_shell.dart` — Added AttendanceBloc and KpiBloc preloading on shell mount
3. `lib/l10n/arb/app_en.arb` — Added 15 new l10n keys for home screen
4. `lib/l10n/arb/app_ar.arb` — Added 15 new l10n keys (Arabic translations)
5. `CHANGELOG.md` — Added home screen refactor entry
6. `tech_readme_files/01_folder_structure.md` — Updated home feature folder structure

**Key decisions:**

- No new data layer or API calls needed — all data sourced from existing BLoCs provided at app level
- Attendance timer uses StatefulWidget with Timer.periodic for live second-by-second updates
- Pull-to-refresh uses Completer pattern for AttendanceBloc and KpiBloc, stream listener for ProfileBloc
- Widget extraction follows one-file-per-section pattern for readability

---

## March 13, 2026 — Jobs Feature Removal

**Status:** ✅ Complete

**What changed:**

Completely removed the jobs feature from the app. This includes the entire `lib/features/jobs/` directory (37 files across jobs_list, job_details, job_search, and saved_jobs sub-features), along with all references throughout the codebase.

**Files deleted (37):**

- Entire `lib/features/jobs/` directory — jobs_list, job_details, job_search, saved_jobs sub-features with all BLoCs, use cases, datasources, repositories, models, entities, pages, and widgets.

**Files modified (12):**

1. `lib/injection_container.dart` — Removed jobs imports, `_initJobs()` call and function body
2. `lib/app.dart` — Removed `JobsListBloc`, `JobDetailsBloc`, `JobSearchBloc`, `SavedJobsBloc` providers and imports
3. `lib/config/routes/app_router.dart` — Removed `/jobs`, `/jobs/:id`, `/job-search`, `/saved-jobs` routes and imports
4. `lib/config/routes/route_names.dart` — Removed `jobs`, `jobDetails`, `jobSearch`, `savedJobs` constants
5. `lib/features/home/presentation/pages/main_shell.dart` — Removed Jobs tab from bottom navigation, re-indexed remaining tabs
6. `lib/features/home/presentation/pages/home_page.dart` — Removed recent jobs section, search jobs and saved jobs quick actions, job-related stats; replaced with KPIs and Attendance quick actions
7. `lib/core/api/api_endpoints.dart` — Removed `jobs`, `jobDetail()`, `jobApply()`, `jobSearch` endpoints
8. `lib/core/constants/storage_keys.dart` — Removed `savedJobs` key
9. `lib/l10n/arb/app_en.arb` — Removed 14 job-specific l10n keys
10. `lib/l10n/arb/app_ar.arb` — Removed 14 job-specific l10n keys (Arabic)
11. `lib/features/settings/presentation/widgets/app_info_dialog.dart` — Removed job-related changelog entries
12. `CHANGELOG.md` — Added "Removed" section, cleaned job references from historical entries

**Key decisions:**

- Kept `jobType` and related profile field keys (used by profile/experience feature, not the jobs feature)
- Kept `enterJobTitle` l10n key (used by edit_personal_form.dart in profile feature)
- Bottom navigation re-indexed from 5 tabs (Home, Jobs, KPIs, Attendance, Settings) to 4 tabs (Home, KPIs, Attendance, Settings)
- Home page quick actions replaced jobs shortcuts with KPIs and Attendance links

---

## March 13, 2026 — Cache Immediate Emit Fix

**Status:** ✅ Complete

**What changed:**

All cached BLoCs (Attendance, KPI, Jobs List) now emit the cached state immediately when `_onLoad` is called, instead of just skipping the loading state. This eliminates the brief blank screen or skeleton flash that occurred when cache existed but the API call was in progress. The pattern is now consistent: cached data is shown instantly, then either replaced by fresh API data or overlaid with an `OfflineBanner` on failure.

**Files modified (3):**

1. `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — emit `_cachedState` instead of no-op
2. `lib/features/kpi/presentation/bloc/kpi_bloc.dart` — emit `_cachedState` instead of no-op
3. `lib/features/jobs/jobs_list/presentation/bloc/jobs_list_bloc.dart` — emit `_cachedState` instead of no-op

---

## March 13, 2026 — Offline Cache for KPI, Profile & Jobs List

**Status:** ✅ Complete

**What changed:**

Extended the offline-first cache pattern (previously attendance-only) to KPI, Profile, and Jobs List features. Each now persists its last successful API data to SharedPreferences via a dedicated local data source, restores on app restart, and shows an `OfflineBanner` with cached data when the network fails. Also fixed the `stream.firstWhere` refresh bug in KPI and the fire-and-forget refresh in Jobs List.

**Files created (3):**

1. `lib/features/kpi/data/datasources/kpi_local_datasource.dart` — `KpiLocalDataSource`, `KpiCacheSnapshot`, `KpiLocalDataSourceImpl`
2. `lib/features/profile/shared/data/datasources/profile_local_datasource.dart` — `ProfileLocalDataSource`, `ProfileCacheSnapshot`, `ProfileLocalDataSourceImpl`
3. `lib/features/jobs/jobs_list/data/datasources/jobs_list_local_datasource.dart` — `JobsListLocalDataSource`, `JobsListCacheSnapshot`, `JobsListLocalDataSourceImpl`

**Files modified (15):**

1. `lib/features/kpi/data/models/kpi_model.dart` — Added `toJson()` to `KpiDefinitionModel`, `KpiEntryModel`, `KpiNoteModel`
2. `lib/features/kpi/presentation/bloc/kpi_bloc.dart` — Added `localDataSource`, `_restoreCache()`, `_persistCache()`, `onChange()`, offline fallback in `_onLoad`
3. `lib/features/kpi/presentation/bloc/kpi_state.dart` — Added `offlineMessage` to `KpiLoaded`
4. `lib/features/kpi/presentation/bloc/kpi_event.dart` — Added `Completer` to `KpiLoadRequested`
5. `lib/features/kpi/presentation/pages/kpi_page.dart` — Added `OfflineBanner`, fixed `_refresh()` with `Completer`
6. `lib/features/profile/shared/data/models/profile_model.dart` — Added `toJson()` to 8 models, updated `ProfileModel.toJson()` to include all fields
7. `lib/features/profile/profile_view/presentation/bloc/profile_bloc.dart` — Added `localDataSource`, `_restoreCache()`, `_persistProfileCache()`, `onChange()`, offline fallback, cache clear on reset
8. `lib/features/profile/profile_view/presentation/bloc/profile_state.dart` — Added `offlineMessage` to `ProfileLoaded`
9. `lib/features/profile/profile_view/presentation/pages/profile_page.dart` — Added `OfflineBanner`
10. `lib/features/jobs/shared/data/models/job_model.dart` — Added `toJson()` to `JobModel`
11. `lib/features/jobs/jobs_list/presentation/bloc/jobs_list_bloc.dart` — Added `localDataSource`, `_restoreCache()`, `_persistCache()`, `onChange()`, offline fallback
12. `lib/features/jobs/jobs_list/presentation/bloc/jobs_list_state.dart` — Added `offlineMessage` to `JobsListLoaded`
13. `lib/features/jobs/jobs_list/presentation/bloc/jobs_list_event.dart` — Added `Completer` to `JobsListLoadRequested`
14. `lib/features/jobs/jobs_list/presentation/pages/jobs_page.dart` — Added `OfflineBanner`, fixed refresh with `Completer`, migrated to `CustomScrollView`
15. `lib/injection_container.dart` — Registered `KpiLocalDataSource`, `ProfileLocalDataSource`, `JobsListLocalDataSource`; wired into their respective BLoCs
16. `lib/core/api/api_response.dart` — Added `PaginationMeta.toJson()`

**Key decisions:**

- Used SharedPreferences for cache storage (consistent with existing attendance pattern)
- Cache only persists on `KpiLoaded`/`ProfileLoaded`/`JobsListLoaded` states that are NOT action-loading and NOT offline-fallback states
- Profile cache clears on `ProfileResetRequested` (logout) to prevent stale data for different users
- Jobs List caches the most recent page of results; pagination state is preserved

---

## March 13, 2026 — Reusable OfflineBanner Shared Widget

**Status:** ✅ Complete

**What changed:**

Extracted the attendance offline banner into a reusable shared widget (`OfflineBanner`) and improved UX: the retry button now shows a loading spinner while the async retry callback runs. The widget accepts a `Future<void> Function()` callback, customisable icon, and accent color.

**Files created (1):**

1. `lib/shared/widgets/banners/offline_banner.dart` — `OfflineBanner` (StatefulWidget with loading state), `_RetryButton` (swaps between text button and spinner)

**Files modified (1):**

1. `lib/features/attendance/presentation/pages/attendance_page.dart` — Replaced private `_OfflineBanner` with shared `OfflineBanner`, uses `Completer` for the async `onRetry`

---

## March 13, 2026 — Attendance Persistent Cache for Offline-First UX

**Status:** ✅ Complete

**What changed:**

The attendance in-memory cache (`_cachedState`) is now persisted to SharedPreferences so it survives app restarts and hot restarts. Previously, restarting the app while offline showed a full-screen "No internet connection" error even though the user had data in a previous session. Now the BLoC restores the cache on creation, enabling the offline banner + cached data flow from the very first load.

**Files created (1):**

1. `lib/features/attendance/data/datasources/attendance_local_datasource.dart` — `AttendanceLocalDataSource` abstraction + `AttendanceLocalDataSourceImpl` (SharedPreferences), `AttendanceCacheSnapshot` (groups statuses + current + schedule with JSON serialization)

**Files modified (3):**

1. `lib/features/attendance/data/models/attendance_model.dart` — Added `toJson()` methods to `AttendanceStatusModel`, `AttendanceCurrentModel`, `AttendanceScheduleModel`
2. `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — Accepts `AttendanceLocalDataSource`, calls `_restoreCache()` in constructor, persists in `onChange` (only on settled, non-offline states)
3. `lib/injection_container.dart` — Registered `AttendanceLocalDataSource` as lazy singleton, injected into `AttendanceBloc`

**Key decisions:**

- Cache is written only when the state is settled (`!isActionLoading && offlineMessage == null`) to avoid persisting partial/error states
- Persistence is fire-and-forget — `_persistCache` doesn't block the UI
- Restored cache goes into `_cachedState` only; it's not emitted as a state directly — the first `_onLoad` uses it as fallback

---

## March 13, 2026 — Attendance Offline UX: Show Cached Data with Banner

**Status:** ✅ Complete

**What changed:**

Improved offline experience for the attendance page. Previously, when the network failed, the entire page was replaced with a full-screen "No internet connection" error — even when the BLoC already had cached data from a previous successful load. Now, when cached data exists and a refresh fails, the page shows the cached content with a compact warning banner at the top containing a wifi-off icon, the error message, and a retry button. Full-screen error is still shown when no cached data is available (first load).

**Files modified (3):**

1. `lib/features/attendance/presentation/bloc/attendance_state.dart` — Added `offlineMessage` field to `AttendanceLoaded` state (nullable, preserved by `copyWith`)
2. `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — Updated `_onLoad` error path: when `_cachedState` exists, emits cached state with `offlineMessage` instead of silently returning
3. `lib/features/attendance/presentation/pages/attendance_page.dart` — Added `_OfflineBanner` private widget; shown at the top of the scrollable content when `state.offlineMessage` is non-null

**Key decisions:**

- `offlineMessage` uses `?? this.offlineMessage` in `copyWith` to survive action operations (check-in/out), and is cleared automatically on successful `_onLoad` (new instance defaults to null)
- Banner uses `AppColors.warning` to differentiate from action errors (which use snackbar via `actionMessage`)
- Full-screen error remains for the first-ever load (no cache to fall back on)

---

## March 13, 2026 — Fix Attendance Pull-to-Refresh Stuck in Loading

**Status:** ✅ Complete

**What changed:**

Fixed a bug where pulling to refresh on the attendance page caused the loading spinner to hang forever. The root cause was `RefreshIndicator.onRefresh` using `stream.firstWhere(...)` to detect load completion; when the refreshed data was identical to the current state, flutter_bloc's Equatable deduplication silently dropped the emission, so the future never resolved. Replaced with a `Completer<void>`-based approach that the BLoC completes in a `try/finally` block.

**Files modified (3):**

1. `lib/features/attendance/presentation/bloc/attendance_event.dart` — Added optional `Completer<void>? completer` field to `AttendanceLoadRequested`
2. `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — Wrapped `_onLoad` body in `try/finally` to complete the completer on all code paths
3. `lib/features/attendance/presentation/pages/attendance_page.dart` — Replaced `stream.firstWhere(...)` in `onRefresh` with `Completer.future`

**Key decisions:**

- Completer is excluded from Equatable `props` (inherited empty list) so event deduplication is unaffected
- `try/finally` ensures the completer completes even on early-return error paths
- `const AttendanceLoadRequested()` still works for non-refresh callers (completer defaults to null)

---

## March 12, 2026 — Attendance Schedule Filter + Shared Filter Widgets

**Status:** ✅ Complete

**What changed:**

Added a filter feature to the attendance screen, matching the KPI screen pattern. Extracted reusable filter components into `shared/widgets/filters/`. KPI screen was refactored to use the shared widgets.

**Files created (4):**

1. `lib/shared/widgets/filters/app_date_filter.dart` — Shared locale-aware date filter bar (extracted from KpiDateFilter)
2. `lib/shared/widgets/filters/filter_sheet_actions.dart` — Shared Clear / Apply button row for filter bottom sheets
3. `lib/shared/widgets/filters/filter_icon_button.dart` — Shared filter icon with badge indicator (used by KPI and Attendance)
4. `lib/features/attendance/presentation/widgets/attendance_filter_sheet.dart` — Attendance-specific filter sheet (status + sort)

**Files modified (6):**

1. `lib/features/attendance/domain/entities/attendance_entity.dart` — Added `AttendanceSortOption` enum + `AttendanceFilterEntity`
2. `lib/features/attendance/presentation/pages/attendance_page.dart` — Filter icon uses `FilterIconButton`, date filter bar, `_applyFilters()` for client-side filtering/sorting, `_openFilterSheet()`
3. `lib/features/attendance/presentation/widgets/attendance_schedule_section.dart` — Added `hasActiveFilters` param + filter-aware empty state
4. `lib/features/kpi/presentation/pages/kpi_page.dart` — Filter icon uses `FilterIconButton`, imports `AppDateFilter` directly
5. `lib/features/kpi/presentation/widgets/kpi_date_filter.dart` — Now a re-export of `AppDateFilter` (backward-compat)
6. `lib/features/kpi/presentation/widgets/kpi_filter_sheet.dart` — Uses `FilterSheetActions` instead of duplicate button row

**l10n keys added:** `longestDuration`, `shortestDuration`, `allStatuses`, `attendanceStatus`, `noScheduleForFilter` (EN + AR)

**Key decisions:**

- Client-side filtering (no API changes needed); matches KPI pattern
- `AttendanceSortOption` is feature-specific (`longestDuration`/`shortestDuration` vs KPI's `highestValue`/`lowestValue`)
- `KpiDateFilter` kept as a re-export for zero-diff compatibility

---

## March 12, 2026 — Timer Ring UX/UI Overhaul

**Status:** ✅ Complete

**What changed:**

Redesigned the attendance timer ring for clarity. Changed from 12h modulo to 24h clamped so progress matches expectations (15h ≈ 63% full, not wrapping). Ring now syncs with the live-ticking digits via `displaySeconds` parameter instead of frozen backend value. Added gradient arc (fades from light to solid), glow dot at the progress tip, tick marks at 6h intervals, "/ 24h" label, and 220px size.

**Files modified (3):**

1. `lib/features/attendance/presentation/widgets/attendance_timer_card.dart` — New `displaySeconds` param, 24h clamp, rewritten `_TimerRingPainter` with gradient/glow/ticks
2. `lib/features/attendance/presentation/pages/attendance_page.dart` — Pass `displaySeconds` to timer card
3. `lib/features/attendance/presentation/widgets/attendance_page_skeleton.dart` — Updated skeleton circle to 220px

---

## March 12, 2026 — Attendance Localization Fix

**Status:** ✅ Complete

**What changed:**

Fixed localization across the attendance feature. "Today" was hardcoded in English in the timer card date display — now uses `context.l10n.today`. `DateFormat` calls now pass the device locale so month names, weekday names, and time formatting render correctly in Arabic. Schedule entry status labels now use l10n keys (`statusAvailable`, `statusBusy`, etc.) instead of raw English enum strings like `eating_meal`. Schedule entry dates now formatted the same way as the timer card ("Today, Mar 12" / "Wed, Mar 11").

**Files modified (4):**

1. `lib/features/attendance/presentation/widgets/attendance_timer_card.dart` — `_formatDate` and `_formatStartTime` now accept locale, use `context.l10n.today` instead of hardcoded "Today"
2. `lib/features/attendance/presentation/widgets/attendance_schedule_section.dart` — Added `_formatWorkDate` (locale-aware), `_localizedStatus` (l10n status labels), `intl` import
3. `lib/l10n/arb/app_en.arb` — Added `today` key
4. `lib/l10n/arb/app_ar.arb` — Added `today` key (اليوم)

---

## March 12, 2026 — Attendance Date/Time Display Improvement

**Status:** ✅ Complete

**What changed:**

Improved the date & start time display in `AttendanceTimerCard`. Raw server strings like `2026-03-12 • 2026-03-12 01:26:01` are now formatted as "Today, Mar 12" + "Started at 1:26 AM". Uses `intl` DateFormat for locale-aware parsing. Added `startedAt(time)` parameterised l10n key to both EN and AR ARB files. Extracted the display into a dedicated `_DateTimeRow` private widget.

**Files modified (3):**

1. `lib/features/attendance/presentation/widgets/attendance_timer_card.dart` — Added `intl` import, replaced inline Row with `_DateTimeRow` widget that formats date/time with `DateFormat`
2. `lib/l10n/arb/app_en.arb` — Added `startedAt` key with `{time}` placeholder
3. `lib/l10n/arb/app_ar.arb` — Added `startedAt` key with `{time}` placeholder

**Key decisions:**

- Date: "Today, Mar 12" when date matches today, otherwise "Wed, Mar 11" with weekday prefix
- Start time: Extracted time from full datetime string (`1:26 AM` format via `DateFormat.jm()`)
- Graceful fallback to raw string if parsing fails

---

## March 12, 2026 — Attendance In-Memory Caching

**Status:** ✅ Complete

**What changed:**

Added in-memory caching to `AttendanceBloc` using the same `_cachedState` pattern as ProfileBloc. The BLoC now caches the last settled `AttendanceLoaded` state. On subsequent `AttendanceLoadRequested` events (tab switches, pull-to-refresh), cached data is shown instantly — no skeleton flash. Refresh errors are silently absorbed when cached data exists. Cache auto-updates via `onChange` override that saves every `AttendanceLoaded` state where `isActionLoading` is false.

**Files modified (1):**

1. `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — Added `_cachedState` field, `onChange` override for auto-caching, modified `_onLoad` to skip skeleton and suppress errors when cache exists

**Key decisions:**

- In-memory cache only (no SharedPreferences persistence) — attendance data is time-sensitive and should be fresh on cold starts
- Cache is invalidated naturally when BLoC is recreated (e.g., logout/login)
- Only caches settled states (`isActionLoading == false`) to avoid caching intermediate loading states
- Follows the same pattern as Profile's `_cachedState`

---

## March 12, 2026 — Attendance Backend Endpoint Audit & BLoC Bug Fix

**Status:** ✅ Complete

**What changed:**

Full audit of all 6 attendance backend endpoints against the Flutter app's data layer, DI, and BLoC wiring. Confirmed all endpoints are connected 1:1 (statuses, current, check-in, status/update, check-out, Schedule). Found and fixed a critical async emit bug in `_onCheckIn` and `_onCheckOut` — they used `async` callbacks inside `result.fold()`, causing the inner `Future` to not be awaited and the `emit()` to fire after the handler completed (silently lost state update, stuck loading indicator). Replaced with explicit `isLeft()`/`getOrElse()` pattern.

**Files modified (1):**

1. `lib/features/attendance/presentation/bloc/attendance_bloc.dart` — Replaced `result.fold()` with async-safe `isLeft()`/`getOrElse()` in `_onCheckIn` and `_onCheckOut` handlers

**Key decisions:**

- `_onUpdateStatus` still uses `fold()` safely since its callbacks are synchronous (no `await` inside)
- Schedule refresh after check-in/out is sequential (1 extra request) — acceptable for data consistency
- Parallel `Future.wait` on initial load already optimal (statuses + current + schedule)

---

## March 12, 2026 — Attendance UX/UI Improvements

**Status:** ✅ Complete

**What changed:**

Significant visual overhaul of the attendance page widgets. Timer card replaced with a circular progress ring using `CustomPaint` (12-hour arc, status-coloured). Status chips now have per-status leading icons and colour coding. Schedule entry cards upgraded to KPI-style icon containers with tinted duration badges. Added `AttendancePageSkeleton` using `Skeletonizer` for the loading state. Replaced generic l10n strings with proper attendance-specific keys. Used `EmptyStateWidget` for empty schedule state.

**Files created (1):**

1. `lib/features/attendance/presentation/widgets/attendance_page_skeleton.dart` — `AttendancePageSkeleton` + `_ScheduleCardSkeleton` using `Skeletonizer` / `Bone` elements

**Files modified (4):**

1. `lib/features/attendance/presentation/widgets/attendance_timer_card.dart` — Circular ring via `_TimerRingPainter`, status-coloured pill, date/time row with icons, uses `clockedIn`/`clockedOut` l10n
2. `lib/features/attendance/presentation/widgets/attendance_status_selector.dart` — Per-status icons/colours on chips, uses `updateStatus` l10n
3. `lib/features/attendance/presentation/widgets/attendance_schedule_section.dart` — Icon containers, tinted duration badge, `EmptyStateWidget`, `scheduleHistory` l10n, count badge
4. `lib/features/attendance/presentation/pages/attendance_page.dart` — Uses skeleton loader, added `Divider` separator, increased spacing

**Key decisions:**

- Circular ring uses 12-hour max for progress arc (wraps after 12h)
- Timer uses `FontFeature.tabularFigures()` to prevent digit jitter
- Status colour mapping centralised per widget (timer card, selector, schedule) — each only maps the statuses it needs
- Removed `AppCard` wrapper from timer card since the ring-centered layout looks better without card borders

---

## March 12, 2026 — Attendance Page Widget Extraction

**Status:** ✅ Complete

**What changed:**

Refactored the monolithic `attendance_page.dart` (~470 lines) into 4 focused, single-responsibility widget files under `lib/features/attendance/presentation/widgets/`. The page now serves as a thin orchestrator (~140 lines) containing only timer logic and BlocConsumer composition. Each extracted widget is self-contained with its own imports and styling.

**Files created (4):**

1. `lib/features/attendance/presentation/widgets/attendance_timer_card.dart` — `AttendanceTimerCard` + `_StatusPill` — timer display card with status indicator, elapsed time, date & start time
2. `lib/features/attendance/presentation/widgets/attendance_status_selector.dart` — `AttendanceStatusSelector` + `_StatusChip` — animated status chip selector with wrap layout
3. `lib/features/attendance/presentation/widgets/attendance_action_button.dart` — `AttendanceActionButton` — check in/out button with loading, outlined/filled states
4. `lib/features/attendance/presentation/widgets/attendance_schedule_section.dart` — `AttendanceScheduleSection` + `_ScheduleEntryCard` — schedule history list with status colours and formatted durations

**Files modified (1):**

1. `lib/features/attendance/presentation/pages/attendance_page.dart` — Removed all inline `_build*` methods and private widget classes, replaced with imported widget composition

**Key decisions:**

- Timer logic (`Timer`, `_localElapsed`, `_formatDuration`) stays in the page since it requires `StatefulWidget` lifecycle
- Formatted duration string is passed to `AttendanceTimerCard` as a parameter rather than exposing timer internals
- `_StatusChip` and `_ScheduleEntryCard` kept as private widgets within their respective files (not reused elsewhere)
- Status colour mapping stays in `_ScheduleEntryCard` as a static method (only used there and in the card)

---

## March 12, 2026 — KPI Entry Card UX Refactor

**Status:** ✅ Complete

**What changed:**

Redesigned the `KpiEntryCard` widget for better visual hierarchy and UX. Added a colored leading icon container (bar chart icon in primary tint), split into a two-row layout (header row with icon + title + overflow menu, then value badge + formatted date chip row). Replaced always-visible red delete icon with a three-dot `PopupMenuButton`. Dates are now locale-formatted via `DateFormat.yMMMd`. Notes use a chat-bubble icon instead of note icon. Updated `_KpiEntryCardSkeleton` to match the new card structure.

**Files modified (2):**

1. `lib/features/kpi/presentation/widgets/kpi_entry_card.dart` — Full card redesign: leading icon, two-row layout, popup menu delete, formatted date chip, chat-bubble notes
2. `lib/features/kpi/presentation/widgets/kpi_page_skeleton.dart` — Updated `_KpiEntryCardSkeleton` to match new card structure (icon box + title row, value + date row, notes)

**Key decisions:**

- Leading icon uses `bar_chart_rounded` with primary color tint matching the value badge
- Delete action moved to popup menu to reduce visual noise (matches modern patterns)
- Date formatted with `intl` `DateFormat.yMMMd` for locale awareness
- Card padding managed internally (AppCard `padding: EdgeInsets.zero`) for finer control over section spacing

---

## March 12, 2026 — KPI Filter: Sort Options + Restore Date Picker

**Status:** ✅ Complete

**What changed:**

Merged master into feature/kpi branch. Restored the `KpiDateFilter` date picker widget to the KPI page body (was previously removed in favour of date range in filter sheet). Moved date-range selection back to the date picker and replaced it in the filter sheet with sort-by options. Added `KpiSortOption` enum with 5 sort modes (Default, Newest First, Oldest First, Highest Value, Lowest Value).

**Files modified (7):**

1. `lib/features/kpi/domain/entities/kpi_entity.dart` — Added `KpiSortOption` enum, added `sortBy` field to `KpiFilterEntity`
2. `lib/features/kpi/presentation/widgets/kpi_filter_sheet.dart` — Removed date range pickers, added sort-by dropdown
3. `lib/features/kpi/presentation/bloc/kpi_bloc.dart` — Added `_sortEntries()` method, applied sorting in `_onFilterUpdated`
4. `lib/features/kpi/presentation/pages/kpi_page.dart` — Restored `KpiDateFilter` widget, added `_pickFilterDate` / `_clearDateFilter` / `_applyCurrentFilter` methods
5. `lib/l10n/arb/app_en.arb` — Added `sortBy`, `newestFirst`, `oldestFirst`, `highestValue`, `lowestValue`, `defaultSort` keys
6. `lib/l10n/arb/app_ar.arb` — Added Arabic translations for sort keys
7. `CHANGELOG.md` — Updated KPI feature changelog entry

**Key decisions:**

- Date picker lives on the page (quick single-date selection), filter sheet handles definition + sort
- Sort is applied client-side after server fetch + definition filter
- Date picker date is synced into `KpiFilterEntity.dateFrom/dateTo` for consistent BLoC flow

---

## March 12, 2026 — KPI Filter Sheet (Like Jobs)

**Status:** ✅ Complete

**What changed:**

Added a filter bottom sheet to the KPI screen, following the same pattern as the Jobs filter. The old single-date filter row (`KpiDateFilter`) was replaced with a filter icon button in the app bar that opens a `KpiFilterSheet` bottom sheet with a KPI definition dropdown and date range (from/to) pickers. A red badge on the filter icon indicates active filters.

**Files created (1):**

- `lib/features/kpi/presentation/widgets/kpi_filter_sheet.dart` — Filter bottom sheet widget with definition dropdown and date range pickers

**Files modified (7):**

1. `lib/features/kpi/domain/entities/kpi_entity.dart` — Added `KpiFilterEntity` class with `hasActiveFilters` getter and `copyWith()`
2. `lib/features/kpi/presentation/bloc/kpi_event.dart` — Added `KpiFilterUpdated` event
3. `lib/features/kpi/presentation/bloc/kpi_state.dart` — Added `filter` field to `KpiLoaded` state
4. `lib/features/kpi/presentation/bloc/kpi_bloc.dart` — Added `_onFilterUpdated` handler with server date-range + client-side definition filtering
5. `lib/features/kpi/presentation/pages/kpi_page.dart` — Replaced date filter row with filter icon button + badge in app bar, integrated `KpiFilterSheet`
6. `lib/l10n/arb/app_en.arb` — Added `noKpiEntriesForFilter`, `allDefinitions` keys
7. `lib/l10n/arb/app_ar.arb` — Added Arabic translations for new keys

**Key decisions:**

- Definition filtering is client-side (backend only supports `from`/`to` date params)
- Date range validation ensures `dateFrom <= dateTo`
- Filter state is persisted in `KpiLoaded` BLoC state and restored when re-opening the sheet
- Empty state message changes based on whether filters are active

---

## March 12, 2026 — Settings Screen Restructure

**Status:** ✅ Complete

**What changed:**

Removed the "Support & Feedback" section entirely. Moved "Help & Support" into the Contact Us section (replacing the plain email tile). Moved "Rate App" into the About section with real `in_app_review` native integration. Removed Notification Settings tile.

**Files deleted (1):**

- `lib/features/settings/presentation/widgets/settings_general_section.dart`

**Files modified (3):**

1. `lib/features/settings/presentation/pages/settings_page.dart` — Removed `SettingsGeneralSection` import and widget from page layout
2. `lib/features/settings/presentation/widgets/settings_contact_section.dart` — Replaced email tile with "Help & Support" tile (mailto with subject)
3. `lib/features/settings/presentation/widgets/settings_about_section.dart` — Added "Rate App" tile with `in_app_review` package integration

**Dependencies added:**

- `in_app_review` — Native in-app review dialog (Play Store / App Store)

---

## March 12, 2026 — Bottom Sheet Selection UX/UI Improvement

**Status:** ✅ Complete

**What changed:**

Improved the selectable option UX in `AppBottomSheet` by introducing a dedicated `BottomSheetOption` widget with animated selection state (highlighted background, border accent, scale-animated check circle) and a new `showOptions<T>()` convenience method. Migrated all Settings bottom sheets (theme, language, contact) to use the new API.

**Files modified (4):**

1. `lib/shared/widgets/dialogs/app_bottom_sheet.dart` — Added `BottomSheetOptionItem<T>` data class, `BottomSheetOption<T>` widget, and `AppBottomSheet.showOptions<T>()` static method
2. `lib/features/settings/presentation/widgets/settings_theme_section.dart` — Replaced inline ListTile pattern with `showOptions<ThemeMode>()`
3. `lib/features/settings/presentation/widgets/settings_language_section.dart` — Replaced inline ListTile pattern with `showOptions<Locale>()`
4. `lib/features/settings/presentation/widgets/settings_contact_section.dart` — Replaced inline ListTile pattern with `showOptions<String>()`

**Key decisions:**

- `BottomSheetOption` uses `AnimatedContainer` for background/border transitions and `AnimatedScale` with `easeOutBack` curve for the check indicator
- Selected state uses primary color at 8% opacity (light) / 15% opacity (dark) for background, with a primary-tinted border
- Check indicator is a filled primary circle with white checkmark, scaling from 0→1 on selection
- Unused `AppTextStyles` imports removed from settings files

---

## March 11, 2026 — Version Bump, CHANGELOG, Current Status & Documentation Overhaul

**Status:** ✅ Complete
**Branch:** `feature/settings`

**What changed:**

Reviewed full git history (80+ commits across 8 branches, 3 merged PRs), determined semantic version bump, and created/updated all project documentation to reflect the current state of the codebase.

**Files created (4):**

- `CHANGELOG.md` — Comprehensive changelog with v1.0.0 (2026-02-17) and v1.1.0 (2026-03-11) entries, following Keep a Changelog format. Covers KPI feature, jobs/profile sub-feature refactors, full settings screen, shared widgets, localization (~175 new keys), and all bug fixes.
- `tech_readme_files/09_api_endpoints.md` — Complete API endpoint reference with all 50+ endpoints organized by feature (Auth, Jobs, Profile, KPI, Attendance, Lookups, Essential Info, Dashboard)
- `tech_readme_files/CURRENT_STATUS.md` — Full project status document with metrics, feature details, architecture overview, design tokens, tech stack, branch status, and planned features
- `tech_readme_files/DOCUMENTATION_UPDATE_SUMMARY.md` — This file

**Files updated (2):**

1. `pubspec.yaml` — Version bumped from `1.0.0+1` to `1.1.0+2` based on analysis of 3 merged PRs: #31 (jobs refactor), #32 (profile refactor), #33 (KPI) + settings feature work
2. `tech_readme_files/01_folder_structure.md` — Complete rewrite reflecting current codebase: KPI feature files, settings 10-widget extraction, jobs 4-sub-feature split, profile 3-sub-feature split, all shared widgets (dialogs, pdf_viewer, photo_picker, phone field), attendance/essential_info scaffolded, updated route map, ~326 l10n keys
3. `tech_readme_files/07_how_to_create_reusable_component.md` — Updated shared widgets listing to include: `AppBottomSheet`, `UnsavedChangesDialog`, `AppDropdownField`, `AppPhoneField`, `PdfViewerPage`, `PhotoPickerBottomSheet`

---

## March 11, 2026 — Settings Feature: About Us, App Info Dialog, Contact, General

**Status:** ✅ Complete
**Branch:** `feature/settings`
**Commits:** `0e891dc` → `67c0823` (6 commits)

**What changed:**

Built out the complete settings screen with all working sections: privacy/terms links, contact info, support options, account deletion, and a full About Us page with app info dialog.

**Files created (2):**

- `lib/features/settings/presentation/pages/about_us_page.dart` — Full About Us page with company info, mission statement, core values with icons. Dark mode uses `AppImages.logoAlt` (white logo variant).
- `lib/features/settings/presentation/widgets/app_info_dialog.dart` — Branded dialog showing company logo, tagline, commercial registration number, location, and dynamic app version from `package_info_plus`. Static `show()` method for easy invocation. Uses `l10n.aboutCompanyName`, `l10n.companyTagline`, `l10n.commercialRegistration`, `l10n.companyLocation`.

**Files modified (6):**

1. `lib/features/settings/presentation/widgets/settings_about_section.dart` — Added 4 tiles in Material card: About Us (navigates to about page), Privacy Policy (locale-aware URL, in-app browser), Terms & Conditions (locale-aware URL, in-app browser), App Version (shows dynamic version, taps to open `AppInfoDialog`). Uses `PackageInfo.fromPlatform()` for version.
2. `lib/features/settings/presentation/widgets/settings_general_section.dart` — Added 4 tiles: Notification Settings (opens system app notification settings), Help & Support (mailto: <info@technology92.com>), Rate App (opens Play Store listing), Delete Account (confirmation dialog with red styling, triggers logout).
3. `lib/features/settings/presentation/widgets/settings_contact_section.dart` — Contact section with company email (`info@technology92.com`), Riyadh phones (2), Jordan phone. Each tile opens the appropriate URL scheme (mailto:, tel:).
4. `lib/features/settings/presentation/pages/settings_page.dart` — Layout: UserCard → Theme → Language → General → About → Contact → Logout
5. `lib/l10n/arb/app_en.arb` — Added ~40 new keys for settings sections (privacy, terms, about, contact, delete account, company info, app info dialog)
6. `lib/l10n/arb/app_ar.arb` — Matching Arabic translations for all new keys

**Key decisions:**

- Removed `canLaunchUrl()` guard — fails on Android 11+ due to package visibility restrictions. Directly calls `launchUrl()` instead.
- Changed URL launch mode from `LaunchMode.externalApplication` to `LaunchMode.inAppBrowserView` to keep users in the app.
- Used `AppImages.logoAlt` (white) for dark mode in both About Us page and App Info Dialog.
- Dynamic version via `package_info_plus` instead of hardcoded string.

---

## March 11, 2026 — KPI Feature (PR #33)

**Status:** ✅ Complete (Merged to master)
**Branch:** `feature/kpi`
**Commits:** `cbc8924` → `b9ec195` (8 commits)

**What changed:**

Full implementation of the KPI (Key Performance Indicators) feature — browse definitions, CRUD entries, date filtering, skeleton loading, and state caching.

**Files created/modified (15+):**

- `lib/features/kpi/data/datasources/kpi_remote_datasource.dart` — Remote data source with Dio API calls
- `lib/features/kpi/data/models/kpi_model.dart` — KPI definition and entry models with `fromJson`/`toJson`
- `lib/features/kpi/data/repositories/kpi_repository_impl.dart` — Repository implementation
- `lib/features/kpi/domain/entities/kpi_entity.dart` — Domain entities (Equatable)
- `lib/features/kpi/domain/repositories/kpi_repository.dart` — Repository contract
- `lib/features/kpi/domain/usecases/` — 4 use cases: `GetKpiDefinitions`, `GetKpiEntries`, `UpsertKpiEntry`, `DeleteKpiEntry`
- `lib/features/kpi/presentation/bloc/` — `KpiBloc`, `KpiEvent`, `KpiState`
- `lib/features/kpi/presentation/pages/kpi_page.dart` — Main KPI page with cached `_lastLoaded` state for instant UI on re-navigation
- `lib/features/kpi/presentation/widgets/` — 5 widgets: `AddEntrySheet`, `DateFilter`, `DeleteDialog`, `EntryCard`, `PageSkeleton`
- `lib/injection_container.dart` — KPI DI registration (data source, repo, 4 use cases, bloc)
- `lib/config/routes/app_router.dart` — Added KPI route
- `lib/config/routes/route_names.dart` — Added KPI route name constant

---

## March 5–10, 2026 — Profile Sub-Feature Refactor (PR #32)

**Status:** ✅ Complete (Merged to master on March 10)
**Branch:** `feature/profile-sub-features`
**Commits:** `c053582` → `7b3d244` (10 commits)

**What changed:**

Major refactor of the profile feature from flat structure into 3 sub-features with full CRUD, document handling, and session management.

**Files created (30+):**

- **Profile View** (`profile_view/`): 3 use cases (personal, professional, completeness), `ProfileBloc` + events/states, profile page, 9 section cards (personal, professional, education, experience, skills, resume, video, summary, completeness)
- **Edit Profile** (`edit_profile/`): 2 use cases (update personal, update professional), edit profile page, helpers (form data, lookups), 11 edit widgets (personal form/tab, professional form/tab, more tab, education/experience/skills/resume/summary/video sections), 4 CRUD dialogs (add skill, delete confirm, education form, experience form)
- **Shared** (`shared/`): `ProfileRemoteDataSource`, `ProfileModel`, `ProfileRepositoryImpl`, `ProfileEntity`, `ProfileRepository`, 4 common widgets (date helpers, header, info row, section card), 2 skeleton widgets (profile page, edit profile)
- `lib/shared/widgets/pdf_viewer/pdf_viewer_page.dart` — Full-screen PDF viewer with download
- `lib/shared/widgets/photo_picker/photo_picker_bottom_sheet.dart` — Camera/gallery picker bottom sheet
- `lib/shared/widgets/dialogs/unsaved_changes_dialog.dart` — Discard/save confirmation dialog

**Key features added:**

- Profile photo upload with crop support (`image_cropper`)
- Education and experience CRUD with form dialogs
- Skill management (add/delete with confirmation)
- Resume, video, background document upload/removal
- In-memory profile caching with pull-to-refresh invalidation
- Skeleton loading using `skeletonizer`
- Session expiration handling (401 → `AuthSessionExpired` → auto-logout)
- Image reload and reset on logout

---

## March 5, 2026 — Jobs Sub-Feature Refactor & Enhancements (PR #31)

**Status:** ✅ Complete (Merged to master on March 5)
**Branch:** `feature/fix-job-endpoints`
**Commits:** `9febaa1` → `33b842c` (8 commits)

**What changed:**

Fixed job API endpoints, then refactored monolithic `JobsBloc` into 4 per-screen sub-features with skeleton loading, filters, saved jobs, and hero animations.

**Files created (20+):**

- **Jobs List** (`jobs_list/`): `GetJobsUseCase`, `GetLookupsUseCase`, `JobsListBloc` + events/states, jobs page, filter sheet widget
- **Job Details** (`job_details/`): `GetJobDetailsUseCase`, `ApplyToJobUseCase`, `JobDetailsBloc` + events/states, job details page, 6 detail widgets (apply bar, company info, skeleton, header, info chips, section title)
- **Job Search** (`job_search/`): `SearchJobsUseCase`, `JobSearchBloc` + events/states, search page
- **Saved Jobs** (`saved_jobs/`): `SavedJobsBloc` + events/states, saved jobs page
- **Shared** (`shared/`): `JobsRemoteDataSource`, `SavedJobsLocalDataSource`, `JobModel`, `JobsRepositoryImpl`, `JobEntity`, `JobsRepository`, `JobCard`, `JobCardSkeleton`

**Key fixes:**

- Corrected API paths for job detail, apply, and search endpoints
- Preserved jobs list state when navigating back from details
- Updated `flutter_secure_storage` plugin version and imports

---

## February 17, 2026 — Feature Scaffolding (Attendance, KPI, Essential Info, Dashboard)

**Status:** ✅ Scaffolded (folders only)
**Branch:** Separate feature branches (`feature/attendance`, `feature/kpi`, `feature/essential-info`, `feature/dashboard`)

**What changed:**

Created Clean Architecture folder structures for 4 upcoming features. Each scaffold contains empty `data/` (datasources, models, repositories), `domain/` (entities, repositories, usecases), and `presentation/` (bloc/cubit, pages, widgets) directories.

**Scaffolded features:**

- `lib/features/attendance/` — Clock in/out, status management, schedule history
- `lib/features/kpi/` — KPI definitions and entries (later fully implemented in PR #33)
- `lib/features/essential_info/` — AI-extracted profile info
- `lib/features/dashboard/` — Real-time dashboard stats (home page data layer)

---

## February 15–17, 2026 — Initial Release (v1.0.0)

**Status:** ✅ Complete
**Branch:** `master`
**Commits:** `9547112` → `7fdc2f9` (38 commits)

**What changed:**

Full project creation from scratch — architecture setup, 6 feature modules, design system, localization, build scripts, and documentation.

**Core infrastructure created:**

- Clean Architecture with 3 layers per feature (data → domain ← presentation)
- `flutter_bloc` state management with BLoC and Cubit patterns
- `get_it` + `injectable` for DI service locator
- `dio` HTTP client with auth, language, and logger interceptors
- `shared_preferences` + `flutter_secure_storage` for local storage
- `go_router` with shell routes and named route constants
- `flutter_dotenv` for runtime secrets
- `talker` logging with Dio and BLoC observers
- Custom exceptions → failures pipeline with `dartz` Either returns

**Features implemented:**

- **Auth**: Login, Register, Forgot Password, Google Sign-In, Splash, Language Select, Onboarding (6 use cases, AuthBloc)
- **Home**: Main shell with bottom nav, home dashboard page
- **Jobs**: Job list with pagination, job details, search (3 use cases)
- **Profile**: Profile display, edit forms, photo upload (3 use cases)
- **Settings**: Theme toggle, language switcher, logout (SettingsCubit)
- **L10n**: ~155 EN/AR keys, full RTL support

**Design system created:**

- `AppColors` — brand, neutral, semantic, status, social colours
- `AppTextStyles` — Material 3 type scale with PublicSans
- `AppSpacing` — SizedBox and EdgeInsets presets
- `AppRadius` — border radius presets
- Light and dark `ThemeData`

**Shared widgets created (9):**

- `AppButton`, `AppTextField`, `AppCard`, `CustomAppBar`, `EmptyStateWidget`, `AppErrorWidget`, `AppLoading`, `AuthPatternBackground`, `ResponsiveLayout`

**Documentation created (8 files):**

- Folder structure, architecture, feature guide, API guide, language guide, theme guide, widget guide, security guide

**Build scripts created:**

- `scripts/build_release.sh` — obfuscated release build
- `scripts/build_debug.sh` — debug build and run utilities
