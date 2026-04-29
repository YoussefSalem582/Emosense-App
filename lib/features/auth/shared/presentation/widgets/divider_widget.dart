import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';

class DividerWidget extends StatelessWidget {
  final Animation<double> animation;
  final String text;
  final Color color;
  final double opacity;

  const DividerWidget({
    super.key,
    required this.animation,
    this.text = 'OR',
    this.color = AppColors.white,
    this.opacity = 0.3,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Opacity(
          opacity: animation.value,
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 1,
                  color: color.withValues(alpha: opacity),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  text,
                  style: AppFonts.copyWith(
                    AppFonts.labelMedium(color: color.withValues(alpha: 0.8)),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: 1,
                  color: color.withValues(alpha: opacity),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
