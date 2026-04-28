import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/features/auth/auth_choice/domain/entities/auth_choice_destination.dart';
import 'package:emosense_mobile/features/auth/auth_choice/presentation/bloc/auth_choice_bloc.dart';
import 'package:emosense_mobile/features/auth/auth_choice/presentation/bloc/auth_choice_event.dart';
import 'package:emosense_mobile/features/auth/auth_choice/presentation/bloc/auth_choice_state.dart';
import 'package:emosense_mobile/features/auth/auth_choice/presentation/widgets/auth_choice.dart';

/// Authentication choice screen where users can choose between Login and Sign Up
///
/// Features:
/// - Modern card-based design
/// - Smooth animations and transitions
/// - Clear call-to-action buttons
/// - Consistent branding with app theme
/// - Haptic feedback for interactions
/// - Modular widget structure
class AuthChoiceScreen extends StatelessWidget {
  const AuthChoiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<AuthChoiceBloc>(),
      child: BlocListener<AuthChoiceBloc, AuthChoiceState>(
        listenWhen: (_, current) => current.pending != null,
        listener: (context, state) {
          final dest = state.pending!;
          context.read<AuthChoiceBloc>().add(
            const AuthChoiceNavigationConsumed(),
          );
          switch (dest) {
            case AuthChoiceDestination.login:
              Navigator.pushNamed(context, AppRouter.login);
              break;
            case AuthChoiceDestination.signup:
              Navigator.pushNamed(context, AppRouter.signup);
              break;
            case AuthChoiceDestination.onboarding:
              AppRouter.toOnboarding(context);
              break;
          }
        },
        child: const _AuthChoiceView(),
      ),
    );
  }
}

class _AuthChoiceView extends StatefulWidget {
  const _AuthChoiceView();

  @override
  State<_AuthChoiceView> createState() => _AuthChoiceViewState();
}

class _AuthChoiceViewState extends State<_AuthChoiceView>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _cardController;
  late AnimationController _backgroundController;

  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _cardScaleAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startEntryAnimation();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _cardController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _cardScaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _cardController, curve: Curves.elasticOut),
    );

    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );

    _backgroundController.repeat();
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 200), () {
      _animationController.forward();
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      _cardController.forward();
    });
  }

  void _dispatchLogin() {
    HapticFeedback.lightImpact();
    context.read<AuthChoiceBloc>().add(const AuthChoiceLoginTapped());
  }

  void _dispatchSignUp() {
    HapticFeedback.lightImpact();
    context.read<AuthChoiceBloc>().add(const AuthChoiceSignUpTapped());
  }

  void _dispatchBack() {
    HapticFeedback.lightImpact();
    context.read<AuthChoiceBloc>().add(const AuthChoiceBackTapped());
  }

  @override
  void dispose() {
    _animationController.dispose();
    _cardController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AuthChoiceContent(
        fadeAnimation: _fadeAnimation,
        slideAnimation: _slideAnimation,
        cardScaleAnimation: _cardScaleAnimation,
        backgroundAnimation: _backgroundAnimation,
        onLoginPressed: _dispatchLogin,
        onSignUpPressed: _dispatchSignUp,
        onBackPressed: _dispatchBack,
      ),
    );
  }
}
