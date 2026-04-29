import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';

/// Splash screen text widget with animations
class SplashText extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const SplashText({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([fadeAnimation, slideAnimation]),
      builder: (context, child) {
        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: Column(
              children: [
                // App Name with enhanced gradient
                ShaderMask(
                  shaderCallback:
                      (bounds) => const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.primary,
                          AppColors.accent,
                          AppColors.primary,
                        ],
                      ).createShader(bounds),
                  child: Text(
                    'EmoSense',
                    style: AppFonts.copyWith(
                      AppFonts.h2(color: Colors.white),
                      fontSize: 36,
                      fontWeight: AppFonts.bold,
                      letterSpacing: 1.5,
                      shadows: const [
                        Shadow(
                          color: Colors.black26,
                          offset: Offset(0, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Tagline with better styling
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    'AI-Powered Emotional Intelligence',
                    style: AppFonts.copyWith(
                      AppFonts.bodyMedium(color: AppColors.textSecondary),
                      fontWeight: AppFonts.semiBold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Version or additional info
                Text(
                  'Version 1.0.0',
                  style: AppFonts.caption(color: AppColors.textLight),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
