import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';

import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase extends UseCase<String, ForgotPasswordParams> {
  ForgotPasswordUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params) {
    return repository.forgotPassword(email: params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  const ForgotPasswordParams({required this.email});

  final String email;

  @override
  List<Object?> get props => [email];
}
