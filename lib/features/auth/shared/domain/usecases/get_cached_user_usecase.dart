import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/no_params.dart';
import '../../../../../core/usecases/usecase.dart';

import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class GetCachedUserUseCase extends UseCase<UserEntity?, NoParams> {
  GetCachedUserUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, UserEntity?>> call(NoParams params) {
    return repository.getCachedUser();
  }
}
