import 'package:flutter_bloc/flutter_bloc.dart';

import 'auth_choice_event.dart';
import 'auth_choice_state.dart';

/// Lightweight navigation intents for auth entry (presentation-only).
class AuthChoiceBloc extends Bloc<AuthChoiceEvent, AuthChoiceState> {
  AuthChoiceBloc() : super(const AuthChoiceState()) {
    on<AuthChoiceLoginTapped>(_onLogin);
    on<AuthChoiceSignUpTapped>(_onSignUp);
    on<AuthChoiceBackTapped>(_onBack);
    on<AuthChoiceNavigationConsumed>(_onConsumed);
  }

  void _onLogin(AuthChoiceLoginTapped event, Emitter<AuthChoiceState> emit) {
    emit(const AuthChoiceState(pending: AuthChoiceDestination.login));
  }

  void _onSignUp(AuthChoiceSignUpTapped event, Emitter<AuthChoiceState> emit) {
    emit(const AuthChoiceState(pending: AuthChoiceDestination.signup));
  }

  void _onBack(AuthChoiceBackTapped event, Emitter<AuthChoiceState> emit) {
    emit(const AuthChoiceState(pending: AuthChoiceDestination.onboarding));
  }

  void _onConsumed(AuthChoiceNavigationConsumed event, Emitter<AuthChoiceState> emit) {
    emit(const AuthChoiceState());
  }
}
