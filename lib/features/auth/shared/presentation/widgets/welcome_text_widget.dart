import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';

class WelcomeTextWidget extends StatelessWidget {
  final Animation<double> animation;
  final String title;
  final String subtitle;
  final TextAlign textAlign;

  const WelcomeTextWidget({
    super.key,
    required this.animation,
    required this.title,
    required this.subtitle,
    this.textAlign = TextAlign.center,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: Column(
              children: [
                Text(
                  title,
                  style: AppFonts.copyWith(
                    AppFonts.h4(color: Colors.white),
                    fontSize: 28,
                    fontWeight: AppFonts.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  textAlign: textAlign,
                ),
                const SizedBox(height: 8),
                Text(
                  subtitle,
                  style: AppFonts.copyWith(
                    AppFonts.bodyMedium(
                      color: Colors.white.withValues(alpha: 0.9),
                    ),
                    fontSize: 15,
                  ),
                  textAlign: textAlign,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
