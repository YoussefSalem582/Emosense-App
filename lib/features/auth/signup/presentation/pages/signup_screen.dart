import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/core/routing/app_router.dart';
import 'package:emosense_mobile/features/auth/signup/presentation/bloc/signup_bloc.dart';
import 'package:emosense_mobile/features/auth/signup/presentation/bloc/signup_event.dart';
import 'package:emosense_mobile/features/auth/signup/presentation/bloc/signup_state.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_bloc.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_event.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_state.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/widgets/auth.dart';

import 'package:emosense_mobile/features/auth/signup/presentation/widgets/signup.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<SignUpBloc>(),
      child: const _SignUpScreenBody(),
    );
  }
}

class _SignUpScreenBody extends StatefulWidget {
  const _SignUpScreenBody();

  @override
  State<_SignUpScreenBody> createState() => _SignUpScreenBodyState();
}

class _SignUpScreenBodyState extends State<_SignUpScreenBody>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _employeeIdController = TextEditingController();
  final _departmentController = TextEditingController();
  final _scrollController = ScrollController();

  late AnimationController _formController;
  late AnimationController _backgroundController;
  late Animation<double> _formAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _formAnimation = CurvedAnimation(
      parent: _formController,
      curve: Curves.easeOutCubic,
    );
    _backgroundAnimation = CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOut,
    );
  }

  void _startAnimations() {
    Future.delayed(const Duration(milliseconds: 300), () {
      _formController.forward();
    });
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _formController.dispose();
    _backgroundController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _employeeIdController.dispose();
    _departmentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen:
          (previous, current) =>
              current is AuthAuthenticated || current is AuthError,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Welcome ${_firstNameController.text.trim()}! Account created successfully.',
              ),
              backgroundColor: Colors.green.withValues(alpha: 0.9),
              behavior: SnackBarBehavior.floating,
            ),
          );
          if (state.user.role == UserRole.admin) {
            AppRouter.toAdminDashboard(context);
          } else {
            AppRouter.toEmployeeDashboard(context);
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: Colors.red.withValues(alpha: 0.9),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      builder: (context, state) {
        final loading = state is AuthLoading;

        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            resizeToAvoidBottomInset: true,
            body: Stack(
              children: [
                AnimatedBackgroundWidget(animation: _backgroundAnimation),
                _buildSignupContent(loading),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSignupContent(bool loading) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
          final screenHeight = MediaQuery.of(context).size.height;
          final isSmallScreen = screenHeight < 700;

          return SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.only(
              bottom: keyboardHeight > 0 ? keyboardHeight + 20 : 0,
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight - keyboardHeight,
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 16.0 : 24.0,
                ),
                child: BlocBuilder<SignUpBloc, SignUpFormUiState>(
                  builder: (context, signup) {
                    return Column(
                      children: [
                        SignupHeader(formAnimation: _formAnimation),
                        SignupForm(
                          formAnimation: _formAnimation,
                          formKey: _formKey,
                          firstNameController: _firstNameController,
                          lastNameController: _lastNameController,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          confirmPasswordController: _confirmPasswordController,
                          employeeIdController: _employeeIdController,
                          departmentController: _departmentController,
                          selectedRole: signup.selectedRoleLabel,
                          onRoleChanged:
                              (role) => context.read<SignUpBloc>().add(
                                SignUpRoleLabelChanged(role),
                              ),
                          isPasswordVisible: signup.passwordVisible,
                          isConfirmPasswordVisible: signup.confirmPasswordVisible,
                          onPasswordVisibilityToggle: () => context.read<SignUpBloc>().add(
                            const SignUpPasswordVisibilityToggled(),
                          ),
                          onConfirmPasswordVisibilityToggle: () => context.read<SignUpBloc>().add(
                            const SignUpConfirmPasswordVisibilityToggled(),
                          ),
                        ),
                        SignupFooter(
                          formAnimation: _formAnimation,
                          selectedRole: signup.selectedRoleLabel,
                          onSignup: _handleSignUp,
                          isLoading: loading,
                          agreeToTerms: signup.agreeToTerms,
                          onAgreeToTermsChanged:
                              (value) => context.read<SignUpBloc>().add(
                                SignUpAgreeToTermsChanged(value),
                              ),
                          onNavigateToLogin: _navigateToLogin,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSignUp() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!context.read<SignUpBloc>().state.agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the terms and conditions'),
          backgroundColor: Colors.orange,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    HapticFeedback.lightImpact();

    final roleLabel = context.read<SignUpBloc>().state.selectedRoleLabel;
    final role = roleLabel == 'Admin' ? UserRole.admin : UserRole.employee;

    context.read<AuthBloc>().add(
      AuthRegisterRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        passwordConfirmation: _confirmPasswordController.text,
        firstName: _firstNameController.text.trim(),
        lastName: _lastNameController.text.trim(),
        employeeId: _employeeIdController.text.trim(),
        department: _departmentController.text.trim(),
        role: role,
      ),
    );
  }

  void _navigateToLogin() {
    Navigator.pop(context);
  }
}
