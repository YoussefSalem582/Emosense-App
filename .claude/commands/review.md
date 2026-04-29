# Review Code

Audit the specified file(s) or feature against all project conventions and report issues.

## When to Use

- User asks to "review", "check", "audit", or "inspect" code
- Before a PR or commit to catch violations early
- After writing new code to verify quality

## What to Check

### 1 — Architecture violations

- Domain layer importing Flutter or data layer packages
- Presentation layer calling repository directly (must go via use case)
- Data layer importing presentation layer
- Missing layers (e.g., no use case, entity used as model)

### 2 — Design token violations

Flag any hardcoded value that should use a token:

- `Color(0xFF...)` or `Colors.*` → should be `AppColors.*`
- Raw `double` spacing (e.g., `SizedBox(height: 16)`) → should be `AppSpacing.*`
- `BorderRadius.circular(N)` → should be `AppRadius.*`
- `TextStyle(...)` inline → should be `AppTextStyles.*`
- Hardcoded asset paths → should be `AppImages.*` / `AppIcons.*`
- Hardcoded route strings → should be `RouteNames.*`

### 3 — Localization violations

- User-facing strings not wrapped in `context.l10n.*`
- ARB key missing in one language file but present in the other

### 4 — Security violations

- Secrets, tokens, client IDs hardcoded in Dart source
- Auth tokens stored in `SharedPreferences` instead of `FlutterSecureStorage`
- Storage key strings not using `StorageKeys.*` constants

### 5 — BLoC pattern issues

- State classes missing `Equatable` / `props`
- Missing `FeatureLoading` state
- Error state missing `message` field
- BLoC not logging transitions via `AppLogger.logBlocTransition()`

### 6 — DI issues

- BLoC registered as `registerLazySingleton` (must be `registerFactory`)
- Use case or repo registered as `registerFactory` (should be `registerLazySingleton`)
- Missing `BlocProvider` in `app.dart`

### 7 — Code style

- Wrong import order (dart: → flutter: → packages → relative)
- SCREAMING_CASE constants (should be camelCase)
- Missing `const` constructors where applicable

### 8 — Offline-first violations

- **Reads**: BLoC load handler fetches from API without `CachePolicy.evaluate(cachedAt: ...)` (or equivalent) — cached data not used when fresh/stale
- **Writes**: mutation handlers don't read `ConnectivityCubit` first; offline path missing `OfflineQueue` + optimistic state
- **Writes**: raw API / remote calls for mutations with no connectivity check (POST/PUT/PATCH/DELETE fired while offline without queueing)
- `ConnectivityCubit` state read directly in widget layer instead of BLoC
- Raw `SharedPreferences` used for mutation queue instead of `OfflineQueue`

## Output Format

For each issue found, report:

```
[SEVERITY] File:line — Description
  Rule: <which convention>
  Fix: <what to change>
```

Severity levels: `ERROR` (must fix), `WARNING` (should fix), `INFO` (consider fixing).

End with a summary: `N errors, M warnings found` or `No issues found`.
