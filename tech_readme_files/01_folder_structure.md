# 📁 Folder Structure

> Complete directory map of the `lib/` folder and what every file does.

---

## Top-Level

```
emosense_mobile (Flutter app repository root)/
├── lib/                        ← All Dart source code
├── assets/                     ← Static resources (fonts, icons, images)
├── scripts/                    ← Build scripts (debug & release)
├── test/                       ← Unit & widget tests (29 files, ~365 test cases)
├── tech_readme_files/          ← Project documentation
├── AGENTS.md / CLAUDE.md / CHANGELOG.md  ← Agent instructions & project history (tooling map: AGENTS.md)
├── .agents/, .claude/, .cursor/          ← AI rules, commands, Cursor rules (.cursor/skills/)
├── l10n.yaml                   ← Localisation generator config
├── pubspec.yaml                ← Dependencies & asset registration
└── analysis_options.yaml       ← Lint rules
```

---

## Agent & AI tooling (repository root)

`.agents/`, `.claude/`, `.cursor/`, and assistant-specific `*ignore` files are summarized in **`AGENTS.md`** under **Agent tooling layout (repository root)**. Root **`AGENTS.md`**, **`CLAUDE.md`**, and **`CHANGELOG.md`** are the primary human/agent instruction and history files.

---

## `lib/` — Full Tree

