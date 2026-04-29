import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/profile_section_card.dart';
import 'package:emosense_mobile/core/widgets/common/section_title_row.dart';

class ProfileWorkInfoWidget extends StatelessWidget {
  final String startDate;
  final String location;
  final String manager;
  final String team;

  const ProfileWorkInfoWidget({
    super.key,
    required this.startDate,
    required this.location,
    required this.manager,
    required this.team,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionTitleRow(
            icon: Icons.work_outline,
            title: 'Work Information',
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Start Date', startDate),
          _buildInfoItem('Location', location),
          _buildInfoItem('Manager', manager),
          _buildInfoItem('Team', team),
        ],
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: AppFonts.copyWith(
                AppFonts.bodySmall(color: AppColors.textSecondary),
                fontWeight: AppFonts.medium,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppFonts.copyWith(
                AppFonts.bodySmall(color: AppColors.textPrimary),
                fontWeight: AppFonts.semiBold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
