import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_local_data_source.dart';

/// SharedPreferences-backed onboarding flags.
class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const String _completedKey = 'onboarding_completed';
  static const String _versionKey = 'onboarding_version';

  /// Minimum content version treated as satisfied for [isFullyCompleted].
  static const int currentOnboardingVersion = 1;

  @override
  Future<bool?> readCompletedFlag() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_completedKey);
  }

  @override
  Future<int?> readStoredVersion() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_versionKey);
  }

  @override
  Future<void> writeCompleted({required bool completed, required int version}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_completedKey, completed);
    await prefs.setInt(_versionKey, version);
  }
}
