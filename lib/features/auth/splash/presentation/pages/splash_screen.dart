import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/features/auth/splash/presentation/bloc/splash_bloc.dart';
import 'package:emosense_mobile/features/auth/splash/presentation/bloc/splash_event.dart';
import 'package:emosense_mobile/features/auth/splash/presentation/bloc/splash_state.dart';
import 'package:emosense_mobile/features/auth/splash/presentation/widgets/splash.dart';

/// Splash entry: delegates session resolution to [SplashBloc].
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SplashBloc>(),
      child: const _SplashCoordinator(),
    );
  }
}

class _SplashCoordinator extends StatelessWidget {
  const _SplashCoordinator();

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listenWhen: (previous, current) => current is SplashNavigate,
      listener: (context, state) {
        if (state is! SplashNavigate) return;
        switch (state.destination) {
          case SplashDestination.adminDashboard:
            AppRouter.toAdminDashboard(context);
            break;
          case SplashDestination.employeeDashboard:
            AppRouter.toEmployeeDashboard(context);
            break;
          case SplashDestination.onboarding:
            AppRouter.toOnboarding(context);
            break;
        }
      },
      child: const _SplashAnimations(),
    );
  }
}

class _SplashAnimations extends StatefulWidget {
  const _SplashAnimations();

  @override
  State<_SplashAnimations> createState() => _SplashAnimationsState();
}

class _SplashAnimationsState extends State<_SplashAnimations>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _backgroundController;
  late AnimationController _particleController;

  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotationAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _backgroundAnimation;
  late Animation<double> _particleAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startSplashSequence();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    _textController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _logoScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.elasticOut),
    );
    _logoRotationAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoController,
        curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
      ),
    );
    _textFadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeIn),
      ),
    );
    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _textController,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _backgroundController,
        curve: Curves.easeInOutSine,
      ),
    );
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.easeInOut),
    );
  }

  void _startSplashSequence() async {
    _backgroundController.forward();
    await Future.delayed(const Duration(milliseconds: 300));
    _logoController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _textController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _particleController.forward();
    await Future.delayed(const Duration(milliseconds: 1800));
    if (!mounted) return;
    context.read<SplashBloc>().add(const SplashAnimationSequenceCompleted());
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashContent(
        logoScaleAnimation: _logoScaleAnimation,
        logoRotationAnimation: _logoRotationAnimation,
        textFadeAnimation: _textFadeAnimation,
        textSlideAnimation: _textSlideAnimation,
        backgroundAnimation: _backgroundAnimation,
        particleAnimation: _particleAnimation,
      ),
    );
  }
}
