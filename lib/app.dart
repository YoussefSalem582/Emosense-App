import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'core/constants/app_theme.dart';
import 'core/core.dart' show UserSessionStorage;
import 'core/di/dependency_injection.dart' as di;
import 'core/routing/app_router.dart';
import 'features/analysis/presentation/bloc/text_analysis_bloc.dart';
import 'features/analysis/presentation/bloc/video_analysis_bloc.dart';
import 'features/analysis/presentation/bloc/voice_analysis_bloc.dart';
import 'features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import 'features/auth/presentation/bloc/user_bloc.dart';
import 'features/emotion/presentation/bloc/emotion_bloc.dart';
import 'features/employee/analysis_tools/presentation/bloc/employee_analysis_tools_bloc.dart';
import 'features/employee/dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import 'features/employee/navigation/presentation/bloc/employee_navigation_bloc.dart';
import 'features/employee/performance/presentation/bloc/employee_performance_bloc.dart';
import 'features/employee/profile/presentation/bloc/employee_profile_bloc.dart';
import 'features/employee/shared/presentation/bloc/employee_analytics_bloc.dart';
import 'core/network/connection_bloc.dart';
import 'package:emosense_mobile/shared/widgets/backend_connection_widget.dart';

/// Root widget: global [BlocProvider]s and [MaterialApp], mirroring
/// `technology_ninety_two_app`'s split (`main.dart` only bootstraps; app tree lives here).
class EmosenseApp extends StatelessWidget {
  const EmosenseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<VideoAnalysisBloc>(
          create: (_) => di.sl<VideoAnalysisBloc>(),
        ),
        BlocProvider<TextAnalysisBloc>(
          create: (_) => di.sl<TextAnalysisBloc>(),
        ),
        BlocProvider<VoiceAnalysisBloc>(
          create: (_) => di.sl<VoiceAnalysisBloc>(),
        ),
        BlocProvider<EmotionBloc>(create: (_) => di.sl<EmotionBloc>()),
        BlocProvider<UserBloc>(create: (_) => di.sl<UserBloc>()),
        BlocProvider<EmployeeNavigationBloc>(
          create: (_) => di.sl<EmployeeNavigationBloc>(),
        ),
        BlocProvider<EmployeeDashboardBloc>(
          create: (_) => di.sl<EmployeeDashboardBloc>(),
        ),
        BlocProvider<EmployeeAnalyticsBloc>(
          create: (_) => di.sl<EmployeeAnalyticsBloc>(),
        ),
        BlocProvider<EmployeePerformanceBloc>(
          create: (_) => di.sl<EmployeePerformanceBloc>(),
        ),
        BlocProvider<EmployeeProfileBloc>(
          create: (_) => di.sl<EmployeeProfileBloc>(),
        ),
        BlocProvider<EmployeeAnalysisToolsBloc>(
          create: (_) => di.sl<EmployeeAnalysisToolsBloc>(),
        ),
        BlocProvider<AdminDashboardBloc>(
          create: (_) => di.sl<AdminDashboardBloc>(),
        ),
        BlocProvider<ConnectionBloc>(create: (_) => di.sl<ConnectionBloc>()),
      ],
      child: const _ConnectionBootstrap(
        child: BackendConnectionWidget(
          child: _UserSessionLifecycle(child: _MaterialAppShell()),
        ),
      ),
    );
  }
}

/// Dispatches [ConnectionInitializeRequested] once after the first frame so
/// [ConnectionManager] and its status stream are active app-wide.
class _ConnectionBootstrap extends StatefulWidget {
  const _ConnectionBootstrap({required this.child});

  final Widget child;

  @override
  State<_ConnectionBootstrap> createState() => _ConnectionBootstrapState();
}

class _ConnectionBootstrapState extends State<_ConnectionBootstrap> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<ConnectionBloc>().add(const ConnectionInitializeRequested());
    });
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Restores [UserBloc] from disk after first frame; persists on auth changes.
class _UserSessionLifecycle extends StatefulWidget {
  const _UserSessionLifecycle({required this.child});

  final Widget child;

  @override
  State<_UserSessionLifecycle> createState() => _UserSessionLifecycleState();
}

class _UserSessionLifecycleState extends State<_UserSessionLifecycle> {
  var _restoreStarted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _restoreSession());
  }

  Future<void> _restoreSession() async {
    if (_restoreStarted) return;
    _restoreStarted = true;
    final user = await UserSessionStorage.read();
    if (!mounted || user == null) return;
    context.read<UserBloc>().add(UserSet(user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listenWhen:
          (prev, curr) => curr is UserAuthenticated || curr is UserLoggedOut,
      listener: (context, state) async {
        if (state is UserAuthenticated) {
          await UserSessionStorage.save(state.user);
        } else if (state is UserLoggedOut) {
          await UserSessionStorage.clear();
        }
      },
      child: widget.child,
    );
  }
}

class _MaterialAppShell extends StatelessWidget {
  const _MaterialAppShell();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emosense',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: AppRouter.splash,
      onGenerateRoute: AppRouter.generateRoute,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child!,
        );
      },
    );
  }
}
