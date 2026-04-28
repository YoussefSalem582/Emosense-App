abstract class OnboardingLocalDataSource {
  Future<bool?> readCompletedFlag();

  Future<int?> readStoredVersion();

  Future<void> writeCompleted({required bool completed, required int version});
}
