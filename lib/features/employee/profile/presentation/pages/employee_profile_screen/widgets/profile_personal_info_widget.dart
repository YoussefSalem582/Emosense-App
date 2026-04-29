import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/profile_section_card.dart';
import 'package:emosense_mobile/core/widgets/common/section_title_row.dart';

class ProfilePersonalInfoWidget extends StatelessWidget {
  final String name;
  final String email;
  final String phone;
  final String department;
  final String employeeId;

  const ProfilePersonalInfoWidget({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.employeeId,
  });

  @override
  Widget build(BuildContext context) {
    return ProfileSectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSectionTitleRow(
            icon: Icons.person_outline,
            title: 'Personal Information',
            titleStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoItem('Name', name),
          _buildInfoItem('Email', email),
          _buildInfoItem('Phone', phone),
          _buildInfoItem('Department', department),
          _buildInfoItem('Employee ID', employeeId),
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
              style: TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
