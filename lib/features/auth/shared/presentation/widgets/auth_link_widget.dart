import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';

class AuthLinkWidget extends StatelessWidget {
  final Animation<double> animation;
  final String leadingText;
  final String linkText;
  final VoidCallback onPressed;
  final Color textColor;
  final Color linkColor;

  const AuthLinkWidget({
    super.key,
    required this.animation,
    required this.leadingText,
    required this.linkText,
    required this.onPressed,
    this.textColor = Colors.white,
    this.linkColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                leadingText,
                style: AppFonts.bodyMedium(
                  color: textColor.withValues(alpha: 0.8),
                ),
              ),
              TextButton(
                onPressed: onPressed,
                child: Text(
                  linkText,
                  style: AppFonts.copyWith(
                    AppFonts.bodyMedium(color: linkColor),
                    fontWeight: AppFonts.bold,
                    decoration: TextDecoration.underline,
                    decorationColor: linkColor,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
