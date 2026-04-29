import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

/// Helper class for admin navigation dialogs
class AdminDialogs {
  /// Show admin notifications dialog
  static void showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.admin_panel_settings, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('Admin Notifications'),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.error,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '2',
                    style: AppFonts.copyWith(
                      AppFonts.caption(color: AppColors.white),
                      fontWeight: AppFonts.bold,
                    ),
                  ),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildNotificationItem(
                    'System Alert',
                    'High CPU usage detected on server cluster 2',
                    '10 minutes ago',
                    Icons.warning,
                    AppColors.warning,
                    isUnread: true,
                    isUrgent: true,
                  ),
                  const Divider(height: 1),
                  _buildNotificationItem(
                    'User Report',
                    'New user registration requires approval',
                    '1 hour ago',
                    Icons.person_add,
                    AppColors.info,
                    isUnread: true,
                  ),
                  const Divider(height: 1),
                  _buildNotificationItem(
                    'Security Update',
                    'Security patch 2.1.4 has been successfully applied',
                    '2 hours ago',
                    Icons.security,
                    AppColors.success,
                    isUnread: false,
                  ),
                  const Divider(height: 1),
                  _buildNotificationItem(
                    'Backup Completed',
                    'Daily system backup completed successfully',
                    '12 hours ago',
                    Icons.backup,
                    AppColors.info,
                    isUnread: false,
                  ),
                ],
              ),
            ),
            actions: [
              TextButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('All notifications marked as read'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                icon: const Icon(Icons.done_all),
                label: const Text('Mark All Read'),
              ),
              ElevatedButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
                label: const Text('Close'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
    );
  }

  /// Show admin help dialog
  static void showHelp(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.help_outline, color: AppColors.primary),
                const SizedBox(width: 8),
                const Text('Admin Help & Documentation'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHelpItem(
                  'System Management',
                  'Monitor system health and performance',
                ),
                _buildHelpItem(
                  'User Administration',
                  'Manage user accounts, roles, and permissions',
                ),
                _buildHelpItem(
                  'Support System',
                  'Handle customer support tickets and escalations',
                ),
                _buildHelpItem(
                  'Configuration',
                  'Configure system settings and parameters',
                ),
                _buildHelpItem(
                  'Security',
                  'Manage security settings and access controls',
                ),
                const SizedBox(height: 16),
                Text(
                  'Emergency Support',
                  style: AppFonts.copyWith(
                    AppFonts.bodyMedium(color: AppColors.error),
                    fontWeight: AppFonts.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Critical Issues: emergency@graphsmile.com\nPhone: +1 (555) 911-ADMIN\nOn-call: 24/7 availability',
                  style: AppFonts.bodySmall(color: AppColors.textSecondary),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('View Documentation'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Contact Support'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  /// Show system status dialog
  static void showSystemStatus(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.health_and_safety, color: AppColors.success),
                const SizedBox(width: 8),
                const Text('System Status'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatusItem(
                  'API Server',
                  'Online',
                  AppColors.success,
                  Icons.check_circle,
                ),
                _buildStatusItem(
                  'Database',
                  'Online',
                  AppColors.success,
                  Icons.check_circle,
                ),
                _buildStatusItem(
                  'Cache System',
                  'Warning',
                  AppColors.warning,
                  Icons.warning,
                ),
                _buildStatusItem(
                  'Email Service',
                  'Online',
                  AppColors.success,
                  Icons.check_circle,
                ),
                _buildStatusItem(
                  'Backup System',
                  'Online',
                  AppColors.success,
                  Icons.check_circle,
                ),
                const SizedBox(height: 16),
                Text(
                  'Overall Status: OPERATIONAL',
                  style: AppFonts.copyWith(
                    AppFonts.bodyMedium(color: AppColors.success),
                    fontWeight: AppFonts.bold,
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  static Widget _buildNotificationItem(
    String title,
    String description,
    String time,
    IconData icon,
    Color color, {
    bool isUnread = false,
    bool isUrgent = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      decoration:
          isUrgent
              ? BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.2),
                  width: 1,
                ),
              )
              : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: color.withValues(alpha: 0.2), width: 1),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppFonts.copyWith(
                          AppFonts.bodySmall(color: AppColors.textPrimary),
                          fontWeight:
                              isUnread ? AppFonts.semiBold : AppFonts.medium,
                        ),
                      ),
                    ),
                    if (isUrgent)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'URGENT',
                          style: AppFonts.copyWith(
                            AppFonts.overline(color: AppColors.white),
                            fontWeight: AppFonts.bold,
                          ),
                        ),
                      ),
                    if (isUnread && !isUrgent)
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: AppFonts.copyWith(
                    AppFonts.caption(color: AppColors.textSecondary),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppFonts.copyWith(
                    AppFonts.caption(
                      color:
                          AppColors.textSecondary.withValues(alpha: 0.7),
                    ),
                    fontSize: 11,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildHelpItem(String title, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppFonts.copyWith(AppFonts.bodySmall(), fontWeight: AppFonts.semiBold)),
          const SizedBox(height: 4),
          Text(description, style: AppFonts.bodySmall(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  static Widget _buildStatusItem(
    String service,
    String status,
    Color color,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 8),
          Expanded(child: Text(service)),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: color.withValues(alpha: 0.3)),
            ),
            child: Text(
              status,
              style: AppFonts.copyWith(
                AppFonts.caption(color: color),
                fontWeight: AppFonts.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
