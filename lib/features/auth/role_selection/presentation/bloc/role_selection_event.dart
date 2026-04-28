import 'package:equatable/equatable.dart';

abstract class RoleSelectionEvent extends Equatable {
  const RoleSelectionEvent();

  @override
  List<Object?> get props => [];
}

class RoleSelectionContinueTapped extends RoleSelectionEvent {
  const RoleSelectionContinueTapped();
}

class RoleSelectionBackToStartTapped extends RoleSelectionEvent {
  const RoleSelectionBackToStartTapped();
}

/// Clear [RoleSelectionState.pending] after handling routing in the UI.
class RoleSelectionNavigationConsumed extends RoleSelectionEvent {
  const RoleSelectionNavigationConsumed();
}
