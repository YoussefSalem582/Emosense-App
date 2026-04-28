import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/features/employee/profile/presentation/bloc/employee_profile_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<EmployeeProfileBloc>().add(
        const EmployeeProfileLoadRequested(),
      );
    });
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
          BlocBuilder<EmployeeProfileBloc, EmployeeProfileState>(
            builder: (context, state) {
              if (state is EmployeeProfileInitial ||
                  state is EmployeeProfileLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is EmployeeProfileError) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(customSpacing.lg),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 48,
                          color: AppColors.error,
                        ),
                        SizedBox(height: customSpacing.md),
                        Text(state.message, textAlign: TextAlign.center),
                        SizedBox(height: customSpacing.md),
                        ElevatedButton(
                          onPressed:
                              () => context.read<EmployeeProfileBloc>().add(
                                const EmployeeProfileLoadRequested(),
                              ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                );
              }
              if (state is! EmployeeProfileSuccess) {
                return const SizedBox.shrink();
              }
              final d = state.data;
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ProfileHeaderWidget(
                      name: d.name,
                      position: d.position,
                      status: d.status,
                      onEditPressed: () => _showEditProfileDialog(),
                    ),
                    const SizedBox(height: 20),
                    ProfilePersonalInfoWidget(
                      name: d.name,
                      email: d.email,
                      phone: d.phone,
                      department: d.department,
                      employeeId: d.employeeId,
                    ),
                    const SizedBox(height: 20),
                    ProfileWorkInfoWidget(
                      startDate: d.startDate,
                      location: d.location,
                      manager: d.manager,
                      team: d.team,
                    ),
                    const SizedBox(height: 20),
                    ProfileSettingsWidget(
                      notificationsEnabled: d.notificationsEnabled,
                      emailAlerts: d.emailAlerts,
                      selectedLanguage: d.selectedLanguage,
                      onNotificationsChanged:
                          (value) => context.read<EmployeeProfileBloc>().add(
                            EmployeeProfileNotificationsChanged(value),
                          ),
                      onEmailAlertsChanged:
                          (value) => context.read<EmployeeProfileBloc>().add(
                            EmployeeProfileEmailAlertsChanged(value),
                          ),
                      onLanguageChanged: (value) {
                        if (value != null) {
                          context.read<EmployeeProfileBloc>().add(
                            EmployeeProfileLanguageChanged(value),
                          );
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
                        leading: Icon(
                          Icons.cloud_outlined,
                          color: AppColors.primary,
                        ),
                        title: const Text('App & connection status'),
                        subtitle: const Text(
                          'Backend connectivity and diagnostics',
                        ),
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
            },
          ),
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
