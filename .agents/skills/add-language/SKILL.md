---
name: add-language
description: Add or update localization strings. Use when adding new user-facing text, translations, or a new language to the app.
---

# Add / Update Localization

Manage ARB-based internationalization for the Emosense app.

## When to Use

- User asks to add new strings or translations
- User says "add language", "translate", "localize", "add text"
- New user-facing text is introduced in any feature
- A new language needs to be supported

## Adding New Strings

### Step 1 — Add keys to English ARB

Edit `lib/l10n/arb/app_en.arb`:

```json
"featureTitle": "Feature Title",
"featureDescription": "Description text here"
```

### Step 2 — Add keys to Arabic ARB

Edit `lib/l10n/arb/app_ar.arb`:

```json
"featureTitle": "عنوان الميزة",
"featureDescription": "نص الوصف هنا"
```

### Step 3 — Generate

Run: `flutter gen-l10n`

### Step 4 — Use in Code

Access via the `context.l10n` extension:

```dart
Text(context.l10n.featureTitle)
```

## Adding a New Language

Reference `tech_readme_files/05_how_to_add_new_language.md`.

1. Create new ARB file: `lib/l10n/arb/app_<locale>.arb`
2. Copy all keys from `app_en.arb` and translate values
3. Update `l10n.yaml` if needed
4. Run `flutter gen-l10n`
5. Update `app.dart` to include new locale in `supportedLocales`

## Rules

- NEVER hardcode user-facing strings — always use ARB keys
- ALWAYS add keys to ALL ARB files (currently `app_en.arb` and `app_ar.arb`)
- Key naming: `camelCase`, descriptive, prefixed by feature when ambiguous
- Run `flutter gen-l10n` after every ARB change
