import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class GoalsAndTargets extends StatelessWidget {
  final CustomSpacing customSpacing;
  final Animation<double> cardAnimation;

  const GoalsAndTargets({
    super.key,
    required this.customSpacing,
    required this.cardAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Goals & Targets',
            style: AppFonts.copyWith(
              AppFonts.bodyMedium(color: AppColors.textPrimary),
              fontWeight: AppFonts.bold,
            ),
          ),
          SizedBox(height: customSpacing.lg),

          _buildGoalProgress('Ticket Efficiency', 0.87, '> 85%', '87% current'),
          SizedBox(height: customSpacing.md),
          _buildGoalProgress('Resolution Rate', 0.94, '> 90%', '94% current'),
          SizedBox(height: customSpacing.md),
          _buildGoalProgress(
            'Customer Satisfaction',
            0.96,
            '> 4.5/5',
            '4.8/5 current',
          ),
          SizedBox(height: customSpacing.md),
          _buildGoalProgress(
            'Daily Tickets',
            0.75,
            '20 tickets',
            '15 completed today',
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(
    String title,
    double progress,
    String target,
    String current,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: AppFonts.copyWith(
                AppFonts.bodySmall(color: AppColors.textPrimary),
                fontWeight: AppFonts.semiBold,
              ),
            ),
            Text(
              target,
              style: AppFonts.caption(color: AppColors.textSecondary),
            ),
          ],
        ),
        SizedBox(height: customSpacing.xs),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress * cardAnimation.value,
            backgroundColor: AppColors.surfaceContainer,
            valueColor: AlwaysStoppedAnimation<Color>(
              progress >= 0.9
                  ? AppColors.success
                  : progress >= 0.7
                  ? AppColors.warning
                  : AppColors.error,
            ),
            minHeight: 6,
          ),
        ),
        SizedBox(height: customSpacing.xs),
        Text(
          current,
          style: AppFonts.copyWith(
            AppFonts.labelSmall(
              color:
                  progress >= 0.9
                      ? AppColors.success
                      : progress >= 0.7
                      ? AppColors.warning
                      : AppColors.error,
            ),
            fontWeight: AppFonts.medium,
          ),
        ),
      ],
    );
  }
}
