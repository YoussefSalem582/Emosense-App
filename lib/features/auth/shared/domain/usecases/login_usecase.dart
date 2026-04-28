import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';

import '../entities/auth_response_entity.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase extends UseCase<AuthResponseEntity, LoginParams> {
  LoginUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AuthResponseEntity>> call(LoginParams params) {
    return repository.login(
      email: params.email,
      password: params.password,
      role: params.role,
    );
  }
}

class LoginParams extends Equatable {
  const LoginParams({
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
