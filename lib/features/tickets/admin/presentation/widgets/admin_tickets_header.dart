import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

class AdminTicketsHeader extends StatelessWidget {
  final int totalCount;
  final VoidCallback onCreateTicket;

  const AdminTicketsHeader({
    super.key,
    required this.totalCount,
    required this.onCreateTicket,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Padding(
      padding: EdgeInsets.all(customSpacing.lg),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'All Tickets',
                  style: AppFonts.copyWith(
                    AppFonts.h3(color: AppColors.white),
                    fontWeight: AppFonts.bold,
                  ),
                ),
                SizedBox(height: customSpacing.xs),
                Text(
                  'Employee & Admin Tickets Management',
                  style: AppFonts.bodyLarge(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(
              horizontal: customSpacing.md,
              vertical: customSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: AppColors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.white.withValues(alpha: 0.2)),
            ),
            child: Column(
              children: [
                Text(
                  '$totalCount',
                  style: AppFonts.copyWith(
                    AppFonts.h4(color: AppColors.white),
                    fontWeight: AppFonts.bold,
                  ),
                ),
                Text(
                  'Total Tickets',
                  style: AppFonts.bodySmall(
                    color: AppColors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
