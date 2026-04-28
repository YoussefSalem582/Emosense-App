import 'package:equatable/equatable.dart';

abstract class AuthChoiceEvent extends Equatable {
  const AuthChoiceEvent();

  @override
  List<Object?> get props => [];
}

class AuthChoiceLoginTapped extends AuthChoiceEvent {
  const AuthChoiceLoginTapped();
}

class AuthChoiceSignUpTapped extends AuthChoiceEvent {
  const AuthChoiceSignUpTapped();
}

class AuthChoiceBackTapped extends AuthChoiceEvent {
  const AuthChoiceBackTapped();
}

/// Reset [AuthChoiceState.pendingNavigation] after the UI has handled routing.
class AuthChoiceNavigationConsumed extends AuthChoiceEvent {
  const AuthChoiceNavigationConsumed();
}
