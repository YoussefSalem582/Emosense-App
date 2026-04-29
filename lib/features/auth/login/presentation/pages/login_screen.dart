import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/features/admin/presentation/pages/admin_navigation_screen.dart';
import 'package:emosense_mobile/features/auth/login/presentation/bloc/login_bloc.dart';
import 'package:emosense_mobile/features/auth/login/presentation/bloc/login_event.dart';
import 'package:emosense_mobile/features/auth/login/presentation/bloc/login_state.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_bloc.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_event.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/bloc/auth_state.dart';
import 'package:emosense_mobile/features/auth/shared/presentation/widgets/auth.dart';
import 'package:emosense_mobile/features/employee/navigation/presentation/pages/employee_navigation_screen/employee_navigation_screen.dart';

import 'package:emosense_mobile/features/auth/login/presentation/widgets/login.dart';

/// Login route: scopes [LoginBloc] under animations + [BlocConsumer] for [AuthBloc].
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<LoginBloc>(),
      child: const _LoginScreenBody(),
    );
  }
}

class _LoginScreenBody extends StatefulWidget {
  const _LoginScreenBody();

  @override
  State<_LoginScreenBody> createState() => _LoginScreenBodyState();
}

class _LoginScreenBodyState extends State<_LoginScreenBody>
    with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _scrollController = ScrollController();

  late AnimationController _logoController;
  late AnimationController _formController;
  late AnimationController _backgroundController;
  late Animation<double> _logoAnimation;
  late Animation<double> _formAnimation;
  late Animation<double> _backgroundAnimation;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _formController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.elasticOut,
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
      _logoController.forward();
    });
    Future.delayed(const Duration(milliseconds: 800), () {
      _formController.forward();
    });
    _backgroundController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _logoController.dispose();
    _formController.dispose();
    _backgroundController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is AuthAuthenticated ||
          current is AuthError ||
          current is AuthForgotPasswordSuccess,
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final target =
              state.user.role == UserRole.admin
                  ? const AdminNavigationScreen()
                  : const EmployeeNavigationScreen();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => target),
          );
        } else if (state is AuthError) {
          _showErrorDialog(state.message);
        } else if (state is AuthForgotPasswordSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
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
                _buildLoginContent(loading),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoginContent(bool loading) {
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
                child: BlocBuilder<LoginBloc, LoginFormUiState>(
                  builder: (context, login) {
                    return Column(
                      children: [
                        LoginHeader(
                          logoAnimation: _logoAnimation,
                          formAnimation: _formAnimation,
                        ),
                        LoginForm(
                          formAnimation: _formAnimation,
                          formKey: _formKey,
                          emailController: _emailController,
                          passwordController: _passwordController,
                          selectedRole: login.selectedRoleLabel,
                          onRoleChanged:
                              (role) => context.read<LoginBloc>().add(
                                LoginRoleLabelChanged(role),
                              ),
                          isPasswordVisible: login.passwordVisible,
                          onPasswordVisibilityToggle: () => context.read<LoginBloc>().add(
                            const LoginPasswordVisibilityToggled(),
                          ),
                        ),
                        LoginFooter(
                          formAnimation: _formAnimation,
                          selectedRole: login.selectedRoleLabel,
                          onLogin: _handleLogin,
                          isLoading: loading,
                          rememberMe: login.rememberMe,
                          onRememberMeChanged:
                              (value) => context.read<LoginBloc>().add(
                                LoginRememberMeChanged(value),
                              ),
                          onForgotPassword: _showForgotPasswordDialog,
                          onSocialLogin: _handleSocialLogin,
                          onNavigateToSignUp: _navigateToSignUp,
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

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    HapticFeedback.lightImpact();

    final roleLabel = context.read<LoginBloc>().state.selectedRoleLabel;
    final role = roleLabel == 'Admin' ? UserRole.admin : UserRole.employee;
    context.read<AuthBloc>().add(
      AuthLoginRequested(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: role,
      ),
    );
  }

  void _handleSocialLogin(String provider) {
    context.read<AuthBloc>().add(
      AuthGoogleSignInRequested(
        idToken:
            '${provider}_demo@${_emailController.text.trim().isNotEmpty ? _emailController.text.trim() : 'user@social.local'}',
      ),
    );
  }

  Future<void> _showForgotPasswordDialog() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      _showErrorDialog('Enter your email above first.');
      return;
    }
    context.read<AuthBloc>().add(AuthForgotPasswordRequested(email: email));
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _navigateToSignUp() {
    Navigator.pushNamed(context, '/signup');
  }
}
