# 🎨 How to Change Theme Colors

> Single-source-of-truth color system — change once, update everywhere.

---

## Architecture

All colours are defined in **one file**: `lib/config/theme/app_colors.dart`

Both themes (`light_theme.dart` and `dark_theme.dart`) reference `AppColors` exclusively. No widget should ever use a raw `Color(0xFF...)` literal — always reference `AppColors`.

---

## Changing the Brand Colours

Open `lib/config/theme/app_colors.dart` and update the brand section:

```dart
// ─── Brand Colors ───────────────────────────────────────────
static const Color primary     = Color(0xFF5C6DB4);   // ← Change this
static const Color primaryLight  = Color(0xFF7B89C8);   // ← Lighter variant
static const Color primaryDark   = Color(0xFF3E4F96);   // ← Darker variant

static const Color secondary      = Color(0xFFE9C62B);   // ← Change this
static const Color secondaryLight  = Color(0xFFF0D65C);
static const Color secondaryDark   = Color(0xFFD4B01E);
```

**That's it.** Both themes, all buttons, inputs, navigation bars, chips, tabs — everything picks up the new colour automatically because they all reference `AppColors.primary`, `AppColors.secondary`, etc.

---

## Colour Categories in `AppColors`

| Category | Purpose | Examples |
|----------|---------|---------|
| **Brand** | Primary & secondary with light/dark variants | `primary`, `primaryLight`, `primaryDark` |
| **Neutral** | White, black, dark surface, grey shades | `white`, `black`, `darkBackground`, `neutral100–400` |
| **Text** | Light-theme & dark-theme text colours | `textPrimary`, `textSecondary`, `textHint`, `textPrimaryDark` |
| **Semantic** | Success, error, warning, info + light variants | `success`, `error`, `warning`, `info` |
| **Background** | Scaffold, surface, card backgrounds (light & dark) | `scaffoldLight`, `surfaceDark`, `cardLight` |
| **Border & Divider** | Lines and separators | `borderLight`, `borderDark`, `dividerLight` |
| **Shimmer** | Skeleton loading animation | `shimmerBase`, `shimmerHighlight` |
| **Social** | OAuth provider brand colours | `google`, `facebook`, `linkedin`, `twitter` |
| **Status** | Job/user status indicators | `employed`, `pending`, `published`, `rejected` |

---

## Changing Light Theme Specifics

Open `lib/config/theme/light_theme.dart`.

The `ColorScheme` maps `AppColors` to Material 3 semantic roles:

```dart
colorScheme: const ColorScheme.light(
  primary: AppColors.primary,              // Primary brand colour
  primaryContainer: AppColors.primaryLight, // Container tint
  secondary: AppColors.secondary,
  surface: AppColors.surfaceLight,          // Card/dialog background
  error: AppColors.error,
  onPrimary: AppColors.white,              // Text on primary-coloured surfaces
  onSurface: AppColors.textPrimary,        // Default text colour
  outline: AppColors.borderLight,          // Border/outline default
),
```

Component-level overrides (AppBar, Card, Button, Input, etc.) are all in the same file and reference `AppColors` directly.

---

## Changing Dark Theme Specifics

Open `lib/config/theme/dark_theme.dart` — same structure, different colour values:

```dart
colorScheme: const ColorScheme.dark(
  primary: AppColors.primary,
  surface: AppColors.surfaceDark,
  onSurface: AppColors.textPrimaryDark,
  ...
),
scaffoldBackgroundColor: AppColors.scaffoldDark,
```

---

## Changing the Font

The font is **Public Sans**, loaded at runtime via `google_fonts`.

### To change the font family:

1. Open `lib/config/theme/app_text_styles.dart`:

```dart
class AppFonts {
  static const String primary = 'PublicSans';  // ← Change this
  static const String fallback = 'Roboto';
}
```

2. Open `lib/config/theme/light_theme.dart` and `dark_theme.dart`:

Replace `GoogleFonts.publicSansTextTheme(...)` with your new font:

```dart
// For example, switching to Inter:
textTheme: GoogleFonts.interTextTheme(...),
```

Also update the `fontFamily` property:

```dart
fontFamily: 'Inter',  // Update in both light_theme.dart and dark_theme.dart
```

And the `appBarTheme.titleTextStyle.fontFamily`:

```dart
titleTextStyle: TextStyle(
  fontFamily: 'Inter',  // ← Update
  ...
),
```

### To bundle a custom font locally (instead of google_fonts):

1. Place `.ttf` files in `assets/fonts/`.
2. Uncomment the `fonts:` section in `pubspec.yaml`.
3. Remove the `GoogleFonts.*TextTheme()` wrapper from both themes.

---

## Changing Text Style Sizes / Weights

Open `lib/config/theme/app_text_styles.dart`.

The full Material 3 type scale is defined here:

```dart
static const TextStyle headlineLarge = TextStyle(
  fontFamily: _fontFamily,
  fontSize: 32,           // ← Change size
  fontWeight: FontWeight.w700,  // ← Change weight
  height: 1.25,           // ← Change line height
);
```

Available styles: `displayLarge/Medium/Small`, `headlineLarge/Medium/Small`, `titleLarge/Medium/Small`, `bodyLarge/Medium/Small`, `labelLarge/Medium/Small`, `button`, `buttonSmall`, `caption`, `overline`.

---

## Changing Spacing & Radius

Open `lib/shared/spacing/app_spacing.dart`:

```dart
// SizedBox presets
static const SizedBox verticalXS = SizedBox(height: 4);
static const SizedBox verticalSM = SizedBox(height: 8);
static const SizedBox verticalMD = SizedBox(height: 16);
static const SizedBox verticalLG = SizedBox(height: 24);
static const SizedBox verticalXL = SizedBox(height: 32);

// BorderRadius presets
class AppRadius {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double full = 999;

  static final BorderRadius borderRadiusXS = BorderRadius.circular(xs);
  static final BorderRadius borderRadiusSM = BorderRadius.circular(sm);
  // ...
}
```

---

## Changing Component-Level Theme

Each Material component has its own section in `light_theme.dart` / `dark_theme.dart`:

| Component | Theme property |
|-----------|---------------|
| AppBar | `appBarTheme` |
| Card | `cardTheme` |
| Elevated Button | `elevatedButtonTheme` |
| Outlined Button | `outlinedButtonTheme` |
| Text Button | `textButtonTheme` |
| Input / TextField | `inputDecorationTheme` |
| Bottom Nav | `bottomNavigationBarTheme` |
| Navigation Bar (M3) | `navigationBarTheme` |
| Chip | `chipTheme` |
| Tab Bar | `tabBarTheme` |
| Dialog | `dialogTheme` |
| Bottom Sheet | `bottomSheetTheme` |
| Snack Bar | `snackBarTheme` |
| Switch | `switchTheme` |
| FAB | `floatingActionButtonTheme` |
| Progress Indicator | `progressIndicatorTheme` |
| Divider | `dividerTheme` |

---

## Quick Checklist

- [ ] Update `AppColors` for colour changes
- [ ] Update `AppTextStyles` / `AppFonts` for typography changes
- [ ] Update `AppSpacing` / `AppRadius` for spacing changes
- [ ] Both `light_theme.dart` and `dark_theme.dart` reference `AppColors` — verify both
- [ ] Run the app and test both light and dark mode
- [ ] Check key surfaces: buttons, inputs, cards, navigation bar, chips, dialogs
