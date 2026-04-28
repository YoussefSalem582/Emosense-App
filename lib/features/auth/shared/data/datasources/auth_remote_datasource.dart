import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';

/// Remote contracts only (no Flutter imports). Backed by mock until real auth API lands.
abstract class AuthRemoteDataSource {
  Future<AuthResponseEntity> login({
    required String email,
    required String password,
    required UserRole role,
  });

  Future<AuthResponseEntity> register({required RegisterRequestDto request});

  Future<void> logout();

  Future<void> deleteAccount();

  Future<String> forgotPassword({required String email});

  Future<AuthResponseEntity> googleSignIn({String? idToken});
}

class RegisterRequestDto {
  RegisterRequestDto({
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.firstName,
    required this.lastName,
    this.middleName,
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
  final String lastName;
  final String? middleName;
  final String? phone;
  final String? birthDate;
  final String? employeeId;
  final String? department;
  final UserRole role;
}
