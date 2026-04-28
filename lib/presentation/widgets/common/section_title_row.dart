import 'package:flutter/material.dart';

import '../../../core/core.dart';

/// Row: leading icon + title + optional trailing (e.g. “View All”).
class AppSectionTitleRow extends StatelessWidget {
  const AppSectionTitleRow({
    super.key,
    required this.icon,
    required this.title,
    this.titleStyle,
    this.iconColor,
    this.iconSize = 24,
    this.trailing,
  });

  final IconData icon;
  final String title;
  final TextStyle? titleStyle;
  final Color? iconColor;
  final double iconSize;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = theme.extension<CustomSpacing>()!;

    return Row(
      children: [
        Icon(icon, color: iconColor ?? AppColors.primary, size: iconSize),
        SizedBox(width: spacing.sm),
        Expanded(
          child: Text(
            title,
            style:
                titleStyle ??
                theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
        if (trailing != null) trailing!,
      ],
    );
  }
}