```
lib/
│
├── main.dart                              # App entry point
│                                          # - Inits Firebase, DI, Sentry
│                                          # - Locks orientation to portrait
│                                          # - Configures system UI overlay
│                                          # - Initialises DI (GetIt)
│                                          # - Runs the root widget
│
├── app.dart                               # Root `EmosenseApp` — MaterialApp + `AppRouter.generateRoute`; theme & l10n
│
├── core/
│   ├── di/
│   │   ├── dependency_injection.dart      # GetIt — `initDependencies()`
│   │   └── injection_container.dart       # Barrel re-export (optional)
│   ├── config/
│   │   └── app_config.dart                # Loads environment / bootstrap
│   ├── routing/
│   │   ├── app_router.dart                # Named route constants + `generateRoute`
│   │   └── screen_transitions.dart
│   ├── constants/                         # app_colors (re-export → utils/assets), typography, themes, strings, durations, limits, storage keys …
│   │
│   ├── api/
│   │   ├── api_client.dart                # Dio HTTP client with interceptors (auth, language, logging)
│   │   ├── api_endpoints.dart             # API path constants / methods (see codebase for exact names)
│   │   └── …                              # Response envelopes / helpers as implemented in repo
│   │
│   ├── errors/
│   │   ├── api_exception.dart
│   │   ├── app_error.dart
│   │   └── failures.dart
│   │
│   ├── extensions/
│   │   ├── context_extensions.dart        # BuildContext helpers (theme, l10n, snackbars, screen size)
│   │   └── string_extensions.dart         # capitalize, titleCase, isValidEmail, truncate, initials
│   │
│   ├── usecase/
│   │   └── usecase.dart                   # Abstract UseCase<Type, Params> + NoParams
│   │
│   └── utils/
│       ├── assets/                        # Design tokens: `app_colors.dart`, `app_fonts.dart`, `app_locale_binding.dart` (barrel: `assets.dart`)
│       ├── logger.dart                    # Talker wrapper (auto-disabled in prod), BLoC transition logs
│       └── validators.dart                # Reusable form validators (email, password, phone, name…)
│   │
│   ├── widgets/                           # ── App-wide reusable UI (barrel: `widgets/widgets.dart`; package `package:emosense_mobile/core/widgets/...`)
│   │   └── …                              # e.g. `app_bars/`, `buttons/`, `cards/`, `common/`, `dialogs/`, `forms/`, `sections/`, backend connection helpers
│
├── features/                              # ── Feature modules (Clean Architecture)
│   │
│   ├── shared/                            # ── App-wide shell screens + central routing barrel (`screens.dart`, `common_screens.dart`, `pages/…`)
│   │   └── presentation/
│   │
│   ├── auth/                              # ── Authentication feature (sub-feature pattern)
│   │   ├── shared/                        # Shared data, domain, bloc, widgets for all auth sub-features
│   │   │   ├── data/
│   │   │   │   ├── datasources/
│   │   │   │   │   ├── auth_remote_datasource.dart   # API calls: login, register, logout, forgot/reset password
│   │   │   │   │   └── auth_local_datasource.dart    # Token + user cache (SecureStorage / SharedPrefs)
│   │   │   │   ├── models/
│   │   │   │   │   └── user_model.dart               # UserModel (fromJson / toJson)
│   │   │   │   └── repositories/
│   │   │   │       └── auth_repository_impl.dart     # Orchestrates remote + local, maps exceptions → failures
│   │   │   ├── domain/
│   │   │   │   ├── entities/
│   │   │   │   │   └── user_entity.dart              # UserEntity (Equatable)
│   │   │   │   ├── repositories/
│   │   │   │   │   └── auth_repository.dart          # Abstract contract (no Flutter imports)
│   │   │   │   └── usecases/
│   │   │   │       ├── login_usecase.dart
│   │   │   │       ├── register_usecase.dart
│   │   │   │       ├── logout_usecase.dart
│   │   │   │       ├── forgot_password_usecase.dart
│   │   │   │       ├── google_sign_in_usecase.dart
│   │   │   │       └── get_cached_user_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── auth_event.dart               # Login, Register, Logout, ForgotPassword, CheckAuth, EssentialDataCompleted events
│   │   │       │   ├── auth_state.dart               # Initial, Loading, Authenticated (needsEssentialData), Unauthenticated, Error…
│   │   │       │   └── auth_bloc.dart                # Maps events → use cases → states (checks essential data flag)
│   │   │       └── widgets/
│   │   │           ├── auth_header.dart              # Logo + title + subtitle (contextual per page)
│   │   │           └── social_login_button.dart      # Google / Apple / LinkedIn button (SocialProvider enum)
│   │   ├── splash/presentation/pages/
│   │   │   └── splash_page.dart                      # Animated logo, auto-navigates based on auth state
│   │   ├── language_select/presentation/pages/
│   │   │   └── language_select_page.dart             # Language picker (EN / AR), shown every launch
│   │   ├── onboarding/presentation/
│   │   │   ├── pages/
│   │   │   │   └── onboarding_page.dart              # 3-page carousel with skip / back / next
│   │   │   └── widgets/
│   │   │       ├── onboarding_widgets.dart            # Barrel export
│   │   │       ├── onboarding_data.dart               # OnboardingData model
│   │   │       ├── onboarding_header.dart             # Logo + skip
│   │   │       ├── onboarding_page_content.dart       # Slide content
│   │   │       ├── onboarding_dot_indicator.dart      # Static dots
│   │   │       ├── onboarding_progress.dart           # Dots + page count + swipe hint
│   │   │       └── onboarding_nav_buttons.dart        # Previous / Next
│   │   ├── login/presentation/pages/
│   │   │   └── login_page.dart                       # Email / password form, social login buttons
│   │   ├── register/presentation/pages/
│   │   │   └── register_page.dart                    # 6-field registration form
│   │   ├── forgot_password/presentation/pages/
│   │   │   └── forgot_password_page.dart             # Email submission for password reset
│   │   └── essential_data/                           # ── Essential Data Wizard (full Clean Architecture)
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── essential_data_remote_datasource.dart  # GET/POST essential info with multipart upload
│   │       │   ├── models/
│   │       │   │   └── essential_data_model.dart              # EssentialDataModel (fromJson)
│   │       │   └── repositories/
│   │       │       └── essential_data_repository_impl.dart    # Exception → failure mapping
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── essential_data_entity.dart            # EssentialDataEntity (Equatable)
│   │       │   ├── repositories/
│   │       │   │   └── essential_data_repository.dart        # Abstract contract
│   │       │   └── usecases/
│   │       │       ├── get_essential_data_usecase.dart       # Check if essential data exists
│   │       │       └── submit_essential_data_usecase.dart    # Submit with resume upload
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── essential_data_cubit.dart             # Check + submit logic, local flag management
│   │           │   └── essential_data_state.dart             # Initial, Checking, Exists, Needed, Submitting, Submitted, Error
│   │           ├── pages/
│   │           │   └── essential_data_wizard_page.dart       # 4-step wizard with PageView-like navigation
│   │           └── widgets/
│   │               ├── wizard_step_indicator.dart            # Progress bar + step label
│   │               ├── name_step.dart                        # Step 1: First Name + Last Name
│   │               ├── age_nationality_step.dart             # Step 2: Age + Nationality dropdown
│   │               ├── specialty_phone_step.dart             # Step 3: Specialty + Phone
│   │               └── resume_step.dart                      # Step 4: Resume upload + language toggle
│   │
│   │   └── essential_info/                    # ── Essential Info review (presentation-only, reuses essential_data domain)
│   │       └── presentation/
│   │           ├── cubit/
│   │           │   ├── essential_info_cubit.dart             # Loads data via GetEssentialDataUseCase
│   │           │   └── essential_info_state.dart             # Loading, Loaded, Error
│   │           ├── pages/
│   │           │   └── essential_info_page.dart              # Post-registration review + AI translation banner
│   │           └── widgets/
│   │               └── essential_info_field_row.dart         # Icon + label + value display row
│   │
│   ├── home/                              # ── Home / navigation shell
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── main_shell.dart               # Bottom NavigationBar (Home, KPIs, Attendance, Settings)
│   │       │   └── home_page.dart                # Live dashboard composing widget sections below
│   │       └── widgets/
│   │           ├── home_greeting_header.dart      # Time-based greeting + avatar + name
│   │           ├── home_attendance_card.dart       # Live clock status + timer + check in/out
│   │           ├── home_quick_actions.dart         # 4-item quick action grid (Profile, KPIs, Attendance, Settings)
│   │           ├── home_stats_row.dart             # 3-stat summary (profile %, KPI count, worked today)
│   │           ├── home_recent_kpis.dart           # Last 3 KPI entries with See All
│   │           └── home_recent_attendance.dart     # Last 3 attendance records with See All
│   │
│   ├── analysis/                          # ── Text / video / voice analysis + shared analysis widgets (`analysis/` tree)
│   ├── emotion/                           # ── Analytics & emotion dashboards
│   ├── employee/                          # ── Dashboard, shell navigation, profile, ticketing (employee path), analytics, tools
│   ├── tickets/                           # ── Admin + employee ticket flows
│   ├── admin/                             # ── Admin dashboard & management shells
│   │
│   ├── profile/                           # ── Profile feature (split into sub-features)
│   │   ├── profile_view/                  # Profile viewing sub-feature
│   │   │   ├── domain/usecases/
│   │   │   │   └── get_profile_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── bloc/
│   │   │       │   ├── profile_bloc.dart
│   │   │       │   ├── profile_event.dart
│   │   │       │   └── profile_state.dart
│   │   │       ├── pages/
│   │   │       │   └── profile_page.dart           # Avatar, completeness bar, sections, skills
│   │   │       └── widgets/profile/
│   │   │           ├── profile_completeness_card.dart
│   │   │           ├── profile_education_card.dart
│   │   │           ├── profile_experience_card.dart
│   │   │           ├── profile_personal_card.dart
│   │   │           ├── profile_professional_card.dart
│   │   │           ├── profile_resume_card.dart
│   │   │           ├── profile_skills_card.dart
│   │   │           ├── profile_summary_card.dart
│   │   │           └── profile_video_card.dart
│   │   │
│   │   ├── edit_profile/                  # Profile editing sub-feature
│   │   │   ├── domain/usecases/
│   │   │   │   ├── update_personal_details_usecase.dart
│   │   │   │   └── update_professional_details_usecase.dart
│   │   │   └── presentation/
│   │   │       ├── helpers/
│   │   │       │   ├── edit_profile_form_data.dart   # Form data objects
│   │   │       │   └── edit_profile_lookups.dart     # Lookup data objects
│   │   │       ├── pages/
│   │   │       │   └── edit_profile_page.dart        # Tabbed edit form (personal, professional, more)
│   │   │       └── widgets/
│   │   │           ├── dialogs/
│   │   │           │   ├── add_skill_dialog.dart
│   │   │           │   ├── delete_confirm_dialog.dart
│   │   │           │   ├── education_form_dialog.dart
│   │   │           │   └── experience_form_dialog.dart
│   │   │           └── edit_profile/
│   │   │               ├── edit_education_section.dart
│   │   │               ├── edit_experience_section.dart
│   │   │               ├── edit_more_tab.dart
│   │   │               ├── edit_personal_form.dart
│   │   │               ├── edit_personal_tab.dart
│   │   │               ├── edit_professional_form.dart
│   │   │               ├── edit_professional_tab.dart
│   │   │               ├── edit_resume_section.dart
│   │   │               ├── edit_skills_section.dart
│   │   │               ├── edit_summary_section.dart
│   │   │               └── edit_video_section.dart
│   │   │
│   │   └── shared/                        # Shared across profile sub-features
│   │       ├── data/
│   │       │   ├── datasources/
│   │       │   │   └── profile_remote_datasource.dart  # GET/PUT applicant profile
│   │       │   ├── models/
│   │       │   │   └── profile_model.dart              # ProfileModel, ProfessionalDetailsModel, etc.
│   │       │   └── repositories/
│   │       │       └── profile_repository_impl.dart
│   │       ├── domain/
│   │       │   ├── entities/
│   │       │   │   └── profile_entity.dart             # ProfileEntity, Experience/Education/Skill entities
│   │       │   └── repositories/
│   │       │       └── profile_repository.dart         # Abstract contract
│   │       └── presentation/widgets/
│   │           ├── common/
│   │           │   ├── profile_date_helpers.dart       # Date formatting utilities
│   │           │   ├── profile_header.dart             # Section header widget
│   │           │   ├── profile_info_row.dart           # Label-value info row
│   │           │   └── profile_section_card.dart       # Card wrapper for sections
│   │           └── skeletons/
│   │               ├── edit_profile_skeleton.dart      # Skeleton for edit profile
│   │               └── profile_page_skeleton.dart      # Skeleton for profile page
│   │
│   ├── kpi/                               # ── KPI feature
│   │   ├── data/
│   │   │   ├── datasources/
│   │   │   │   └── kpi_remote_datasource.dart     # GET definitions, GET/POST/PUT/DELETE entries
│   │   │   ├── models/
│   │   │   │   └── kpi_model.dart                 # KpiDefinitionModel, KpiEntryModel (fromJson/toJson)
│   │   │   └── repositories/
│   │   │       └── kpi_repository_impl.dart
│   │   ├── domain/
│   │   │   ├── entities/
│   │   │   │   └── kpi_entity.dart                # KpiDefinitionEntity, KpiEntryEntity (Equatable)
│   │   │   ├── repositories/
│   │   │   │   └── kpi_repository.dart            # Abstract contract
│   │   │   └── usecases/
│   │   │       ├── get_kpi_definitions_usecase.dart
│   │   │       ├── get_kpi_entries_usecase.dart
│   │   │       ├── upsert_kpi_entry_usecase.dart
│   │   │       └── delete_kpi_entry_usecase.dart
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── kpi_bloc.dart                  # Handles load, submit, delete, filter events
│   │       │   ├── kpi_event.dart
│   │       │   └── kpi_state.dart
│   │       ├── pages/
│   │       │   └── kpi_page.dart                  # KPI entries list with date filter, cached state
│   │       └── widgets/
│   │           ├── add_kpi_entry_sheet.dart        # Bottom sheet for add/edit KPI entry
│   │           ├── kpi_date_filter.dart            # Date filter chip row
│   │           ├── kpi_delete_dialog.dart          # Delete confirmation dialog
│   │           ├── kpi_entry_card.dart             # Entry card with value, date, notes
│   │           └── kpi_page_skeleton.dart          # Skeleton loading placeholder
│   │
│   ├── attendance/                        # ── Attendance feature (implemented)
│   │   ├── data/                          # Remote source, models, repository impl
│   │   ├── domain/                        # Entities, repository contract, 5 use cases
│   │   └── presentation/
│   │       ├── bloc/
│   │       │   ├── attendance_bloc.dart            # Manages load, check-in/out, status update, schedule
│   │       │   ├── attendance_event.dart           # Load, RefreshCurrent, CheckIn, StatusUpdate, CheckOut, Schedule
│   │       │   └── attendance_state.dart           # Initial, Loading, Loaded (with copyWith), Error
│   │       ├── pages/
│   │       │   └── attendance_page.dart            # Timer logic + BlocConsumer orchestrator
│   │       └── widgets/
│   │           ├── attendance_timer_card.dart      # Timer display with circular ring + status pill
│   │           ├── attendance_status_selector.dart # Animated status chip selector with icons
│   │           ├── attendance_action_button.dart   # Check in/out button
│   │           ├── attendance_schedule_section.dart # Schedule history list with entry cards
│   │           └── attendance_page_skeleton.dart   # Skeletonizer loading placeholder
│   │
│   │
│   └── settings/                          # ── Settings feature (presentation-only)
│       └── presentation/
│           ├── cubit/
│           │   ├── settings_cubit.dart            # Manages theme mode + locale
│           │   └── settings_state.dart            # ThemeMode, Locale state
│           ├── pages/
│           │   ├── settings_page.dart             # Settings sections (user card, theme, language, general, about, contact, logout)
│           │   └── about_us_page.dart             # Company info, mission, core values
│           └── widgets/
│               ├── common/
│               │   ├── settings_section_header.dart   # Section title label widget
│               │   └── settings_tile.dart             # Reusable settings list tile
│               ├── dialogs/
│               │   ├── app_changelog_data.dart        # VersionEntry / ChangeGroup models + appChangelog data
│               │   └── app_info_dialog.dart           # Branded sheet: logo, company info, version, changelog
│               └── sections/
│                   ├── settings_about_section.dart    # About Us, privacy policy, terms, app version
│                   ├── settings_account_section.dart  # Logout (danger zone)
│                   ├── settings_contact_section.dart  # Website, email, phone numbers
│                   ├── settings_dev_options_section.dart # Admin-only: Talker logs + Sentry test
│                   ├── settings_language_section.dart # EN / AR language toggle
│                   ├── settings_theme_section.dart    # Light / dark / system theme toggle
│                   └── settings_user_card.dart        # User avatar + name + email card
│
└── l10n/                                  # ── Localisation
    ├── arb/
    │   ├── app_en.arb                     # English translations (~330 keys)
    │   └── app_ar.arb                     # Arabic translations (~330 keys)
    └── generated/                         # Auto-generated (flutter gen-l10n)
        ├── app_localizations.dart
        ├── app_localizations_en.dart
        └── app_localizations_ar.dart
```

