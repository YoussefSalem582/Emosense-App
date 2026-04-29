import 'package:flutter/widgets.dart';

/// Lightweight locale hint for static typography helpers ([AppFonts]).
///
/// For Material [Locale] resolution in widgets, prefer [Localizations.localeOf].
/// Call [setLocaleOverride] from the app root when the user changes language
/// so [isArabic] matches [MaterialApp.locale] without a [BuildContext].
class AppLocaleBinding {
  AppLocaleBinding._();

  static Locale? _localeOverride;

  /// Clears override so [isArabic] uses [PlatformDispatcher.locale] again.
  static void clearLocaleOverride() => _localeOverride = null;

  /// Optional sync with [MaterialApp.locale] / user selection.
  static void setLocaleOverride(Locale? locale) => _localeOverride = locale;

  static bool get isArabic {
    final locale =
        _localeOverride ?? WidgetsBinding.instance.platformDispatcher.locale;
    return locale.languageCode.toLowerCase().startsWith('ar');
  }
}
