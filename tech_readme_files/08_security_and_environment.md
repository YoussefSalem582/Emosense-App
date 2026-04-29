# 🔒 Security & Environment Configuration

> How secrets are managed, tokens are stored, and release builds are hardened.

---

## Overview

The app follows a **zero-hardcoded-secrets** policy. All sensitive values live in a
`.env` file that is loaded at runtime and **never committed to version control**.

Release builds use **Dart obfuscation** + **debug-symbol splitting** to resist
reverse engineering.

### Claude Code / AI editor settings

- **Never** put keystore passwords, API keys, or tokens in committed JSON (including `.claude/settings.json`).
- Use **`.claude/settings.local.json`** for machine-specific Bash permission rules (that file is **gitignored**).
- If a signing or API secret was ever committed, **rotate** it in the keystore or provider console and stop tracking the old value in git history where possible.

---

## 1. Environment Variables (`.env`)

### Setup

1. Copy the template:

   ```bash
   cp .env.example .env
   ```

2. Fill in your values:

   ```dotenv
   # ─── API ─────────────────────────────────────────────────
   API_BASE_URL=http://192.168.100.59:8000
   API_VERSION=v1

   # ─── Google OAuth ────────────────────────────────────────
   GOOGLE_SERVER_CLIENT_ID=your-client-id.apps.googleusercontent.com
   ```

3. **Never** commit `.env` — it is already listed in `.gitignore`.

### How It Works

| Layer           | Detail |
|-----------------|--------|
| **Mechanism**   | `flutter_dotenv` loads `.env` at **runtime** (`AppConfig.loadConfig()` in `lib/main.dart`). |
| **Build scripts** | `scripts/build_release.ps1` / `scripts/build_debug.ps1` can still pass extra flags; runtime API base URL and keys come from the loaded `.env` file. |
| **Access**      | Getters on **`AppConfig`** in `lib/core/config/app_config.dart` |

### Where Values Are Read

| Key | Consumer | Fallback |
|-----|----------|----------|
| `API_BASE_URL` | `AppConfig.baseUrl` | `http://localhost:8000` |
| `API_KEY` | `AppConfig.apiKey` | `default-api-key` |
| `ENVIRONMENT` | `AppConfig.environment` | `development` |
| `ENABLE_LOGGING` | `AppConfig.enableLogging` | `false` |
| `CONNECT_TIMEOUT` / `RECEIVE_TIMEOUT` | `AppConfig.connectTimeout` / `AppConfig.receiveTimeout` | `30000` (ms) |

Add more rows here as you introduce keys; **Google OAuth** client IDs may be read from `.env` once a getter exists on `AppConfig` (documented in section 3).

### Adding a New Secret

1. Add the key + placeholder to `.env.example`.
2. Add the real value to your local `.env` (or `.env.development` / `.env.production`).
3. Add a getter on **`AppConfig`** in `lib/core/config/app_config.dart`:

   ```dart
   static String get myNewKey => dotenv.env['MY_NEW_KEY'] ?? '';
   ```

4. Use **`AppConfig.myNewKey`** wherever needed — avoid importing `dotenv` directly outside `app_config.dart`.

---

## 2. Token & Credential Storage

| Data             | Store                          | Encrypted? | Notes                                      |
|------------------|--------------------------------|------------|---------------------------------------------|
| Auth token       | `FlutterSecureStorage`         | ✅ Yes      | `encryptedSharedPreferences: true` on Android |
| User profile     | `SharedPreferences`            | ⚠️ Android: encrypted via option | Non-sensitive display fields only |
| Theme / Locale   | `SharedPreferences`            | ⚠️ Same    | User preferences                             |


### FlutterSecureStorage Options

```dart
const _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
);
```

This uses Android's **EncryptedSharedPreferences** (AES-256 under the hood) so
the auth token is encrypted at rest.

### Key Strings

All storage keys are centralised in `lib/core/constants/storage_keys.dart`
— never hardcode key strings elsewhere.

### Platform identifiers (staging)

Until store-ready storefront branding is finalized, **Android `applicationId`** and **iOS `PRODUCT_BUNDLE_IDENTIFIER`** should match placeholders in Gradle / Xcode (**`com.example.graphsmile_mobile`** and **`com.example.graphsmileMobile`** respectively — verify in `android/app/build.gradle.kts` and `ios/Runner.xcodeproj/project.pbxproj` before release).


