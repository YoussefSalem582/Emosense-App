---
description: "Design system tokens — colors, spacing, radius, typography for consistent UI"
alwaysApply: false
---

# Design System

## Colors (from `AppColors`)

- **Primary**: `#5B6EF5` — Brand blue (buttons, links, active states)
- **Primary variants**: `primaryLight` (#8B96F9), `primaryDark` (#3D4ED4), `primaryTint` (#EEF0FE)
- **Secondary**: `#E9C62B` — Accent yellow
- **Background**: `backgroundLight` (#F2F2F7), `backgroundDark` (#000000)
- **Surfaces**: iOS-style dark hierarchy — `darkSurface` (#1C1C1E), `darkCard` (#2C2C2E), `darkSurfaceContainerHigh` (#3A3A3C)
- **Frosted Glass**: `frostedLight`, `frostedDark`, `frostedBorderLight`, `frostedBorderDark`
- **Separators**: `separator` (#C6C6C8), `opaqueSeparator` (#D8D8DC)
- **Status**: `success` (#34C759), `error` (#FF3B30), `warning` (#FF9500), `info` (#5AC8FA) — each with light variant

Always use `AppColors.primary`, `AppColors.error`, etc. — never raw hex or `Colors.*`.

## Spacing (from `AppSpacing`)

| Token | Value | Usage |
|-------|-------|-------|
| `xxs` | 2 | Tight gaps |
| `xs` | 4 | Icon padding |
| `sm` | 8 | Small gaps |
| `md` | 12 | Medium gaps |
| `base` | 16 | Default spacing |
| `lg` | 20 | Section gaps |
| `xl` | 24 | Large gaps |
| `xxl` | 32 | Section dividers |
| `xxxl` | 40 | Page sections |
| `huge` | 48 | Extra-large gaps |
| `massive` | 64 | Maximum spacing |

Helpers: `AppSpacing.verticalBase`, `AppSpacing.horizontalSM`, `AppSpacing.pagePadding`, `AppSpacing.screenPadding`

## Radius (from `AppRadius`)

| Token | Value |
|-------|-------|
| `xs` | 4 |
| `sm` | 6 |
| `md` | 8 |
| `base` | 10 |
| `lg` | 12 |
| `xl` | 16 |
| `xxl` | 20 |
| `round` | 100 |

## Typography (from `AppTextStyles`)

- Font: PublicSans (EN) / Tajawal (AR) — locale-aware via `AppFonts.forLocale`; fallback: Roboto
- Material Design type scale: `displayLarge` → `labelSmall`
- iOS HIG-inspired: negative `letterSpacing` on headlines, increased `fontWeight` contrast
- Use `AppTextStyles.bodyLarge`, `AppTextStyles.titleMedium`, etc.

## Shared Widgets

Check `lib/shared/widgets/` before building new UI. Existing components:

**Inputs**: `AppTextField`, `AppPhoneField`, `AppDropdownField`, `AppSearchableDropdownField`, `AppDateField`, `AppDateInputSheet`
**Buttons**: `AppButton`
**Cards**: `AppCard`
**Dialogs**: `AppBottomSheet`, `UnsavedChangesDialog`
**Banners**: `ConnectivityBanner`, `OfflineBanner`, `AppToast`, `TranslationPendingBanner`
**Filters**: `AppDateFilter`, `FilterIconButton`, `FilterSheetActions`
**Feedback**: `AppLoading`, `AppErrorWidget`, `EmptyStateWidget`
**Layout**: `CustomAppBar`, `ResponsiveLayout`, `AuthPatternBackground`
**Viewers**: `PdfViewerPage`, `VideoPlayerPage`, `PhotoPickerBottomSheet`
