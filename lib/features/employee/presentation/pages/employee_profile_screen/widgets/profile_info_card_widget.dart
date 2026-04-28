import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/presentation/widgets/common/profile_section_card.dart';
import 'package:emosense_mobile/presentation/widgets/common/section_title_row.dart';

class ProfileInfoCardWidget extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<ProfileInfoItem> items;

  const ProfileInfoCardWidget({
    super.key,
    required this.title,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionTitleRow(
            icon: icon,
            title: title,
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          ...items.map(
            (item) => _buildInfoRow(context, item.label, item.value),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ProfileInfoItem {
  final String label;
  final String value;

  const ProfileInfoItem({required this.label, required this.value});
}
