import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_locale_binding.dart';

/// App fonts — centralized typography (Latin: Inter; Arabic: Tajawal).
///
/// Matches [AppTheme]’s default Latin family. Register Tajawal in `pubspec.yaml`
/// when bundling Arabic; until then the system may fall back.
class AppFonts {
  AppFonts._();

  static const String _latinFamily = 'Inter';
  static const String _arabicFamily = 'Tajawal';

  // ==================== Font families ====================

  static String get primaryFont =>
      AppLocaleBinding.isArabic ? _arabicFamily : _latinFamily;

  static String get secondaryFont =>
      AppLocaleBinding.isArabic ? _arabicFamily : _latinFamily;

  // ==================== Font weights ====================

  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // ==================== Font sizes ====================

  static const double sizeXS = 10;
  static const double sizeS = 12;
  static const double sizeM = 14;
  static const double sizeL = 16;
  static const double sizeXL = 18;
  static const double sizeH6 = 20;
  static const double sizeH5 = 24;
  static const double sizeH4 = 28;
  static const double sizeH3 = 32;
  static const double sizeH2 = 40;
  static const double sizeH1 = 48;
  static const double sizeDisplay = 56;

  // ==================== Line heights ====================

  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.4;
  static const double lineHeightRelaxed = 1.5;
  static const double lineHeightLoose = 1.6;

  static FontWeight _tajawalWeight(FontWeight w) {
    final v = w.value;
    if (v <= 450) return FontWeight.w400;
    if (v <= 550) return FontWeight.w500;
    return FontWeight.w700;
  }

  static TextStyle _arabicText({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
    TextBaseline? textBaseline,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: _arabicFamily,
      fontSize: fontSize,
      fontWeight: _tajawalWeight(fontWeight),
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      textBaseline: textBaseline,
      fontStyle: fontStyle,
    );
  }

  static TextStyle _latinText({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
    TextBaseline? textBaseline,
    FontStyle? fontStyle,
  }) {
    return TextStyle(
      fontFamily: _latinFamily,
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      textBaseline: textBaseline,
      fontStyle: fontStyle,
    );
  }

  static TextStyle _primaryStyle({
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? height,
    double? letterSpacing,
    TextBaseline? textBaseline,
    FontStyle? fontStyle,
  }) {
    if (AppLocaleBinding.isArabic) {
      return _arabicText(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
        height: height,
        letterSpacing: letterSpacing,
        textBaseline: textBaseline,
        fontStyle: fontStyle,
      );
    }
    return _latinText(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      textBaseline: textBaseline,
      fontStyle: fontStyle,
    );
  }

  // ==================== Headings ====================

  static TextStyle displayLarge({Color? color}) => _primaryStyle(
        fontSize: sizeDisplay,
        fontWeight: bold,
        color: color,
        height: lineHeightTight,
      );

  static TextStyle h1({Color? color}) => _primaryStyle(
        fontSize: sizeH1,
        fontWeight: bold,
        color: color,
        height: lineHeightTight,
      );

  static TextStyle h2({Color? color}) => _primaryStyle(
        fontSize: sizeH2,
        fontWeight: bold,
        color: color,
        height: lineHeightTight,
      );

  static TextStyle h3({Color? color}) => _primaryStyle(
        fontSize: sizeH3,
        fontWeight: bold,
        color: color,
        height: lineHeightNormal,
      );

  static TextStyle h4({Color? color}) => _primaryStyle(
        fontSize: sizeH4,
        fontWeight: semiBold,
        color: color,
        height: lineHeightNormal,
      );

  static TextStyle h5({Color? color}) => _primaryStyle(
        fontSize: sizeH5,
        fontWeight: semiBold,
        color: color,
        height: lineHeightNormal,
      );

  static TextStyle h6({Color? color}) => _primaryStyle(
        fontSize: sizeH6,
        fontWeight: semiBold,
        color: color,
        height: lineHeightRelaxed,
      );

  // ==================== Body ====================

  static TextStyle bodyLarge({Color? color}) => _primaryStyle(
        fontSize: sizeXL,
        fontWeight: regular,
        color: color,
        height: lineHeightLoose,
      );

  static TextStyle bodyMedium({Color? color}) => _primaryStyle(
        fontSize: sizeL,
        fontWeight: regular,
        color: color,
        height: lineHeightLoose,
      );

  static TextStyle bodySmall({Color? color}) => _primaryStyle(
        fontSize: sizeM,
        fontWeight: regular,
        color: color,
        height: lineHeightLoose,
      );

  static TextStyle bodyXS({Color? color}) => _primaryStyle(
        fontSize: sizeS,
        fontWeight: regular,
        color: color,
        height: lineHeightNormal,
      );

