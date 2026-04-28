import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/auth/presentation/bloc/user_bloc.dart';
import '../network/connection_bloc.dart';
import '../routing/app_router.dart';

/// Clears persisted session state and returns to [AppRouter.splash].
class AuthSessionNavigator {
  AuthSessionNavigator._();

  static void signOutAndGoToSplash(BuildContext context) {
    context.read<UserBloc>().add(const UserClear());
    context.read<ConnectionBloc>().add(const ConnectionDisconnectRequested());
    AppRouter.toSplash(context);
  }
}
