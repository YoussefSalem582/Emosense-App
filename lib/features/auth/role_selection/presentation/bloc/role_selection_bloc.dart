import 'package:flutter_bloc/flutter_bloc.dart';

import 'role_selection_event.dart';
import 'role_selection_state.dart';

/// Maps button taps to navigation intents (mirrors [AuthChoiceBloc] pattern).
class RoleSelectionBloc extends Bloc<RoleSelectionEvent, RoleSelectionState> {
  RoleSelectionBloc() : super(const RoleSelectionState()) {
    on<RoleSelectionContinueTapped>(_onContinue);
    on<RoleSelectionBackToStartTapped>(_onBack);
    on<RoleSelectionNavigationConsumed>(_onConsumed);
  }

  void _onContinue(RoleSelectionContinueTapped event, Emitter<RoleSelectionState> emit) {
    emit(const RoleSelectionState(pending: RoleSelectionDestination.authChoice));
  }

  void _onBack(RoleSelectionBackToStartTapped event, Emitter<RoleSelectionState> emit) {
    emit(const RoleSelectionState(pending: RoleSelectionDestination.splash));
  }

  void _onConsumed(RoleSelectionNavigationConsumed event, Emitter<RoleSelectionState> emit) {
    emit(const RoleSelectionState());
  }
}