  // ==================== Special ====================

  static TextStyle button({Color? color}) => _primaryStyle(
        fontSize: sizeL,
        fontWeight: semiBold,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle caption({Color? color}) => _primaryStyle(
        fontSize: sizeS,
        fontWeight: regular,
        color: color,
        height: lineHeightNormal,
      );

  static TextStyle overline({Color? color}) => _primaryStyle(
        fontSize: sizeXS,
        fontWeight: medium,
        color: color,
        letterSpacing: 1.5,
        height: lineHeightNormal,
        textBaseline: TextBaseline.alphabetic,
      );

  static TextStyle labelLarge({Color? color}) => _primaryStyle(
        fontSize: sizeM,
        fontWeight: medium,
        color: color,
        letterSpacing: 0.1,
      );

  static TextStyle labelMedium({Color? color}) => _primaryStyle(
        fontSize: sizeS,
        fontWeight: medium,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle labelSmall({Color? color}) => _primaryStyle(
        fontSize: sizeXS,
        fontWeight: medium,
        color: color,
        letterSpacing: 0.5,
      );

  static TextStyle code({Color? color, double? fontSize}) {
    return TextStyle(
      fontFamily: 'monospace',
      fontSize: fontSize ?? sizeM,
      fontWeight: regular,
      color: color,
      height: lineHeightRelaxed,
    );
  }

  // ==================== Responsive ====================

  static TextStyle responsiveH1(double screenWidth, {Color? color}) {
    final fontSize = screenWidth < 600
        ? 32.0
        : screenWidth < 900
            ? 40.0
            : sizeH1;
    return _primaryStyle(
      fontSize: fontSize,
      fontWeight: bold,
      color: color,
      height: lineHeightTight,
    );
  }

  static TextStyle responsiveH2(double screenWidth, {Color? color}) {
    final fontSize = screenWidth < 600
        ? 28.0
        : screenWidth < 900
            ? 32.0
            : sizeH2;
    return _primaryStyle(
      fontSize: fontSize,
      fontWeight: bold,
      color: color,
      height: lineHeightTight,
    );
  }

  static TextStyle responsiveH3(double screenWidth, {Color? color}) {
    final fontSize = screenWidth < 600
        ? 24.0
        : screenWidth < 900
            ? 28.0
            : sizeH3;
    return _primaryStyle(
      fontSize: fontSize,
      fontWeight: bold,
      color: color,
      height: lineHeightNormal,
    );
  }

  static TextStyle responsiveBody(double screenWidth, {Color? color}) {
    final fontSize = screenWidth < 600
        ? sizeM
        : screenWidth < 900
            ? sizeL
            : sizeXL;
    return _primaryStyle(
      fontSize: fontSize,
      fontWeight: regular,
      color: color,
      height: lineHeightLoose,
    );
  }

  // ==================== Theme-aware ====================

  static TextStyle h1ForTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return h1(color: AppColors.getTextPrimary(isDark));
  }

  static TextStyle h2ForTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return h2(color: AppColors.getTextPrimary(isDark));
  }

  static TextStyle h3ForTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return h3(color: AppColors.getTextPrimary(isDark));
  }

  static TextStyle h4ForTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return h4(color: AppColors.getTextPrimary(isDark));
  }

  static TextStyle h5ForTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return h5(color: AppColors.getTextPrimary(isDark));
  }

  static TextStyle h6ForTheme(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return h6(color: AppColors.getTextPrimary(isDark));
  }

  static TextStyle bodyForTheme(
    BuildContext context, {
    bool isLarge = false,
    bool isSecondary = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSecondary
        ? AppColors.getTextSecondary(isDark)
        : AppColors.getTextPrimary(isDark);
    return isLarge ? bodyLarge(color: color) : bodyMedium(color: color);
  }

  static TextStyle bodySmallForTheme(
    BuildContext context, {
    bool isSecondary = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isSecondary
        ? AppColors.getTextSecondary(isDark)
        : AppColors.getTextPrimary(isDark);
    return bodySmall(color: color);
  }

  // ==================== Utilities ====================

  static TextStyle copyWith(
    TextStyle style, {
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    double? height,
    double? letterSpacing,
    TextDecoration? decoration,
    Color? decorationColor,
    List<Shadow>? shadows,
  }) {
    return style.copyWith(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
      letterSpacing: letterSpacing,
      decoration: decoration,
      decorationColor: decorationColor,
      shadows: shadows,
    );
  }

  static ShaderMask applyGradient({
    required Widget child,
    required Gradient gradient,
  }) {
    return ShaderMask(
      shaderCallback: (bounds) => gradient.createShader(bounds),
      child: child,
    );
  }
}
