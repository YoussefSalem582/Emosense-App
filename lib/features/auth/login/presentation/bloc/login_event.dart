import 'package:equatable/equatable.dart';

abstract class LoginUiEvent extends Equatable {
  const LoginUiEvent();

  @override
  List<Object?> get props => [];
}

class LoginRoleLabelChanged extends LoginUiEvent {
  const LoginRoleLabelChanged(this.label);

  final String label;

  @override
  List<Object?> get props => [label];
}

class LoginPasswordVisibilityToggled extends LoginUiEvent {
  const LoginPasswordVisibilityToggled();
}

class LoginRememberMeChanged extends LoginUiEvent {
  const LoginRememberMeChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}
