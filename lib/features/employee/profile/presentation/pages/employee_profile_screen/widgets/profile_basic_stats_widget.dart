import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/profile_section_card.dart';
import 'package:emosense_mobile/core/widgets/common/section_title_row.dart';

class ProfileBasicStatsWidget extends StatelessWidget {
  final int ticketsResolved;
  final double customerRating;
  final String responseTime;

  const ProfileBasicStatsWidget({
    super.key,
    required this.ticketsResolved,
    required this.customerRating,
    required this.responseTime,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionTitleRow(
            icon: Icons.bar_chart,
            title: 'Activity Overview',
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Tickets Resolved',
                  ticketsResolved.toString(),
                  Icons.check_circle,
                  AppColors.primary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildStatItem(
                  'Customer Rating',
                  customerRating.toString(),
                  Icons.star,
                  AppColors.warning,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Center(
            child: _buildStatItem(
              'Avg Response Time',
              responseTime,
              Icons.timer,
              AppColors.info,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
