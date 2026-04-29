# Clean Build

Run a full clean + regenerate cycle. Use when the build is broken, generated files are stale, or after pulling changes that touched `pubspec.yaml`.

## When to Use

- User says "clean build", "flutter clean", "rebuild", "fix build errors"
- After upgrading packages (`pubspec.yaml` changed)
- Generated files (`.g.dart`, `.freezed.dart`) are out of sync
- `flutter analyze` reports errors in generated code
- After a `git pull` that touched dependencies

## Steps

Execute in order:

### Step 1 — Clean

```powershell
flutter clean
```

Removes `build/` and `.dart_tool/` directories.

### Step 2 — Get packages

```powershell
flutter pub get
```

### Step 3 — Regenerate code (if project uses build_runner)

```powershell
dart run build_runner build --delete-conflicting-outputs
```

This regenerates:
- `*.g.dart` (json_serializable, injectable)
- `*.freezed.dart` (freezed)
- `*.config.dart` (injectable config)

### Step 4 — Regenerate localizations

```powershell
flutter gen-l10n
```

Regenerates `lib/l10n/generated/`.

### Step 5 — Analyze

```powershell
flutter analyze
```

Report any remaining errors. Fix issues before proceeding.

## Quick Commands (copy-paste)

```powershell
flutter clean
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
```

## Common Issues After Clean

| Symptom | Cause | Fix |
|---------|-------|-----|
| `*.g.dart` not found | build_runner not run | Run Step 3 |
| l10n classes not found | gen-l10n not run | Run Step 4 |
| GetIt not finding dependency | injectable config stale | Run Step 3 |
| iOS Pods issues | Pods cache stale | `cd ios && pod install` |

## Notes

- On Windows, use PowerShell — not bash
- If `build_runner` hangs, kill it with `Ctrl+C` and retry with `--delete-conflicting-outputs`
- Never commit `.dart_tool/`, `build/`, or generated files to git
