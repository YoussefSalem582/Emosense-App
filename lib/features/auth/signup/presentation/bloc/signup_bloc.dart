import 'package:flutter_bloc/flutter_bloc.dart';

import 'signup_event.dart';
import 'signup_state.dart';

/// Sign-up presentation state paired with global [AuthBloc] for mutations.
class SignUpBloc extends Bloc<SignUpUiEvent, SignUpFormUiState> {
  SignUpBloc() : super(const SignUpFormUiState()) {
    on<SignUpRoleLabelChanged>(_onRole);
    on<SignUpPasswordVisibilityToggled>(_onPw);
    on<SignUpConfirmPasswordVisibilityToggled>(_onConfirmPw);
    on<SignUpAgreeToTermsChanged>(_onTerms);
  }

  void _onRole(SignUpRoleLabelChanged event, Emitter<SignUpFormUiState> emit) {
    emit(state.copyWith(selectedRoleLabel: event.label));
  }

  void _onPw(SignUpPasswordVisibilityToggled event, Emitter<SignUpFormUiState> emit) {
    emit(state.copyWith(passwordVisible: !state.passwordVisible));
  }

  void _onConfirmPw(
    SignUpConfirmPasswordVisibilityToggled event,
    Emitter<SignUpFormUiState> emit,
  ) {
    emit(state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible));
  }

  void _onTerms(SignUpAgreeToTermsChanged event, Emitter<SignUpFormUiState> emit) {
    emit(state.copyWith(agreeToTerms: event.value));
  }
}
