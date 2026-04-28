import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_bloc.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_event.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_state.dart';
import 'package:emosense_mobile/features/auth/splash/domain/abstractions/splash_navigation_resolver.dart';
import 'package:emosense_mobile/features/auth/splash/domain/entities/splash_destination.dart';

/// Wires splash routing to global [AuthBloc] session checks (delegates hydration to AuthBloc).
class SplashNavigationResolverImpl implements SplashNavigationResolver {
  SplashNavigationResolverImpl({required AuthBloc authBloc}) : _authBloc = authBloc;

  final AuthBloc _authBloc;

  @override
  Future<SplashDestination> resolveAfterHydration() async {
    _authBloc.add(const AuthCheckRequested());
    final next = await _authBloc.stream.firstWhere(
      (s) =>
          s is AuthAuthenticated ||
          s is AuthUnauthenticated ||
          s is AuthError,
    );

    if (next is AuthAuthenticated) {
      return next.user.role == UserRole.admin
          ? SplashDestination.adminDashboard
          : SplashDestination.employeeDashboard;
    }

    return SplashDestination.onboarding;
  }
}
