import 'package:equatable/equatable.dart';

abstract class SignUpUiEvent extends Equatable {
  const SignUpUiEvent();

  @override
  List<Object?> get props => [];
}

class SignUpRoleLabelChanged extends SignUpUiEvent {
  const SignUpRoleLabelChanged(this.label);

  final String label;

  @override
  List<Object?> get props => [label];
}

class SignUpPasswordVisibilityToggled extends SignUpUiEvent {
  const SignUpPasswordVisibilityToggled();
}

class SignUpConfirmPasswordVisibilityToggled extends SignUpUiEvent {
  const SignUpConfirmPasswordVisibilityToggled();
}

class SignUpAgreeToTermsChanged extends SignUpUiEvent {
  const SignUpAgreeToTermsChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}
