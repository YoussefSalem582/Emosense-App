import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/features/auth/role_selection/domain/entities/role_selection_destination.dart';
import 'package:emosense_mobile/features/auth/role_selection/presentation/bloc/role_selection_bloc.dart';
import 'package:emosense_mobile/features/auth/role_selection/presentation/bloc/role_selection_event.dart';
import 'package:emosense_mobile/features/auth/role_selection/presentation/bloc/role_selection_state.dart';

/// Named route [AppRouter.roleSelection] — continue to auth choice or sign out to splash.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => di.sl<RoleSelectionBloc>(),
      child: BlocListener<RoleSelectionBloc, RoleSelectionState>(
        listenWhen:
            (_, current) => current.pending != null,
        listener: (context, state) {
          final dest = state.pending!;
          context.read<RoleSelectionBloc>().add(
            const RoleSelectionNavigationConsumed(),
          );
          switch (dest) {
            case RoleSelectionDestination.authChoice:
              AppRouter.toAuthChoice(context);
              break;
            case RoleSelectionDestination.splash:
              AuthSessionNavigator.signOutAndGoToSplash(context);
              break;
          }
        },
        child: Scaffold(
          appBar: AppBar(title: const Text('Sign in')),
          body: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Choose how you want to continue',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'You can pick Admin or Employee when you sign in or create an account.',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                ),
                const Spacer(),
                FilledButton(
                  onPressed:
                      () => context.read<RoleSelectionBloc>().add(
                        const RoleSelectionContinueTapped(),
                      ),
                  child: const Text('Continue'),
                ),
                TextButton(
                  onPressed:
                      () => context.read<RoleSelectionBloc>().add(
                        const RoleSelectionBackToStartTapped(),
                      ),
                  child: const Text('Back to start'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
