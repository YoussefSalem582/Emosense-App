import 'package:flutter/material.dart';

import '../../../core/core.dart';

/// Entry for the named route [AppRouter.roleSelection].
///
/// The app normally goes onboarding → auth choice → login; role is chosen on the
/// login/signup forms. This screen exists so `toRoleSelection` never lands on 404.
class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign in'),
      ),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => AppRouter.toAuthChoice(context),
              child: const Text('Continue'),
            ),
            TextButton(
              onPressed: () =>
                  AuthSessionNavigator.signOutAndGoToSplash(context),
              child: const Text('Back to start'),
            ),
          ],
        ),
      ),
    );
  }
}
