import 'package:equatable/equatable.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';

import '../entities/auth_response_entity.dart';
import '../repositories/auth_repository.dart';

class GoogleSignInUseCase extends UseCase<AuthResponseEntity, GoogleSignInParams> {
  GoogleSignInUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, AuthResponseEntity>> call(GoogleSignInParams params) {
    return repository.googleSignIn(idToken: params.idToken);
  }
}

class GoogleSignInParams extends Equatable {
  const GoogleSignInParams({this.idToken});

  final String? idToken;

  @override
  List<Object?> get props => [idToken];
}
