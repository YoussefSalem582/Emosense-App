import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';

/// Auth choice buttons widget
class AuthChoiceButtons extends StatelessWidget {
  final Animation<double> cardScaleAnimation;
  final VoidCallback onLoginPressed;
  final VoidCallback onSignUpPressed;

  const AuthChoiceButtons({
    super.key,
    required this.cardScaleAnimation,
    required this.onLoginPressed,
    required this.onSignUpPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: cardScaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: cardScaleAnimation.value,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 32),
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.95),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                  spreadRadius: 0,
                ),
              ],
            ),
            child: Column(
              children: [
                // Login Button
                _buildAuthButton(
                  title: 'Sign In',
                  subtitle: 'Access your existing account',
                  icon: Icons.login,
                  color: AppColors.primary,
                  onPressed: onLoginPressed,
                ),

                const SizedBox(height: 20),

                // Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'OR',
                        style: AppFonts.labelMedium(
                          color: AppColors.gray600,
                        ).copyWith(fontWeight: AppFonts.medium),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),

                const SizedBox(height: 20),

                // Sign Up Button
                _buildAuthButton(
                  title: 'Sign Up',
                  subtitle: 'Create a new account',
                  icon: Icons.person_add,
                  color: AppColors.accentDark,
                  onPressed: onSignUpPressed,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAuthButton({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 2,
          shadowColor: color.withValues(alpha: 0.3),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.copyWith(
                      AppFonts.bodyLarge(color: Colors.white),
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: AppFonts.bodySmall(
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ],
        ),
      ),
    );
  }
}
