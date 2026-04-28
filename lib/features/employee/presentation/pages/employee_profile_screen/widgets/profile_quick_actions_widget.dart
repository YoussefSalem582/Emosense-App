import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/presentation/widgets/common/profile_section_card.dart';
import 'package:emosense_mobile/presentation/widgets/common/section_title_row.dart';

class ProfileQuickActionsWidget extends StatelessWidget {
  final VoidCallback onEditProfile;
  final VoidCallback onChangePassword;
  final VoidCallback onTimeOffRequest;
  final VoidCallback onHelpSupport;
  final VoidCallback onSignOut;

  const ProfileQuickActionsWidget({
    super.key,
    required this.onEditProfile,
    required this.onChangePassword,
    required this.onTimeOffRequest,
    required this.onHelpSupport,
    required this.onSignOut,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionTitleRow(
            icon: Icons.flash_on,
            title: 'Quick Actions',
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildActionItem(
            'Edit Profile',
            Icons.edit_outlined,
            onEditProfile,
            AppColors.primary,
          ),
          _buildActionItem(
            'Change Password',
            Icons.lock_outline,
            onChangePassword,
            AppColors.secondary,
          ),
          _buildActionItem(
            'Request Time Off',
            Icons.calendar_month_outlined,
            onTimeOffRequest,
            AppColors.info,
          ),
          _buildActionItem(
            'Help & Support',
            Icons.help_outline,
            onHelpSupport,
            AppColors.warning,
          ),
          const Divider(height: 24),
          _buildActionItem(
            'Sign Out',
            Icons.logout,
            onSignOut,
            AppColors.error,
          ),
        ],
      ),
    );
  }

  Widget _buildActionItem(
    String title,
    IconData icon,
    VoidCallback onTap,
    Color color,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}
