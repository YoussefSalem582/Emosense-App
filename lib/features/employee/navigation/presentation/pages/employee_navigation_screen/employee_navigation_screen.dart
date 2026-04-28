import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/features/employee/navigation/presentation/bloc/employee_navigation_bloc.dart';
import 'package:emosense_mobile/features/employee/shared/presentation/widgets/employee_bottom_nav_bar.dart';
import 'widgets/employee_app_bar.dart';
import 'widgets/employee_screen_factory.dart';
import 'widgets/employee_dialogs.dart';

/// Enhanced Employee Navigation Screen with modular components
///
/// Features:
/// - Modular app bar with animations
/// - Lazy loading screens with caching
/// - Tab index via [EmployeeNavigationBloc]
/// - Consistent animations and feedback
/// - Improved performance and maintainability
class EmployeeNavigationScreen extends StatefulWidget {
  const EmployeeNavigationScreen({super.key});

  @override
  State<EmployeeNavigationScreen> createState() =>
      _EmployeeNavigationScreenState();
}

class _EmployeeNavigationScreenState extends State<EmployeeNavigationScreen>
    with TickerProviderStateMixin, ScreenStateMixin {
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _preloadEssentialScreens();
  }

  void _initializeAnimations() {
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _shimmerController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    _shimmerAnimation = CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.easeInOut,
    );

    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
  }

  void _preloadEssentialScreens() {
    EmployeeScreenFactory.preloadScreens([0, 1, 3, 4, 5]);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    EmployeeScreenFactory.clearCache();
    super.dispose();
  }

  int _selectedIndex(EmployeeNavigationState state) {
    if (state is EmployeeNavigationReady) return state.selectedIndex;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return buildWithState(
      child: BlocBuilder<EmployeeNavigationBloc, EmployeeNavigationState>(
        builder: (context, navState) {
          final selectedIndex = _selectedIndex(navState);
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  const Color(0xFF667EEA).withValues(alpha: 0.1),
                  const Color(0xFF764BA2).withValues(alpha: 0.1),
                  const Color(0xFF48CAE4).withValues(alpha: 0.1),
                ],
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              appBar: EmployeeAppBar(
                shimmerAnimation: _shimmerAnimation,
                pulseAnimation: _pulseAnimation,
                selectedIndex: selectedIndex,
                onNotificationPressed:
                    () => EmployeeDialogs.showNotifications(context),
                onProfilePressed: () => _handleProfileAction(context),
                onProfileMenuSelected:
                    (v) => _handleProfileMenuSelection(context, v),
              ),
              body: Stack(
                children: [
                  IndexedStack(
                    index: selectedIndex,
                    children: List.generate(9, (index) {
                      return EmployeeScreenFactory.getScreen(
                        index,
                        onAnalysisToolSelected: (toolIndex) {
                          _handleAnalysisToolSelection(context, toolIndex);
                        },
                      );
                    }),
                  ),
                ],
              ),
              bottomNavigationBar: EmployeeBottomNavBar(
                selectedIndex: selectedIndex,
                onItemTapped: (i) => _handleBottomNavTap(context, i),
              ),
            ),
          );
        },
      ),
      onRetry: _handleRetry,
    );
  }

  void _handleBottomNavTap(BuildContext context, int index) {
    final bloc = context.read<EmployeeNavigationBloc>();
    final current = _selectedIndex(bloc.state);
    if (index != current) {
      bloc.add(EmployeeNavigationTabSelected(index));
      HapticFeedback.lightImpact();
      _pulseController.reset();
      _pulseController.forward();
    }
  }

  void _handleAnalysisToolSelection(BuildContext context, int toolIndex) {
    switch (toolIndex) {
      case 0:
        AppRouter.toTextAnalysis(context);
        break;
      case 1:
        AppRouter.toVoiceAnalysis(context);
        break;
      case 2:
        AppRouter.toVideoAnalysis(context);
        break;
      default:
        context.read<EmployeeNavigationBloc>().add(
          EmployeeNavigationTabSelected(toolIndex + 6),
        );
    }
  }

  void _handleProfileAction(BuildContext context) {
    context.read<EmployeeNavigationBloc>().add(
      const EmployeeNavigationTabSelected(3),
    );
  }

  void _handleProfileMenuSelection(BuildContext context, String value) {
    switch (value) {
      case 'profile':
        context.read<EmployeeNavigationBloc>().add(
          const EmployeeNavigationTabSelected(3),
        );
        break;
      case 'help':
        EmployeeDialogs.showHelp(context);
        break;
      case 'settings':
        context.read<EmployeeNavigationBloc>().add(
          const EmployeeNavigationTabSelected(3),
        );
        break;
      case 'logout':
        _handleLogout(context);
        break;
      case 'home':
        context.read<EmployeeNavigationBloc>().add(
          const EmployeeNavigationTabSelected(0),
        );
        break;
    }
  }

  void _handleLogout(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Row(
              children: [
                Icon(Icons.logout, color: AppColors.warning),
                const SizedBox(width: 8),
                const Text('Confirm Logout'),
              ],
            ),
            content: const Text(
              'Are you sure you want to logout? You will need to login again to access the app.',
            ),
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
                child: const Text('Logout'),
              ),
            ],
          ),
    );
  }

  void _handleRetry() {
    setLoaded();
    _preloadEssentialScreens();
  }
}
