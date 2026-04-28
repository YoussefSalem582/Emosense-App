import 'dart:math';

import 'package:emosense_mobile/features/auth/shared/data/datasources/auth_remote_datasource.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';

/// In-memory auth for development: delay + synthetic [UserEntity] / token.
///
/// Swap for a REST-backed impl when `/auth/*` endpoints are available.
class AuthRemoteDataSourceMock implements AuthRemoteDataSource {
  @override
  Future<AuthResponseEntity> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(seconds: 2));
    final trimmed = email.trim();
    if (trimmed.isEmpty || password.isEmpty) {
      throw StateError('Invalid credentials.');
    }
    final id =
        trimmed.contains('@') ? trimmed.split('@').first : trimmed.isNotEmpty
            ? trimmed
            : 'local-user';

    final user = UserEntity(
      id: id.isNotEmpty ? id : 'local-user',
      name:
          trimmed.contains('@')
              ? trimmed.split('@').first
              : (trimmed.isNotEmpty ? trimmed : 'User'),
      email: trimmed.isNotEmpty ? trimmed : 'user@local',
      role: role,
      avatar: null,
      createdAt: DateTime.now(),
      preferences: const UserPreferences(),
    );
    return AuthResponseEntity(user: user, token: _fakeToken());
  }

  @override
  Future<AuthResponseEntity> register({required RegisterRequestDto request}) async {
    await Future.delayed(const Duration(seconds: 2));
    final email = request.email.trim();
    final first = request.firstName.trim();
    final last = request.lastName.trim();
    final name = '$first $last'.trim();
    final employeeId = request.employeeId?.trim() ?? '';
    final id = employeeId.isNotEmpty ? employeeId : (email.isNotEmpty ? email : 'new-user');
    final user = UserEntity(
      id: id.isNotEmpty ? id : 'new-user',
      name:
          name.isNotEmpty
              ? name
              : (email.contains('@') ? email.split('@').first : 'User'),
      email: email,
      role: request.role,
      avatar: null,
      createdAt: DateTime.now(),
      preferences: const UserPreferences(),
    );
    return AuthResponseEntity(user: user, token: _fakeToken());
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
  }

  @override
  Future<void> deleteAccount() async {
    await Future.delayed(const Duration(milliseconds: 300));
  }

  @override
  Future<String> forgotPassword({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (email.trim().isEmpty) {
      throw StateError('Email required.');
    }
    return 'If an account exists, reset instructions were sent.';
  }

  @override
  Future<AuthResponseEntity> googleSignIn({String? idToken}) async {
    await Future.delayed(const Duration(seconds: 1));
    final user = UserEntity(
      id: idToken ?? 'social-${Random().nextInt(1 << 20)}',
      name: 'Google user',
      email: idToken ?? 'google@social.local',
      role: UserRole.employee,
      avatar: null,
      createdAt: DateTime.now(),
      preferences: const UserPreferences(),
    );
    return AuthResponseEntity(user: user, token: _fakeToken());
  }

  String _fakeToken() =>
      'mock-${DateTime.now().microsecondsSinceEpoch.toRadixString(36)}';
}
