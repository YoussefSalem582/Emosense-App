import 'package:equatable/equatable.dart';

import '../../domain/entities/user_entity.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// App startup / splash: hydrate from local storage via use case.
class AuthCheckRequested extends AuthEvent {
  const AuthCheckRequested();
}

/// Email + password (+ role for Emosense demo dashboards).
class AuthLoginRequested extends AuthEvent {
  const AuthLoginRequested({
    required this.email,
    required this.password,
    this.role = UserRole.employee,
  });

  final String email;
  final String password;
  final UserRole role;

  @override
  List<Object?> get props => [email, password, role];
}

/// Sign up with full signup form fields (mock backend).
class AuthRegisterRequested extends AuthEvent {
  const AuthRegisterRequested({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    this.middleName,
    required this.lastName,
    this.phone,
    this.birthDate,
    this.employeeId,
    this.department,
    required this.role,
  });

  final String email;
  final String password;
  final String passwordConfirmation;
  final String firstName;
  final String? middleName;
  final String lastName;
  final String? phone;
  final String? birthDate;
  final String? employeeId;
  final String? department;
  final UserRole role;

  @override
  List<Object?> get props => [
        email,
        password,
        passwordConfirmation,
        firstName,
        middleName,
        lastName,
        phone,
        birthDate,
        employeeId,
        department,
        role,
      ];
}

class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

class AuthDeleteAccountRequested extends AuthEvent {
  const AuthDeleteAccountRequested();
}

class AuthForgotPasswordRequested extends AuthEvent {
  const AuthForgotPasswordRequested({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}

class AuthErrorCleared extends AuthEvent {
  const AuthErrorCleared();
}

/// Replaces former [UserBloc] preference updates while authenticated.
class AuthPreferencesUpdated extends AuthEvent {
  const AuthPreferencesUpdated({required this.preferences});

  final UserPreferences preferences;

  @override
  List<Object?> get props => [preferences];
}

/// Mock/native Google placeholder — no `google_sign_in` dependency yet.
class AuthGoogleSignInRequested extends AuthEvent {
  const AuthGoogleSignInRequested({this.idToken});

  final String? idToken;

  @override
  List<Object?> get props => [idToken];
}

class AuthSessionExpired extends AuthEvent {
  const AuthSessionExpired();
}
