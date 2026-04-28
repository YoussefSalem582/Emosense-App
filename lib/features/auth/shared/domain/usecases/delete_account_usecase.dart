import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/no_params.dart';
import '../../../../../core/usecases/usecase.dart';

import '../repositories/auth_repository.dart';

class DeleteAccountUseCase extends UseCase<bool, NoParams> {
  DeleteAccountUseCase(this.repository);

  final AuthRepository repository;

  @override
  Future<Either<Failure, bool>> call(NoParams params) {
    return repository.deleteAccount();
  }
}
