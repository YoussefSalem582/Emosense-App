import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';

class TermsAndConditionsWidget extends StatelessWidget {
  final bool agreeToTerms;
  final ValueChanged<bool> onChanged;
  final Animation<double>? animation;

  const TermsAndConditionsWidget({
    super.key,
    required this.agreeToTerms,
    required this.onChanged,
    this.animation,
  });

  @override
  Widget build(BuildContext context) {
    Widget termsWidget = Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Checkbox(
            value: agreeToTerms,
            onChanged: (value) => onChanged(value ?? false),
            fillColor: WidgetStateProperty.resolveWith<Color>((states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.white;
              }
              return Colors.transparent;
            }),
            checkColor: AppColors.primary,
            side: BorderSide(
              color: Colors.white.withValues(alpha: 0.8),
              width: 2,
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(!agreeToTerms),
              child: Text.rich(
                TextSpan(
                  text: 'I agree to the ',
                  style: AppFonts.bodySmall(
                    color: Colors.white.withValues(alpha: 0.9),
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms of Service',
                      style: AppFonts.copyWith(
                        AppFonts.bodySmall(color: Colors.white),
                        fontWeight: AppFonts.semiBold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                    const TextSpan(text: ' and '),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: AppFonts.copyWith(
                        AppFonts.bodySmall(color: Colors.white),
                        fontWeight: AppFonts.semiBold,
                        decoration: TextDecoration.underline,
                        decorationColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );

    if (animation != null) {
      return AnimatedBuilder(
        animation: animation!,
        builder: (context, child) {
          return Opacity(opacity: animation!.value, child: termsWidget);
        },
      );
    }

    return termsWidget;
  }
}
