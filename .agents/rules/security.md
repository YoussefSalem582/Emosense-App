---
description: "Security conventions — secrets, token storage, environment variables"
alwaysApply: false
---

# Security Conventions

- **Never hardcode** API URLs, tokens, client IDs, or any secret in Dart source
- Configuration loads from `.env` at runtime via **`AppConfig.loadConfig()`** (`lib/main.dart`); access values through **`AppConfig`** getters in `lib/core/config/app_config.dart`
- Add placeholders for new keys to `.env.example` (committed to git)
- Auth tokens MUST use `FlutterSecureStorage` (`encryptedSharedPreferences: true`), NOT `SharedPreferences`
- Storage key strings are centralized in `core/constants/storage_keys.dart`
- Release builds use `scripts/build_release.ps1` (`--obfuscate --split-debug-info`)
- **Claude Code:** Never put keystore passwords, API keys, or tokens in `.claude/settings.json`. Use **`.claude/settings.local.json`** (gitignored) for machine-specific Bash permission rules.
- See `tech_readme_files/08_security_and_environment.md` for full details

## Environment Config

Access configuration through **`AppConfig`** (see `lib/core/config/app_config.dart`), for example:

- `AppConfig.baseUrl` ← `API_BASE_URL`
- `AppConfig.apiKey` ← `API_KEY`
- `AppConfig.environment`, `AppConfig.isProduction`, `AppConfig.enableLogging`, `AppConfig.debugMode`

## Token Storage

```dart
// CORRECT — FlutterSecureStorage
final token = await secureStorage.read(key: StorageKeys.accessToken);

// WRONG — SharedPreferences (insecure for tokens)
final token = prefs.getString('token');
```
