---
description: "Dart/Flutter code conventions for the Technology 92 app"
globs: "technology_ninety_two_app/**/*.dart"
alwaysApply: false
---

# Dart & Flutter Conventions

## Design Tokens — Never Hardcode

- **Colors**: Use `AppColors.primary`, `AppColors.error`, etc. — never `Color(0xFF...)` or `Colors.blue`
- **Typography**: Use `AppTextStyles.bodyLarge`, `AppTextStyles.titleMedium`, etc.
- **Spacing**: Use `AppSpacing.verticalBase`, `AppSpacing.paddingAll16`, `AppSpacing.pagePadding`
- **Radius**: Use `AppRadius.md`, `AppRadius.lg`, etc.
- **Assets**: Use `AppImages.logo`, `AppIcons.settings` — never hardcode asset paths
- **Routes**: Use `RouteNames.home`, `RouteNames.login` — never hardcode path strings

## Localization

- All user-facing strings go through `context.l10n.someKey`
- Add keys to BOTH `lib/l10n/arb/app_en.arb` and `lib/l10n/arb/app_ar.arb`
- Run `flutter gen-l10n` after adding keys

## Import Order

1. Dart SDK (`dart:`)
2. Flutter SDK (`package:flutter/`)
3. Third-party packages (`package:`)
4. Project imports (relative)

## Naming

- Files: `snake_case.dart`
- Classes: `PascalCase`
- Variables/functions: `camelCase`
- Constants: `camelCase` (Dart convention, not SCREAMING_CASE)
- Private members: `_prefixed`

## Shared Widgets

Always check `lib/shared/widgets/` before creating new widgets:
- `AppButton` — Elevated/outlined/text/icon/loading button
- `AppTextField` — Text field, password field, dropdown
- `AppPhoneField` — Phone input with country code picker
- `AppDropdownField` — Dropdown selector
- `AppSearchableDropdownField` — Searchable dropdown selector
- `AppDateField` — Date input field
- `AppDateInputSheet` — Date input bottom sheet
- `AppCard` — Themed Card wrapper
- `AppLoading` — Spinner, overlay, shimmer
- `AppErrorWidget` — Error display with retry
- `EmptyStateWidget` — Illustration + title + action
- `CustomAppBar` — Themed AppBar
- `AppBottomSheet` — Bottom sheet helper
- `UnsavedChangesDialog` — Unsaved changes confirmation
- `PdfViewerPage` — Full-screen PDF viewer
- `VideoPlayerPage` — In-app video player
- `PhotoPickerBottomSheet` — Photo picker sheet
- `ResponsiveLayout` — Breakpoint builder
- `AuthPatternBackground` — Auth page background pattern
- `ConnectivityBanner` — Online/offline status banner
- `OfflineBanner` — Offline notification banner
- `AppToast` — Toast notification
- `TranslationPendingBanner` — Translation pending indicator
- `AppDateFilter` — Date range filter widget
- `FilterIconButton` — Filter icon button
- `FilterSheetActions` — Filter sheet action buttons

## Error Extensions

Use `context.showError()`, `context.showSuccess()` from `context_extensions.dart`.

## Storage Keys

Centralize all storage key strings in `core/constants/storage_keys.dart`.
