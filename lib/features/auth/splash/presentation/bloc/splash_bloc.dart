import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_bloc.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_event.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_state.dart';

import 'splash_event.dart';
import 'splash_state.dart';

/// Orchestrates splash timing and post-animation auth hydration (sub-feature state).
class SplashBloc extends Bloc<SplashEvent, SplashState> {
  SplashBloc({required AuthBloc authBloc})
    : _auth = authBloc,
      super(const SplashInitial()) {
    on<SplashAnimationSequenceCompleted>(_onSequenceCompleted);
  }

  final AuthBloc _auth;

  Future<void> _onSequenceCompleted(
    SplashAnimationSequenceCompleted event,
    Emitter<SplashState> emit,
  ) async {
    emit(const SplashCheckingSession());
    _auth.add(const AuthCheckRequested());
    final next = await _auth.stream.firstWhere(
      (s) =>
          s is AuthAuthenticated ||
          s is AuthUnauthenticated ||
          s is AuthError,
    );

    if (next is AuthAuthenticated) {
      emit(
        SplashNavigate(
          next.user.role == UserRole.admin
              ? SplashDestination.adminDashboard
              : SplashDestination.employeeDashboard,
        ),
      );
      return;
    }

    emit(const SplashNavigate(SplashDestination.onboarding));
  }
}