---

## `test/` — Full Tree

```
test/
├── helpers/
│   └── mocks.dart                              # 37 mock classes (repos, use cases, data sources, services)
│
├── fixtures/
│   ├── auth_fixtures.dart                      # UserEntity, UserModel, login/register JSON samples
│   ├── attendance_fixtures.dart                # Status, current, schedule entities + JSON
│   ├── kpi_fixtures.dart                       # Definition, entry, note entities + JSON
│   └── profile_fixtures.dart                   # Profile, experience, education, skill entities + JSON
│
├── features/
│   ├── auth/
│   │   ├── data/
│   │   │   ├── models/user_model_test.dart           # fromJson/toJson, flat/nested/minimal JSON
│   │   │   └── repositories/auth_repository_impl_test.dart  # Exception→Failure mapping (6 methods)
│   │   ├── domain/
│   │   │   ├── entities/user_entity_test.dart         # fullName, initials, Equatable
│   │   │   └── usecases/auth_usecases_test.dart       # 6 use cases + Params equality
│   │   └── presentation/
│   │       └── bloc/auth_bloc_test.dart               # Login, register, logout, Google, session expiry
│   │
│   ├── attendance/
│   │   ├── data/
│   │   │   ├── models/attendance_model_test.dart      # Status, current, schedule — fromJson/toJson
│   │   │   └── repositories/attendance_repository_impl_test.dart
│   │   ├── domain/
│   │   │   ├── entities/attendance_entity_test.dart   # Equatable, filter hasActiveFilters/copyWith
│   │   │   └── usecases/attendance_usecases_test.dart # 6 use cases + Params equality
│   │   └── presentation/
│   │       └── bloc/attendance_bloc_test.dart          # Load, check-in/out, status, cache, timer
│   │
│   ├── kpi/
│   │   ├── data/
│   │   │   ├── models/kpi_model_test.dart             # Definition, entry, note — fromJson/toJson
│   │   │   └── repositories/kpi_repository_impl_test.dart
│   │   ├── domain/
│   │   │   ├── entities/kpi_entity_test.dart           # displayValue, filter hasActiveFilters/copyWith
│   │   │   └── usecases/kpi_usecases_test.dart         # 4 use cases + Params equality
│   │   └── presentation/
│   │       └── bloc/kpi_bloc_test.dart                 # Load, upsert, delete, filter, pagination
│   │
│   ├── profile/
│   │   ├── data/
│   │   │   ├── models/profile_model_test.dart         # 9 model types — fromJson/toJson/round-trip
│   │   │   └── repositories/profile_repository_impl_test.dart  # 15+ methods
│   │   ├── domain/
│   │   │   ├── entities/profile_entity_test.dart      # fullName combos, 8 sub-entities Equatable
│   │   │   └── usecases/profile_usecases_test.dart    # 5 use cases + Params equality
│   │   └── presentation/
│   │       └── bloc/profile_bloc_test.dart             # Load, update, CRUD, bulk add, upload, reset
│   │
│   └── settings/
│       └── presentation/
│           └── cubit/settings_cubit_test.dart          # Theme/locale toggle + persistence
│
├── core/
│   ├── api/
│   │   ├── api_endpoints_test.dart                    # Static + dynamic endpoint paths
│   │   └── api_response_test.dart                     # fromJson, pagination, Equatable
│   ├── constants/
│   │   └── storage_keys_test.dart                     # Prefix consistency, uniqueness
│   ├── error/
│   │   ├── exceptions_test.dart                       # 6 exception types — toString, defaults
│   │   └── failures_test.dart                         # 8 failure types — Equatable, getFieldError
│   ├── extensions/
│   │   └── string_extensions_test.dart                # capitalize, titleCase, truncate, initials
│   └── utils/
│       └── validators_test.dart                       # Email, password, phone, name, boundary cases
│
└── widget_test.dart                                   # Default Flutter placeholder test
```

