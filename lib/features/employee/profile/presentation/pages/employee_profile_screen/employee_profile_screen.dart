import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/features/employee/profile/domain/entities/employee_profile.dart';
import 'package:emosense_mobile/features/employee/profile/domain/repositories/employee_profile_repository.dart';
import 'package:emosense_mobile/shared/widgets/common/animated_background_widget.dart';
import 'widgets/widgets.dart';

class EmployeeProfileScreen extends StatefulWidget {
  const EmployeeProfileScreen({super.key});

  @override
  State<EmployeeProfileScreen> createState() => _EmployeeProfileScreenState();
}

class _EmployeeProfileScreenState extends State<EmployeeProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;
  late Animation<double> _backgroundAnimation;

  EmployeeProfile? _profile;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadProfile());
  }

  Future<void> _loadProfile() async {
    setState(() {
      _loading = true;
      _profile = null;
    });
    try {
      final p = await di.sl<EmployeeProfileRepository>().fetchProfile();
      if (mounted) {
        setState(() {
          _profile = p;
          _loading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _profile = null;
          _loading = false;
        });
      }
    }
  }

  void _initializeAnimations() {
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          AnimatedBackgroundWidget(animation: _backgroundAnimation),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (_profile == null)
            Center(
              child: Padding(
                padding: EdgeInsets.all(customSpacing.lg),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: AppColors.error),
                    SizedBox(height: customSpacing.md),
                    const Text('Could not load profile'),
                    SizedBox(height: customSpacing.md),
                    ElevatedButton(
                      onPressed: _loadProfile,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            )
          else
            _buildContent(_profile!),
        ],
      ),
    );
  }

  Widget _buildContent(EmployeeProfile p) {
    final repo = di.sl<EmployeeProfileRepository>();
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ProfileHeaderWidget(
            name: p.name,
            position: p.position,
            status: p.status,
            onEditPressed: () => _showEditProfileDialog(),
          ),
          const SizedBox(height: 20),
          ProfilePersonalInfoWidget(
            name: p.name,
            email: p.email,
            phone: p.phone,
            department: p.department,
            employeeId: p.employeeId,
          ),
          const SizedBox(height: 20),
          ProfileWorkInfoWidget(
            startDate: p.startDate,
            location: p.location,
            manager: p.manager,
            team: p.team,
          ),
          const SizedBox(height: 20),
          ProfileSettingsWidget(
            notificationsEnabled: p.notificationsEnabled,
            emailAlerts: p.emailAlerts,
            selectedLanguage: p.selectedLanguage,
            onNotificationsChanged: (value) async {
              final updated = await repo.updatePreferences(
                notificationsEnabled: value,
              );
              if (mounted) setState(() => _profile = updated);
            },
            onEmailAlertsChanged: (value) async {
              final updated = await repo.updatePreferences(emailAlerts: value);
              if (mounted) setState(() => _profile = updated);
            },
            onLanguageChanged: (value) async {
              if (value != null) {
                final updated = await repo.updatePreferences(
                  selectedLanguage: value,
                );
                if (mounted) setState(() => _profile = updated);
              }
            },
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
              leading: Icon(Icons.cloud_outlined, color: AppColors.primary),
              title: const Text('App & connection status'),
              subtitle: const Text('Backend connectivity and diagnostics'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => AppRouter.toAppStatus(context),
            ),
          ),
          const SizedBox(height: 20),
          ProfileQuickActionsWidget(
            onEditProfile: () => _showEditProfileDialog(),
            onChangePassword: () => _showChangePasswordDialog(),
            onTimeOffRequest: () => _showTimeOffRequest(),
            onHelpSupport: () => _showHelpSupport(),
            onSignOut: () => _showSignOutDialog(),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  void _showEditProfileDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Edit Profile'),
            content: const Text(
              'Profile editing functionality will be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Save'),
              ),
            ],
          ),
    );
  }

  void _showChangePasswordDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Change Password'),
            content: const Text(
              'Password change functionality will be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Change'),
              ),
            ],
          ),
    );
  }

  void _showTimeOffRequest() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Request Time Off'),
            content: const Text(
              'Time off request functionality will be implemented here.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Submit'),
              ),
            ],
          ),
    );
  }

  void _showHelpSupport() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Help & Support'),
            content: const Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Need help? Contact us:'),
                SizedBox(height: 8),
                Text('Email: support@graphsmile.com'),
                Text('Phone: +1 (555) 123-4567'),
                Text('Hours: 9 AM - 6 PM EST'),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }

  void _showSignOutDialog() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign Out'),
            content: const Text('Are you sure you want to sign out?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  AuthSessionNavigator.signOutAndGoToSplash(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                ),
                child: const Text('Sign Out'),
              ),
            ],
          ),
    );
  }
}
