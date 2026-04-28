import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/onboarding_preferences.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Manages pager index persistence and onboarding completion writes.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc() : super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNext);
    on<OnboardingPreviousPressed>(_onPrev);
    on<OnboardingSkipped>(_onSkipped);
    on<OnboardingCompleted>(_onCompleted);
  }

  void _onPageChanged(OnboardingPageChanged event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(currentPage: event.index));
  }

  Future<void> _onNext(OnboardingNextPressed event, Emitter<OnboardingState> emit) async {
    if (state.canGoNext) {
      emit(state.copyWith(currentPage: state.currentPage + 1));
      return;
    }
    await _persistComplete(emit);
  }

  Future<void> _onPrev(OnboardingPreviousPressed event, Emitter<OnboardingState> emit) async {
    if (!state.canGoPrevious) return;
    emit(state.copyWith(currentPage: state.currentPage - 1));
  }

  Future<void> _onSkipped(OnboardingSkipped event, Emitter<OnboardingState> emit) async {
    await _persistComplete(emit);
  }

  Future<void> _onCompleted(OnboardingCompleted event, Emitter<OnboardingState> emit) async {
    await _persistComplete(emit);
  }

  Future<void> _persistComplete(Emitter<OnboardingState> emit) async {
    await OnboardingPreferences.setOnboardingCompleted();
    emit(state.copyWith(completedFlow: true));
  }
}
