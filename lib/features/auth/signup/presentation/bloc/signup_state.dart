import 'package:equatable/equatable.dart';

class SignUpFormUiState extends Equatable {
  const SignUpFormUiState({
    this.selectedRoleLabel = 'Employee',
    this.passwordVisible = false,
    this.confirmPasswordVisible = false,
    this.agreeToTerms = false,
  });

  final String selectedRoleLabel;
  final bool passwordVisible;
  final bool confirmPasswordVisible;
  final bool agreeToTerms;

  SignUpFormUiState copyWith({
    String? selectedRoleLabel,
    bool? passwordVisible,
    bool? confirmPasswordVisible,
    bool? agreeToTerms,
  }) {
    return SignUpFormUiState(
      selectedRoleLabel: selectedRoleLabel ?? this.selectedRoleLabel,
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible: confirmPasswordVisible ?? this.confirmPasswordVisible,
      agreeToTerms: agreeToTerms ?? this.agreeToTerms,
    );
  }

  @override
  List<Object?> get props => [
        selectedRoleLabel,
        passwordVisible,
        confirmPasswordVisible,
        agreeToTerms,
      ];
}