---

## Naming Conventions

| Item | Convention | Example |
|------|-----------|---------|
| Feature folder | `snake_case`, singular | `auth/`, `emotion/`, `profile/` |
| Dart file | `snake_case` | `auth_bloc.dart`, `job_entity.dart` |
| Class | `PascalCase` | `AuthBloc`, `JobEntity` |
| Constant | `camelCase` static | `AppColors.primary`, `AppRouter.login` |
| Private field | `_camelCase` | `_fontFamily`, `_router` |
| ARB key | `camelCase` | `loginTitle`, `splashTitle` |
| Route path | `kebab-case` | `/forgot-password`, `/edit-profile` |

---

## How the Pieces Connect

```
main.dart
  └── AppConfig.loadConfig() + initDependencies()  ← `core/di/dependency_injection.dart`
  └── EmosenseApp                     ← app.dart
        ├── MultiBlocProvider       ← Shared BLoCs (analysis, auth, emotion, employee, …)
        ├── BackendConnectionWidget  ← Connectivity / API warm-up UX
        ├── MaterialApp
        │     ├── theme / localization
        │     ├── initialRoute: AppRouter.splash
        │     └── onGenerateRoute: AppRouter.generateRoute
        │           ├── /splash, /login, … (see lib/core/routing/app_router.dart)
        │           ├── /employee, /admin — role shells
        │           └── /text-analysis, /voice-analysis, /video-analysis
```

