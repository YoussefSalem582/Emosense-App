import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/core/routing/app_router.dart';
import 'package:emosense_mobile/features/auth/onboarding/presentation/bloc/onboarding_bloc.dart';
import 'package:emosense_mobile/features/auth/onboarding/presentation/bloc/onboarding_event.dart';
import 'package:emosense_mobile/features/auth/onboarding/presentation/bloc/onboarding_state.dart';
import 'package:emosense_mobile/features/auth/onboarding/domain/entities/onboarding_page_data.dart';
import 'package:emosense_mobile/features/auth/onboarding/presentation/widgets/onboarding.dart';
import 'package:emosense_mobile/core/widgets/common/animated_background_widget.dart';

/// Onboarding carousel: [OnboardingBloc] owns pager index and completion persistence.
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<OnboardingBloc>(),
      child: const _OnboardingCoordinator(),
    );
  }
}

class _OnboardingCoordinator extends StatelessWidget {
  const _OnboardingCoordinator();

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<OnboardingBloc, OnboardingState>(
          listenWhen:
              (previous, current) =>
                  !previous.completedFlow && current.completedFlow,
          listener: (context, state) {
            HapticFeedback.mediumImpact();
            AppRouter.toAuthChoice(context);
          },
        ),
      ],
      child: const _OnboardingView(),
    );
  }
}

class _OnboardingView extends StatefulWidget {
  const _OnboardingView();

  @override
  State<_OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<_OnboardingView>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animationController;
  late AnimationController _backgroundController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _backgroundAnimation;

  final List<OnboardingPageData> _pages = [
    OnboardingPageData(
      title: 'Welcome to EmoSense',
      description:
          'Unlock the power of emotional intelligence with cutting-edge AI. Transform how you understand and respond to emotions in text, making every interaction more meaningful.',
      icon: Icons.psychology_outlined,
      primaryColor: Color(0xFFFFFFFF),
      secondaryColor: Color(0xFFF0F4FF),
    ),
    OnboardingPageData(
      title: 'Enhanced Text Analysis',
      description:
          'Experience next-level text analysis that goes beyond words. Our AI detects subtle emotional cues, sentiment patterns, and psychological insights with unprecedented accuracy.',
      icon: Icons.text_fields,
      primaryColor: Color(0xFFFFFFFF),
      secondaryColor: Color(0xFFF0F8FF),
    ),
    OnboardingPageData(
      title: 'Employee Analytics',
      description:
          'Empower your team with data-driven emotional intelligence. Track wellbeing, identify stress patterns, and create a healthier, more productive workplace environment.',
      icon: Icons.group,
      primaryColor: Color(0xFFFFFFFF),
      secondaryColor: Color(0xFFF5F8FF),
    ),
    OnboardingPageData(
      title: 'Get Started',
      description:
          'Ready to revolutionize your communication? Join thousands who\'ve already discovered the transformative power of emotional intelligence in their daily interactions.',
      icon: Icons.rocket_launch,
      primaryColor: Color(0xFFFFFFFF),
      secondaryColor: Color(0xFFF8FAFF),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _startEntryAnimation();
  }

  void _initializeControllers() {
    _pageController = PageController();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _backgroundAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.linear),
    );
  }

  void _startEntryAnimation() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _animationController.forward();
    });
    _backgroundController.repeat();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  void _scrollPage(int targetPage) {
    if (!_pageController.hasClients) return;
    _pageController.animateToPage(
      targetPage,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _dispatchNext(BuildContext context) {
    HapticFeedback.lightImpact();
    context.read<OnboardingBloc>().add(const OnboardingNextPressed());
  }

  void _dispatchPrevious(BuildContext context) {
    HapticFeedback.lightImpact();
    context.read<OnboardingBloc>().add(const OnboardingPreviousPressed());
  }

  void _dispatchSkip(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<OnboardingBloc>().add(const OnboardingSkipped());
  }

  void _dispatchFinish(BuildContext context) {
    HapticFeedback.mediumImpact();
    context.read<OnboardingBloc>().add(const OnboardingCompleted());
  }

  void _dispatchPageChanged(BuildContext context, int index) {
    context.read<OnboardingBloc>().add(OnboardingPageChanged(index));
    HapticFeedback.selectionClick();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<OnboardingBloc, OnboardingState>(
      listenWhen:
          (previous, current) =>
              !current.completedFlow &&
              previous.currentPage != current.currentPage,
      listener: (context, state) {
        _scrollPage(state.currentPage);
      },
      child: Scaffold(
        body: BlocBuilder<OnboardingBloc, OnboardingState>(
          builder: (context, onboarding) {
            return AnimatedBuilder(
              animation: _fadeAnimation,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Stack(
                    children: [
                      AnimatedBackgroundWidget(animation: _backgroundAnimation),
                      SafeArea(
                        child: OnboardingContent(
                          pageController: _pageController,
                          currentPage: onboarding.currentPage,
                          totalPages: onboarding.totalPages,
                          pages: _pages,
                          onPageChanged:
                              (index) => _dispatchPageChanged(context, index),
                          onNext: () => _dispatchNext(context),
                          onPrevious: () => _dispatchPrevious(context),
                          onSkip: () => _dispatchSkip(context),
                          onGetStarted: () => _dispatchFinish(context),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
