import '../../domain/repositories/onboarding_repository.dart';
import '../datasources/onboarding_local_data_source.dart';
import '../datasources/onboarding_local_data_source_impl.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  OnboardingRepositoryImpl({OnboardingLocalDataSource? local})
    : _local = local ?? OnboardingLocalDataSourceImpl();

  final OnboardingLocalDataSource _local;

  @override
  int get currentOnboardingVersion => OnboardingLocalDataSourceImpl.currentOnboardingVersion;

  @override
  Future<int> getCompletedOnboardingVersion() async {
    try {
      return await _local.readStoredVersion() ?? 0;
    } catch (_) {
      return 0;
    }
  }

  @override
  Future<bool> isOnboardingCompleted() async {
    try {
      final isCompleted = await _local.readCompletedFlag() ?? false;
      final version = await _local.readStoredVersion() ?? 0;
      return isCompleted && version >= currentOnboardingVersion;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> markCompleted() async {
    try {
      await _local.writeCompleted(
        completed: true,
        version: currentOnboardingVersion,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> resetProgress() async {
    try {
      await _local.writeCompleted(completed: false, version: 0);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Future<bool> shouldShowOnboarding() async => !(await isOnboardingCompleted());
}
