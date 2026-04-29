import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

/// Placeholder screen for screens under development
class PlaceholderScreen extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final bool comingSoon;
  final VoidCallback? onAction;
  final String? actionText;

  const PlaceholderScreen({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.comingSoon = false,
    this.onAction,
    this.actionText,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon Container
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.accent.withValues(alpha: 0.2),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 64, color: AppColors.primary),
              ),

              const SizedBox(height: 32),

              // Title
              Text(
                title,
                style: AppFonts.copyWith(
                  AppFonts.h5(color: AppColors.textPrimary),
                  fontWeight: AppFonts.bold,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              // Description
              Text(
                description,
                style: AppFonts.bodyMedium(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 24),

              // Coming Soon Badge
              if (comingSoon)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Text(
                    'Coming Soon',
                    style: AppFonts.labelLarge(color: AppColors.primary),
                  ),
                ),

              // Action Button
              if (onAction != null && actionText != null) ...[
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    actionText!,
                    style: AppFonts.button(color: Colors.white),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
