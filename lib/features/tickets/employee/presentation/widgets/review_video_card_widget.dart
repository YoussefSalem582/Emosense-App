import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/surface_section_card.dart';

class ReviewVideoCardWidget extends StatelessWidget {
  final Map<String, dynamic> video;
  final CustomSpacing spacing;
  final VoidCallback onTap;

  const ReviewVideoCardWidget({
    super.key,
    required this.video,
    required this.spacing,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final priorityColor = _getPriorityColor(video['priority']);
    final statusColor = _getStatusColor(video['status']);

    return SurfaceSectionCard(
      margin: EdgeInsets.only(bottom: spacing.md),
      padding: EdgeInsets.all(spacing.md),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              // Video ID
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  video['id'],
                  style: AppFonts.copyWith(
                    AppFonts.caption(color: AppColors.primary),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),

              SizedBox(width: spacing.sm),

              // Priority Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: priorityColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _getPriorityIcon(video['priority']),
                      color: priorityColor,
                      size: 12,
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      video['priority'],
                      style: AppFonts.copyWith(
                        AppFonts.caption(color: priorityColor),
                        fontWeight: AppFonts.semiBold,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Status Badge
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.sm,
                  vertical: spacing.xs,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  video['status'],
                  style: AppFonts.copyWith(
                    AppFonts.caption(color: statusColor),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.md),

          // Video Title and Channel
          Text(
            video['title'],
            style: AppFonts.copyWith(
              AppFonts.bodyLarge(color: AppColors.textPrimary),
              fontWeight: AppFonts.bold,
            ),
          ),

          SizedBox(height: spacing.xs),

          // Channel Info
          Row(
            children: [
              Icon(
                Icons.youtube_searched_for,
                size: 16,
                color: AppColors.error,
              ),
              SizedBox(width: spacing.xs),
              Text(
                video['channel'],
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.textSecondary),
                  fontWeight: AppFonts.medium,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          SizedBox(height: spacing.sm),

          // Description
          Text(
            video['description'],
            style: AppFonts.bodySmall(color: AppColors.textSecondary),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          SizedBox(height: spacing.md),

          // Footer Row
          Row(
            children: [
              // Reviewer Name
              Icon(
                Icons.person_outline,
                size: 16,
                color: AppColors.textTertiary,
              ),
              SizedBox(width: spacing.xs),
              Text(
                video['reviewer'],
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.textSecondary),
                  fontWeight: AppFonts.medium,
                  fontSize: 13,
                ),
              ),

              SizedBox(width: spacing.md),

              // Time
              Icon(Icons.schedule, size: 16, color: AppColors.textTertiary),
              SizedBox(width: spacing.xs),
              Text(
                video['created'],
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.textSecondary),
                  fontSize: 13,
                ),
              ),

              SizedBox(width: spacing.md),

              // Views
              Icon(Icons.visibility, size: 16, color: AppColors.textTertiary),
              SizedBox(width: spacing.xs),
              Text(
                video['views'],
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.textSecondary),
                  fontSize: 13,
                ),
              ),

              const Spacer(),

              // Action Button
              GestureDetector(
                onTap: onTap,
                child: Container(
                  padding: EdgeInsets.all(spacing.sm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.play_arrow,
                    color: AppColors.primary,
                    size: 14,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getPriorityIcon(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Icons.priority_high;
      case 'medium':
        return Icons.remove;
      case 'low':
        return Icons.keyboard_arrow_down;
      default:
        return Icons.help_outline;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'new':
        return Colors.blue;
      case 'under review':
        return Colors.orange;
      case 'completed':
        return Colors.green;
      case 'archived':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }
}
