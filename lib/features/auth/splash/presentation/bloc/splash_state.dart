import 'package:equatable/equatable.dart';

abstract class SplashState extends Equatable {
  const SplashState();

  @override
  List<Object?> get props => [];
}

class SplashInitial extends SplashState {
  const SplashInitial();
}

class SplashCheckingSession extends SplashState {
  const SplashCheckingSession();
}

enum SplashDestination { onboarding, adminDashboard, employeeDashboard }

/// One-shot navigation instruction for the splash screen listener.
class SplashNavigate extends SplashState {
  const SplashNavigate(this.destination);

  final SplashDestination destination;

  @override
  List<Object?> get props => [destination];
}