## 3. Google OAuth Configuration

### Required Credentials

| Credential               | Where It Lives                    |
|--------------------------|-----------------------------------|
| Web / Server Client ID   | `.env` → `GOOGLE_SERVER_CLIENT_ID` |
| Android OAuth Client     | Google Cloud Console (not in code) |

### Android Setup (one-time)

1. Get your signing certificate SHA-1:

   ```bash
   # Debug:
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android

   # Release:
   keytool -list -v -keystore <your-release-keystore> -alias <alias>
   ```

2. Go to **Google Cloud Console → APIs & Credentials → Create Credentials →
   OAuth Client ID → Android**.

3. Enter package name and signing certificate data that match your **Gradle** registration only:
   - **Package name**: must equal `applicationId` in `android/app/build.gradle.kts` (currently **`com.example.graphsmile_mobile`** — placeholder-style naming; replace with your store-ready ID before publishing).
   - **SHA-1 fingerprint**: from step 1

4. Create a **Web** client ID as well (this is the `GOOGLE_SERVER_CLIENT_ID`
   saved in `.env`).

### Flow

```
App (google_sign_in) ──idToken──→ Backend POST /api/v1/oauth/exchange
                                   ↓
                              validates token with Google
                                   ↓
                              returns app auth token
```

---

## 4. `.gitignore` Rules for Secrets

The following patterns are in `.gitignore`:

```gitignore
# Environment secrets
.env
.env.*
!.env.example
```

This ensures:
- `.env` is never tracked.
- Environment-specific variants (`.env.staging`, `.env.production`) are never tracked.
- `.env.example` (safe template) **is** tracked.

---

## 5. Release Build Hardening

### What Obfuscation Does

| Technique              | Effect                                                       |
|------------------------|--------------------------------------------------------------|
| `--obfuscate`          | Renames classes, methods, fields to meaningless symbols       |
| `--split-debug-info`   | Strips human-readable symbols into a separate directory       |

### Build Scripts

| Script                    | Purpose             | Usage                                    |
|---------------------------|---------------------|------------------------------------------|
| `scripts/build_release.sh`| Secure release build | `./scripts/build_release.sh apk`        |
| `scripts/build_debug.sh`  | Debug / dev build    | `./scripts/build_debug.sh` or `./scripts/build_debug.sh run` |

### Release Build

```bash
./scripts/build_release.sh apk        # APK
./scripts/build_release.sh appbundle   # Play Store bundle
./scripts/build_release.sh ios         # iOS archive
```

Debug symbols are saved to `build/symbols/` — **keep these** for de-obfuscating
crash reports (Firebase Crashlytics, Sentry, etc.).

### Debug Build

```bash
./scripts/build_debug.sh              # flutter run (default)
./scripts/build_debug.sh build        # flutter build apk --debug
./scripts/build_debug.sh clean        # flutter clean + pub get
```

---

## 6. Security Checklist

When reviewing PRs or onboarding new developers, verify:

- [ ] No API URLs, tokens, or client IDs hardcoded in Dart source
- [ ] `.env` is **not** committed (check `git status`)
- [ ] New secrets have a placeholder in `.env.example`
- [ ] New secrets are accessed via **`AppConfig`** getters only
- [ ] Auth tokens use `FlutterSecureStorage`, not `SharedPreferences`
- [ ] Release builds use `scripts/build_release.sh` (obfuscation enabled)
- [ ] Debug symbols (`build/symbols/`) are archived for crash reporting
- [ ] Google OAuth Android credentials match the signing key in use

---

## Quick Reference

```
.env.example                       ← Template (committed)
.env / .env.development / .env.production  ← Real secrets (git-ignored paths per `.gitignore`)
lib/core/config/app_config.dart   ← Single access point (`AppConfig` + `flutter_dotenv`)
lib/core/constants/storage_keys.dart    ← All SharedPreferences / SecureStorage keys
scripts/build_release.ps1 / .sh   ← Obfuscated release build (Windows / Unix)
scripts/build_debug.ps1 / .sh     ← Development build & run
```
