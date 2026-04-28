import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/features/auth/onboarding/domain/repositories/onboarding_repository.dart';

import 'onboarding_event.dart';
import 'onboarding_state.dart';

/// Manages pager index persistence and onboarding completion writes.
class OnboardingBloc extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingBloc({required OnboardingRepository onboardingRepository}) : _onboarding = onboardingRepository,
      super(const OnboardingState()) {
    on<OnboardingPageChanged>(_onPageChanged);
    on<OnboardingNextPressed>(_onNext);
    on<OnboardingPreviousPressed>(_onPrev);
    on<OnboardingSkipped>(_onSkipped);
    on<OnboardingCompleted>(_onCompleted);
  }

  final OnboardingRepository _onboarding;

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
    await _onboarding.markCompleted();
    emit(state.copyWith(completedFlow: true));
  }
}
