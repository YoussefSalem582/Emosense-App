import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';

import '../entities/auth_response_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase extends UseCase<AuthResponseEntity, RegisterParams> {
  RegisterUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AuthResponseEntity>> call(RegisterParams params) {
    return repository.register(
      request: RegisterRequest(
        email: params.email,
        password: params.password,
        passwordConfirmation: params.passwordConfirmation,
        firstName: params.firstName,
        lastName: params.lastName,
        middleName: params.middleName,
        phone: params.phone,
        birthDate: params.birthDate,
        employeeId: params.employeeId,
        department: params.department,
        role: params.role,
      ),
    );
  }
}

class RegisterParams extends Equatable {
  const RegisterParams({
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

  @override
  List<Object?> get props => [
    email,
    password,
    passwordConfirmation,
    firstName,
    lastName,
    middleName,
    phone,
    birthDate,
    employeeId,
    department,
    role,
  ];
}
