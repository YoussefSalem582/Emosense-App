import 'package:flutter/material.dart';

/// App colors — centralized definitions (Emosense palette).
///
/// Theme-oriented helpers ([getBackground], [getSurface], …) complement the
/// existing semantic tokens ([primary], [darkSurface], …).
class AppColors {
  AppColors._();

  // ==================== Brand — primary ====================

  static const Color primary = Color(0xFF2563EB);
  static const Color primaryLight = Color(0xFF3B82F6);
  static const Color primaryDark = Color(0xFF1E40AF);
  static const Color primarySurface = Color(0xFFEFF6FF);

  // ==================== Brand — secondary ====================

  static const Color secondary = Color(0xFF06B6D4);
  static const Color secondaryLight = Color(0xFF22D3EE);
  static const Color secondaryDark = Color(0xFF0891B2);
  static const Color secondarySurface = Color(0xFFECFDF5);

  // ==================== Brand — accent ====================

  static const Color accent = Color(0xFF8B5CF6);
  static const Color accentLight = Color(0xFFA78BFA);
  static const Color accentDark = Color(0xFF7C3AED);
  static const Color accentSurface = Color(0xFFF3F4F6);

  // ==================== Semantic ====================

  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);
  static const Color successSurface = Color(0xFFECFDF5);

  static const Color warning = Color(0xFFF59E0B);
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningSurface = Color(0xFFFFFBEB);

  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorSurface = Color(0xFFFEF2F2);

  static const Color info = Color(0xFF3B82F6);
  static const Color infoSurface = Color(0xFFEFF6FF);

  // ==================== Light theme — surfaces & text ====================

  static const Color background = Color(0xFFFAFBFC);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF8FAFC);
  static const Color surfaceContainer = Color(0xFFF1F5F9);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF475569);
  static const Color textTertiary = Color(0xFF64748B);
  static const Color textLight = Color(0xFF94A3B8);
  static const Color textDisabled = Color(0xFFCBD5E1);

  // ==================== Borders ====================

  static const Color border = Color(0xFFE2E8F0);
  static const Color borderLight = Color(0xFFF1F5F9);
  static const Color borderFocus = Color(0xFF3B82F6);

  // ==================== Dark theme ====================

  static const Color darkBackground = Color(0xFF0F172A);
  static const Color darkSurface = Color(0xFF1E293B);
  static const Color darkSurfaceVariant = Color(0xFF334155);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFFCBD5E1);

  // ==================== Gradients ====================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );

  static const LinearGradient primaryGradientLight = primaryGradient;

  static const LinearGradient primaryGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1E40AF), Color(0xFF1E3A8A)],
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF22D3EE), Color(0xFF06B6D4)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFA78BFA), Color(0xFF8B5CF6)],
  );

  static const LinearGradient accentGradientLight = accentGradient;

  static const LinearGradient accentGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF7C3AED), Color(0xFF6D28D9)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFAFBFC), Color(0xFFF8FAFC)],
  );

  static const LinearGradient cardGradientLight = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceVariant],
  );

  static const LinearGradient cardGradientDark = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [darkSurface, darkSurfaceVariant],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF10B981), Color(0xFF059669)],
  );

  static const LinearGradient warningGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF59E0B), Color(0xFFD97706)],
  );

  static const LinearGradient goldGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
  );

  // ==================== Glass & shadows ====================

  static const Color glass = Color(0x40FFFFFF);
  static const Color glassLight = Color(0x20FFFFFF);
  static const Color glassDark = Color(0x10000000);

  static const Color shadowLight = Color(0x08000000);
  static const Color shadowMedium = Color(0x12000000);
  static const Color shadowDark = Color(0x20000000);

  // ==================== Emotion analytics ====================

  static const Color emotionJoy = Color(0xFFFEF08A);
  static const Color emotionSadness = Color(0xFF93C5FD);
  static const Color emotionAnger = Color(0xFFFCA5A5);
  static const Color emotionFear = Color(0xFFD8B4FE);
  static const Color emotionSurprise = Color(0xFFA7F3D0);
  static const Color emotionDisgust = Color(0xFFFDE047);
  static const Color emotionNeutral = Color(0xFFE5E7EB);

  // ==================== Charts ====================

  static const List<Color> chartColors = [
    Color(0xFF3B82F6),
    Color(0xFF8B5CF6),
    Color(0xFF06B6D4),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFFEC4899),
    Color(0xFF84CC16),
  ];

  // ==================== Legacy aliases ====================

  static const Color positive = success;
  static const Color negative = error;
  static const Color neutral = textTertiary;
  static const Color urgent = error;

  // ==================== Team / misc ====================

  static const Color salesTeam = Color(0xFF8B5CF6);
  static const Color customerServiceTeam = Color(0xFF06B6D4);
  static const Color supportTeam = Color(0xFF10B981);
  static const Color managementTeam = Color(0xFFEF4444);
  static const Color divider = Color(0xFFE5E7EB);

  // ==================== Utility neutrals (gray scale) ====================

  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);

  static const Color transparent = Colors.transparent;
  static const Color black = Colors.black;
  static const Color white = Colors.white;

  // ==================== Color helpers ====================

  static Color withOpacity(Color color, double opacity) {
    return color.withValues(alpha: opacity);
  }

  static Color lighten(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }

  static Color darken(Color color, [double amount = .1]) {
    assert(amount >= 0 && amount <= 1);
    final hsl = HSLColor.fromColor(color);
    final hslDark = hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0));
    return hslDark.toColor();
  }

  // ==================== Theme brightness helpers ====================

  static Color getPrimary(bool isDark) => primary;

  static Color getAccent(bool isDark) => isDark ? accentLight : accent;

  static Color getBackground(bool isDark) =>
      isDark ? darkBackground : background;

  static Color getSurface(bool isDark) => isDark ? darkSurface : surface;

  static Color getTextPrimary(bool isDark) =>
      isDark ? darkTextPrimary : textPrimary;

  static Color getTextSecondary(bool isDark) =>
      isDark ? darkTextSecondary : textSecondary;

  static LinearGradient getPrimaryGradient(bool isDark) =>
      isDark ? primaryGradientDark : primaryGradientLight;

  static LinearGradient getCardGradient(bool isDark) =>
      isDark ? cardGradientDark : cardGradientLight;

  static LinearGradient getAccentGradient(bool isDark) =>
      isDark ? accentGradientDark : accentGradientLight;
}
