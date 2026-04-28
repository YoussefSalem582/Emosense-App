import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';

import '../entities/auth_response_entity.dart';
import '../entities/user_entity.dart';

/// Auth persistence and remote contract (adapted from reference Clean Architecture slice).
abstract class AuthRepository {
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
    required UserRole role,
  });

  Future<Either<Failure, AuthResponseEntity>> register({
    required RegisterRequest request,
  });

  /// Successful completion is represented as `true` (record-[Either] has no Unit).
  Future<Either<Failure, bool>> logout();

  Future<Either<Failure, bool>> deleteAccount();

  Future<Either<Failure, String>> forgotPassword({required String email});

  Future<Either<Failure, UserEntity?>> getCachedUser();

  Future<Either<Failure, bool>> isLoggedIn();

  /// Dev/local Google-style sign-in (`idToken` optional for mock backends).
  Future<Either<Failure, AuthResponseEntity>> googleSignIn({String? idToken});
}

/// Parameter object for signup — extends reference fields with Emosense-only inputs.
class RegisterRequest {
  const RegisterRequest({
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
