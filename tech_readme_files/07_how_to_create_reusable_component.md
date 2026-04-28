# 🧩 How to Create a New Reusable Component

> Guide for adding widgets to `lib/shared/widgets/` so they can be used by any feature.

---

## Where Reusable Components Live

```
lib/shared/widgets/
├── app_bar/           ← CustomAppBar
├── background/        ← AuthPatternBackground, AuthScaffoldWithPattern
├── buttons/           ← AppButton (elevated, outlined, text, icon, loading)
├── cards/             ← AppCard
├── dialogs/           ← AppBottomSheet, BottomSheetOption, UnsavedChangesDialog
├── empty/             ← EmptyStateWidget
├── error/             ← AppErrorWidget
├── inputs/            ← AppTextField, AppPasswordField, AppDropdownField, AppPhoneField
├── loading/           ← AppLoading, AppLoadingOverlay
├── pdf_viewer/        ← PdfViewerPage (full-screen with download)
├── photo_picker/      ← PhotoPickerBottomSheet (camera / gallery)
└── responsive/        ← ResponsiveLayout
```

---

## When to Create a Shared Widget

Create a shared widget when the component is:

- **Feature-agnostic** — not tied to auth, jobs, profile, etc.
- **Used (or expected to be used) in 2+ features**
- **Configurable** — behaviour controlled by parameters, not internal assumptions

If a widget is specific to one feature, place it in `features/<feature>/presentation/widgets/` instead.

---

## Step-by-Step: Creating a Reusable Widget

### Example: `AppAvatar`

We'll build a circular avatar widget with image, initials fallback, and online indicator.

### 1. Create the folder and file

```
lib/shared/widgets/avatar/
└── app_avatar.dart
```

### 2. Write the widget

```dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

/// Reusable circular avatar with image URL, initials fallback,
/// and optional online status indicator.
///
/// Usage:
/// ```dart
/// AppAvatar(
///   imageUrl: user.avatarUrl,
///   initials: user.initials,
///   size: 48,
///   isOnline: true,
/// )
/// ```
class AppAvatar extends StatelessWidget {
  /// URL of the avatar image. If null or fails to load, shows [initials].
  final String? imageUrl;

  /// Fallback text shown when [imageUrl] is unavailable (typically 1-2 chars).
  final String initials;

  /// Diameter of the avatar circle in logical pixels.
  final double size;

  /// Whether to show a green online indicator dot.
  final bool isOnline;

  /// Background colour for the initials fallback.
  final Color? backgroundColor;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials = '',
    this.size = 40,
    this.isOnline = false,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = backgroundColor ?? AppColors.primaryLight;
    final radius = size / 2;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          // ─── Avatar circle ───────────────────────────
          CircleAvatar(
            radius: radius,
            backgroundColor: bgColor,
            backgroundImage: imageUrl != null
                ? CachedNetworkImageProvider(imageUrl!)
                : null,
            child: imageUrl == null
                ? Text(
                    initials,
                    style: AppTextStyles.labelLarge.copyWith(
                      color: AppColors.primary,
                      fontSize: size * 0.35,
                    ),
                  )
                : null,
          ),

