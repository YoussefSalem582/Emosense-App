import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/profile_section_card.dart';
import 'package:emosense_mobile/core/widgets/common/section_title_row.dart';

class ProfileSettingsWidget extends StatelessWidget {
  final bool notificationsEnabled;
  final bool emailAlerts;
  final String selectedLanguage;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onEmailAlertsChanged;
  final Function(String?) onLanguageChanged;

  const ProfileSettingsWidget({
    super.key,
    required this.notificationsEnabled,
    required this.emailAlerts,
    required this.selectedLanguage,
    required this.onNotificationsChanged,
    required this.onEmailAlertsChanged,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionTitleRow(
            icon: Icons.settings_outlined,
            title: 'Settings',
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingRow(
            context,
            'Notifications',
            notificationsEnabled,
            onNotificationsChanged,
          ),
          _buildSettingRow(
            context,
            'Email Alerts',
            emailAlerts,
            onEmailAlertsChanged,
          ),
          const SizedBox(height: 16),
          _buildDropdownSetting(context, 'Language', selectedLanguage, [
            'English',
            'Spanish',
            'French',
            'German',
          ], onLanguageChanged),
        ],
      ),
    );
  }

  Widget _buildSettingRow(
    BuildContext context,
    String title,
    bool value,
    Function(bool) onChanged,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
            activeTrackColor: AppColors.primary.withValues(alpha: 0.3),
            inactiveThumbColor: Colors.grey[400],
            inactiveTrackColor: Colors.grey[300],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownSetting(
    BuildContext context,
    String title,
    String value,
    List<String> options,
    Function(String?) onChanged,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.textPrimary),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
          ),
          child: DropdownButton<String>(
            value: value,
            onChanged: onChanged,
            underline: const SizedBox(),
            icon: Icon(Icons.arrow_drop_down, color: AppColors.primary),
            items:
                options.map((String option) {
                  return DropdownMenuItem<String>(
                    value: option,
                    child: Text(
                      option,
                      style: AppFonts.bodyMedium(color: AppColors.textPrimary),
                    ),
                  );
                }).toList(),
          ),
        ),
      ],
    );
  }
}
