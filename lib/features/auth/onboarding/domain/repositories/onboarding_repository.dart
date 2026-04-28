/// Persisted onboarding progress and completion (shared prefs-backed in data layer).
abstract class OnboardingRepository {
  int get currentOnboardingVersion;

  Future<bool> isOnboardingCompleted();

  Future<bool> markCompleted();

  Future<bool> resetProgress();

  Future<int> getCompletedOnboardingVersion();

  Future<bool> shouldShowOnboarding();
}
