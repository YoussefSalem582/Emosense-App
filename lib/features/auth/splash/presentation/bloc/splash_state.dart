import 'package:equatable/equatable.dart';

import 'package:emosense_mobile/features/auth/splash/domain/entities/splash_destination.dart';

export 'package:emosense_mobile/features/auth/splash/domain/entities/splash_destination.dart';

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

/// One-shot navigation instruction for the splash screen listener.
class SplashNavigate extends SplashState {
  const SplashNavigate(this.destination);

  final SplashDestination destination;

  @override
  List<Object?> get props => [destination];
}
