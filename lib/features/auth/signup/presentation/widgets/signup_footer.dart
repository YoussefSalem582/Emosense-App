import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/widgets/auth.dart';

/// Signup footer widget with terms and navigation
class SignupFooter extends StatelessWidget {
  final Animation<double> formAnimation;
  final String selectedRole;
  final VoidCallback onSignup;
  final bool isLoading;
  final bool agreeToTerms;
  final ValueChanged<bool> onAgreeToTermsChanged;
  final VoidCallback onNavigateToLogin;

  const SignupFooter({
    super.key,
    required this.formAnimation,
    required this.selectedRole,
    required this.onSignup,
    required this.isLoading,
    required this.agreeToTerms,
    required this.onAgreeToTermsChanged,
    required this.onNavigateToLogin,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    return Column(
      children: [
        SizedBox(height: isSmallScreen ? 20 : 25),
        _buildTermsCheckbox(),
        SizedBox(height: isSmallScreen ? 20 : 25),
        AuthButtonWidget(
          animation: formAnimation,
          onPressed: agreeToTerms ? onSignup : null,
          text: 'Create $selectedRole Account',
          isLoading: isLoading,
          icon:
              selectedRole == 'Admin'
                  ? Icons.admin_panel_settings
                  : Icons.person_add,
          gradientColors:
              selectedRole == 'Admin'
                  ? [AppColors.accentDark, AppColors.primary]
                  : [AppColors.primary, AppColors.accentDark],
        ),
        SizedBox(height: isSmallScreen ? 20 : 25),
        DividerWidget(animation: formAnimation),
        SizedBox(height: isSmallScreen ? 20 : 25),
        AuthLinkWidget(
          animation: formAnimation,
          leadingText: 'Already have an account? ',
          linkText: 'Sign In',
          onPressed: onNavigateToLogin,
        ),
        SizedBox(height: isSmallScreen ? 30 : 40),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: agreeToTerms,
          onChanged: (value) => onAgreeToTermsChanged(value ?? false),
          fillColor: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return AppColors.primary;
            }
            return null;
          }),
        ),
        Expanded(
          child: RichText(
            text: TextSpan(
              style: AppFonts.bodySmall(
                color: Colors.white.withValues(alpha: 0.7),
              ),
              children: [
                const TextSpan(text: 'I agree to the '),
                TextSpan(
                  text: 'Terms of Service',
                  style: AppFonts.copyWith(
                    AppFonts.bodySmall(color: AppColors.primary),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
                const TextSpan(text: ' and '),
                TextSpan(
                  text: 'Privacy Policy',
                  style: AppFonts.copyWith(
                    AppFonts.bodySmall(color: AppColors.primary),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
