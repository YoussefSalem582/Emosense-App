import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  const OnboardingState({
    this.currentPage = 0,
    this.totalPages = OnboardingState.defaultTotalPages,
    this.completedFlow = false,
  });

  static const defaultTotalPages = 4;

  final int currentPage;
  final int totalPages;

  /// When true, onboarding finished and preferences were persisted; listener routes away.
  final bool completedFlow;

  bool get canGoNext => currentPage < totalPages - 1;

  bool get canGoPrevious => currentPage > 0;

  OnboardingState copyWith({
    int? currentPage,
    int? totalPages,
    bool? completedFlow,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      completedFlow: completedFlow ?? this.completedFlow,
    );
  }

  @override
  List<Object?> get props => [currentPage, totalPages, completedFlow];
}
