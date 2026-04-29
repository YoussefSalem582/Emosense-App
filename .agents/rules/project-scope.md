---
description: "Project scope boundaries — only edit the Flutter app, never the backend or frontend"
alwaysApply: true
---

# Project Scope

**Only work on this Flutter app at the repository root** (`lib/`, assets, platform projects, `pubspec.yaml`, etc.).

Do NOT modify, create, or delete files in (when those sibling folders exist beside this repo):
- `technology_ninety_two_backend-main/` — Laravel backend (another team)
- `technology_ninety_two_front_end-main/` — Next.js frontend (another team)

Those directories are for reference only (API contracts, route definitions, model schemas). You may read them for context but must never edit them.

## Agent tooling (repository root)

`.agents/`, `.claude/`, `.cursor/`, assistant-specific `*ignore` files, and top-level **`AGENTS.md`** / **`CLAUDE.md`** are listed in **`AGENTS.md`** under **Agent tooling layout (repository root)**.

## Project Overview

- **App**: Emosense — emotion recognition and analytics (`emosense_mobile`)
- **Architecture**: Clean Architecture + BLoC (presentation → domain ← data)
- **State Management**: flutter_bloc
- **Routing**: `MaterialApp` + `AppRouter.generateRoute` (`lib/core/routing/app_router.dart`)
- **DI**: GetIt (`lib/core/di/dependency_injection.dart` — `initDependencies()`)
- **Networking**: Dio (`ApiClient` wrapper with interceptors)
- **Local Storage**: SharedPreferences, FlutterSecureStorage
- **Secrets**: `.env` + **`AppConfig`** (`flutter_dotenv`; `AppConfig.loadConfig()` in `lib/main.dart`) — never hardcode secrets
- **Auth**: Email/password + Google Sign-In (`google_sign_in` → backend OAuth exchange)
- **Localization**: ARB-based l10n (English + Arabic) via `context.l10n`

## Entry Points

| File | Purpose |
|------|---------|
| `lib/main.dart` | `AppConfig.loadConfig()` + `initDependencies()` |
| `lib/app.dart` | `EmosenseApp` — `MaterialApp` + `AppRouter.generateRoute` |
| `lib/core/di/dependency_injection.dart` | GetIt DI registration |
| `lib/core/routing/app_router.dart` | Route constants + `generateRoute` |

## Key Directories

| Directory | Purpose |
|-----------|---------|
| `lib/core/config/` | `app_config` / environment bootstrap |
| `lib/core/routing/` | `AppRouter` |
| `lib/core/` | DI, API, networking, utilities |
| `lib/shared/` | assets, spacing, reusable widgets |
| `lib/features/` | Feature modules (Clean Architecture) |
| `lib/l10n/` | ARB files + generated localizations |
