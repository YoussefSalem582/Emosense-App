import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_event.dart';
import 'login_state.dart';

/// Local credential screen state ([AuthBloc] remains global).
class LoginBloc extends Bloc<LoginUiEvent, LoginFormUiState> {
  LoginBloc() : super(const LoginFormUiState()) {
    on<LoginRoleLabelChanged>(_onRole);
    on<LoginPasswordVisibilityToggled>(_onTogglePw);
    on<LoginRememberMeChanged>(_onRemember);
  }

  void _onRole(LoginRoleLabelChanged event, Emitter<LoginFormUiState> emit) {
    emit(state.copyWith(selectedRoleLabel: event.label));
  }

  void _onTogglePw(LoginPasswordVisibilityToggled event, Emitter<LoginFormUiState> emit) {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  void _onRemember(LoginRememberMeChanged event, Emitter<LoginFormUiState> emit) {
    emit(state.copyWith(rememberMe: event.value));
  }
}
