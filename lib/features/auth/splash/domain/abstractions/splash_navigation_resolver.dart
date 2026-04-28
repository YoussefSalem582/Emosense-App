import '../entities/splash_destination.dart';

/// Resolves persisted session into a post-splash navigation target using global auth hydration.
abstract class SplashNavigationResolver {
  Future<SplashDestination> resolveAfterHydration();
}
