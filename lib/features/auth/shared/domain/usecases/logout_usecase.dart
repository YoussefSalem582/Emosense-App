import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/no_params.dart';
import '../../../../../core/usecases/usecase.dart';

import '../repositories/auth_repository.dart';

class LogoutUseCase extends UseCase<bool, NoParams> {
  LogoutUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.logout();
  }
}
