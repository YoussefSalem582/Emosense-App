import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class AuthAuthenticated extends AuthState {
  const AuthAuthenticated({required this.user});

  final UserEntity user;

  AuthAuthenticated copyWith({UserEntity? user}) =>
      AuthAuthenticated(user: user ?? this.user);

  @override
  List<Object?> get props => [user];
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthAccountDeleted extends AuthState {
  const AuthAccountDeleted();
}

class AuthError extends AuthState {
  const AuthError({
    required this.message,
    this.fieldErrors,
    this.statusCode,
  });

  final String message;
  final Map<String, List<String>>? fieldErrors;
  final int? statusCode;

  @override
  List<Object?> get props => [message, fieldErrors, statusCode];
}

class AuthForgotPasswordSuccess extends AuthState {
  const AuthForgotPasswordSuccess({required this.message});

  final String message;

  @override
  List<Object?> get props => [message];
}