          // ─── Online indicator ────────────────────────
          if (isOnline)
            Positioned(
              right: 0,
              bottom: 0,
              child: Container(
                width: size * 0.28,
                height: size * 0.28,
                decoration: BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    width: 2,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
```

---

## Design Rules for Shared Widgets

### 1. No feature-specific imports

```dart
// ✅ GOOD
import '../../../config/theme/app_colors.dart';
import '../../../config/theme/app_text_styles.dart';

// ❌ BAD — ties the widget to a single feature
import '../../../features/auth/domain/entities/user_entity.dart';
```

### 2. No hardcoded strings

```dart
// ✅ GOOD — caller provides label
AppButton(label: context.l10n.save, onPressed: _save)

// ❌ BAD — hardcoded inside the widget
Text('Save')
```

### 3. Use theme colours, not literals

```dart
// ✅ GOOD
color: AppColors.primary

// ❌ BAD
color: Color(0xFF5C6DB4)
```

### 4. Use AppTextStyles, not ad-hoc TextStyles

```dart
// ✅ GOOD
style: AppTextStyles.titleMedium

// ❌ BAD
style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)
```

### 5. Use AppSpacing / AppRadius for consistent spacing

```dart
// ✅ GOOD
padding: AppSpacing.paddingMD,
borderRadius: AppRadius.borderRadiusMD,

// ❌ BAD
padding: EdgeInsets.all(16),
borderRadius: BorderRadius.circular(12),
```

### 6. Make everything configurable via parameters

```dart
// ✅ GOOD — size is customisable, has sensible default
const AppAvatar({this.size = 40, ...});

// ❌ BAD — hardcoded internal value
Container(width: 40, height: 40, ...)
```

### 7. Add a doc comment with usage example

```dart
/// Reusable circular avatar with image URL, initials fallback,
/// and optional online status indicator.
///
/// Usage:
/// ```dart
/// AppAvatar(imageUrl: url, initials: 'JD', size: 48)
/// ```
```

---

## Existing Shared Widgets — API Quick Reference

### `AppButton`

```dart
AppButton(
  label: 'Submit',
  onPressed: () {},
  type: AppButtonType.elevated,   // elevated | outlined | text
  isLoading: false,
  isFullWidth: true,
  icon: Icons.send,
)
```

### `AppTextField`

```dart
AppTextField(
  label: 'Email',
  hint: 'you@example.com',
  controller: _emailController,
  keyboardType: TextInputType.emailAddress,
  prefixIcon: Icons.email_outlined,
  validator: Validators.email,
  errorText: 'Invalid email',
)
```

### `AppPasswordField`

```dart
AppPasswordField(
  label: 'Password',
  controller: _passwordController,
  validator: Validators.password,
)
```

### `AppDropdownField<T>`

```dart
AppDropdownField<String>(
  label: 'Country',
  initialValue: selectedCountry,
  items: countries.map((c) => DropdownMenuItem(value: c.code, child: Text(c.name))).toList(),
  onChanged: (value) => setState(() => selectedCountry = value),
)
```

### `AppCard`

```dart
AppCard(
  child: Column(...),
  onTap: () {},
  padding: AppSpacing.paddingMD,
)
```

### `AppLoading` / `AppLoadingOverlay`

```dart
// Inline spinner
const AppLoading()

// Full-screen overlay
AppLoadingOverlay(isLoading: _saving, child: MyForm())
```

### `AppErrorWidget`

```dart
AppErrorWidget(
  message: 'Something went wrong',
  onRetry: () => bloc.add(ReloadEvent()),
)
```

### `EmptyStateWidget`

```dart
EmptyStateWidget(
  icon: Icons.inbox_outlined,
  title: 'No items',
  subtitle: 'Check back later',
  actionText: 'Refresh',
  onAction: () => _refresh(),
)
```

### `CustomAppBar`

```dart
CustomAppBar(
  title: 'Page Title',
  showBackButton: true,
  actions: [IconButton(...)],
)
```

### `ResponsiveLayout`

```dart
ResponsiveLayout(
  mobile: MobileView(),
  tablet: TabletView(),
  desktop: DesktopView(),
)
```

---

## Checklist for New Shared Widgets

- [ ] Placed in `lib/shared/widgets/<category>/`
- [ ] Zero feature-specific imports
- [ ] Zero hardcoded strings (labels come from caller or l10n)
- [ ] Uses `AppColors` for all colours
- [ ] Uses `AppTextStyles` for all text styles
- [ ] Uses `AppSpacing` / `AppRadius` for spacing
- [ ] All configurable properties exposed as constructor params with sensible defaults
- [ ] `const` constructor where possible
- [ ] Doc comment with usage example
- [ ] Works in both light and dark theme
