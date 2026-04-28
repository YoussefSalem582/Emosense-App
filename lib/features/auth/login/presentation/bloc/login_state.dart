import 'package:equatable/equatable.dart';

class LoginFormUiState extends Equatable {
  const LoginFormUiState({
    this.selectedRoleLabel = 'Employee',
    this.passwordVisible = false,
    this.rememberMe = false,
  });

  final String selectedRoleLabel;
  final bool passwordVisible;
  final bool rememberMe;

  LoginFormUiState copyWith({
    String? selectedRoleLabel,
    bool? passwordVisible,
    bool? rememberMe,
  }) {
    return LoginFormUiState(
      selectedRoleLabel: selectedRoleLabel ?? this.selectedRoleLabel,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [selectedRoleLabel, passwordVisible, rememberMe];
}
