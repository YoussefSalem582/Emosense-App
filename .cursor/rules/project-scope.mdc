---
description: "Project scope boundaries — only edit the Flutter app, never the backend or frontend"
alwaysApply: true
---

# Project Scope

**Only work on `technology_ninety_two_app/` (the Flutter mobile app).**

Do NOT modify, create, or delete files in:
- `technology_ninety_two_backend-main/` — Laravel backend (another team)
- `technology_ninety_two_front_end-main/` — Next.js frontend (another team)

These repos are included for reference only (API contracts, route definitions, model schemas). You may read them for context but must never edit them.

## Agent tooling (repository root)

`.agents/`, `.claude/`, `.cursor/`, assistant-specific `*ignore` files, and top-level **`AGENTS.md`** / **`CLAUDE.md`** are listed in **`AGENTS.md`** under **Agent tooling layout (repository root)**.

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
| `lib/shared/` | assets, spacing, reusable widgets |
| `lib/features/` | Feature modules (Clean Architecture) |
| `lib/l10n/` | ARB files + generated localizations |
