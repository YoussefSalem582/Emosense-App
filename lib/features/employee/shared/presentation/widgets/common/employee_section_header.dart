import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

class EmployeeSectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? badgeText;
  final Color? badgeColor;
  final Widget? action;
  final VoidCallback? onActionPressed;
  final String? actionText;
  final IconData? actionIcon;

  const EmployeeSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.badgeText,
    this.badgeColor,
    this.action,
    this.onActionPressed,
    this.actionText,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppFonts.copyWith(
                        AppFonts.h6(color: AppColors.textPrimary),
                        fontWeight: AppFonts.bold,
                      ),
                    ),
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        subtitle!,
                        style: AppFonts.copyWith(
                          AppFonts.bodySmall(color: AppColors.textSecondary),
                          fontWeight: AppFonts.medium,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              if (badgeText != null) ...[
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: (badgeColor ?? AppColors.primary).withValues(
                      alpha: 0.1,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText!,
                    style: AppFonts.copyWith(
                      AppFonts.caption(color: badgeColor ?? AppColors.primary),
                      fontWeight: AppFonts.semiBold,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
              ],
              if (action != null) action!,
              if (action == null &&
                  onActionPressed != null &&
                  actionText != null)
                ElevatedButton.icon(
                  onPressed: onActionPressed!,
                  icon:
                      actionIcon != null
                          ? Icon(actionIcon, size: 16)
                          : const SizedBox.shrink(),
                  label: Text(actionText!),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    minimumSize: const Size(0, 36),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
