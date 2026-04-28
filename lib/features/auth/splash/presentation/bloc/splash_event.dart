import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

/// Fired when intro animations finished and session check should run.
class SplashAnimationSequenceCompleted extends SplashEvent {
  const SplashAnimationSequenceCompleted();
}
