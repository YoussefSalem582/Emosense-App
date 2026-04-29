---
description: "Security conventions — secrets, token storage, environment variables"
alwaysApply: false
---

# Security Conventions

- **Never hardcode** API URLs, tokens, client IDs, or any secret in Dart source
- All secrets are passed via `--dart-define` at build time and accessed via `EnvConfig` getters
- Add placeholders for new secrets to `.env.example` (committed to git) and to build scripts
- Auth tokens MUST use `FlutterSecureStorage` (`encryptedSharedPreferences: true`), NOT `SharedPreferences`
- Storage key strings are centralized in `core/constants/storage_keys.dart`
- Release builds use `scripts/build_release.ps1` (`--obfuscate --split-debug-info`)
- **Claude Code:** Never put keystore passwords, API keys, or tokens in `.claude/settings.json`. Use **`.claude/settings.local.json`** (gitignored) for machine-specific Bash permission rules.
- See `tech_readme_files/08_security_and_environment.md` for full details

## Environment Config

Access secrets only through `EnvConfig`:
- `EnvConfig.baseUrl`
- `EnvConfig.apiVersion`
- `EnvConfig.googleClientId`
- `EnvConfig.sentryDsn`
- `EnvConfig.current.isProduction` / `EnvConfig.current.enableLogging`

## Token Storage

```dart
// CORRECT — FlutterSecureStorage
final token = await secureStorage.read(key: StorageKeys.accessToken);

// WRONG — SharedPreferences (insecure for tokens)
final token = prefs.getString('token');
```
