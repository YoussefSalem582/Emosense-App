import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/features/auth/splash/domain/abstractions/splash_navigation_resolver.dart';

import 'splash_event.dart';
import 'splash_state.dart';

/// Orchestrates splash timing and post-animation auth hydration (sub-feature state).
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({required SplashNavigationResolver navigationResolver})
    : _navigator = navigationResolver,
      super(const SplashInitial()) {
    on<SplashAnimationSequenceCompleted>(_onSequenceCompleted);
  }

  final SplashNavigationResolver _navigator;

  Future<void> _onSequenceCompleted(
    SplashAnimationSequenceCompleted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashCheckingSession());

    try {
      final destination = await _navigator.resolveAfterHydration();
      emit(SplashNavigate(destination));
    } catch (_) {
      emit(const SplashNavigate(SplashDestination.onboarding));
    }
  }
}
