# 🌍 How to Add a New Language

> Guide for adding a new locale to the app (e.g., French `fr`).

---

## Current Setup

| File | Purpose |
|------|---------|
| `l10n.yaml` | Generator configuration |
| `lib/l10n/arb/app_en.arb` | English translations (template) |
| `lib/l10n/arb/app_ar.arb` | Arabic translations |
| `lib/l10n/generated/` | Auto-generated `AppLocalizations` class |

The template file is `app_en.arb` — it defines all the keys. Other locale files must match these keys exactly.

---

## Step-by-Step

### 1. Create the new ARB file

Copy `lib/l10n/arb/app_en.arb` → `lib/l10n/arb/app_fr.arb`

Update the `@@locale` at the top:

```json
{
  "@@locale": "fr",
  "appName": "Technology 92",
  "loginTitle": "Connexion",
  "loginSubtitle": "Bienvenue ! Veuillez vous connecter",
  "email": "E-mail",
  ...
}
```

**Rules:**
- The file MUST be named `app_<locale>.arb` (matching the pattern in `l10n.yaml`).
- Every key in `app_en.arb` must exist in `app_fr.arb`.
- Metadata keys (starting with `@`) are optional in non-template files.

### 2. Run the generator

```bash
flutter gen-l10n
```

This creates `lib/l10n/generated/app_localizations_fr.dart` automatically.

### 3. Register the locale in `app.dart`

The `supportedLocales` are already auto-generated from the ARB files, so **no change is needed** in `app.dart` — the generator handles it.

However, if you've hardcoded a specific locale list somewhere, add `fr`:

```dart
supportedLocales: const [
  Locale('en'),
  Locale('ar'),
  Locale('fr'),  // ← Add this
],
```

### 4. Update `app_constants.dart`

```dart
static const List<String> supportedLocales = ['en', 'ar', 'fr'];
```

### 5. Update the Settings page

If the settings page has a language picker, add the new option:

```dart
ListTile(
  leading: const Text('🇫🇷'),
  title: const Text('Français'),
  onTap: () => _changeLocale(context, 'fr'),
),
```

### 6. Handle RTL (if applicable)

Arabic is RTL and is already handled. If your new language is also RTL (e.g., Hebrew, Urdu), Flutter handles directionality automatically via `Directionality` based on the locale.

---

## ARB Key Conventions

| Convention | Example |
|-----------|---------|
| Feature prefix | `loginTitle`, `jobsPageTitle`, `profileSection` |
| Action verbs | `save`, `cancel`, `delete`, `apply` |
| Error messages | `errorNetwork`, `errorServer`, `errorUnexpected` |
| Placeholders | `"welcomeUser": "Welcome, {name}!"` with `@welcomeUser` metadata |

### Adding a key with placeholders

In `app_en.arb`:

```json
"welcomeUser": "Welcome, {name}!",
"@welcomeUser": {
  "description": "Greeting shown on home page",
  "placeholders": {
    "name": {
      "type": "String",
      "example": "John"
    }
  }
}
```

In `app_fr.arb`:

```json
"welcomeUser": "Bienvenue, {name} !"
```

Usage in code:

```dart
context.l10n.welcomeUser(userName)
```

---

## Accessing Translations in Code

Use the `context.l10n` extension (from `context_extensions.dart`):

```dart
Text(context.l10n.loginTitle)
```

This calls `AppLocalizations.of(context)!` under the hood.

**Never hardcode user-facing strings. Always use ARB keys.**

---

## Quick Reference: `l10n.yaml`

```yaml
arb-dir: lib/l10n/arb
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-dir: lib/l10n/generated
nullable-getter: false
```

---

## Checklist

- [ ] `lib/l10n/arb/app_<locale>.arb` created with all keys from `app_en.arb`
- [ ] `@@locale` set correctly in the new ARB file
- [ ] `flutter gen-l10n` runs without errors
- [ ] `app_constants.dart` `supportedLocales` updated
- [ ] Settings page updated with new language option (if applicable)
- [ ] App tested with the new locale active
