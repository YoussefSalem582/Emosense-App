import 'package:emosense_mobile/core/errors/failures.dart';
import 'package:emosense_mobile/core/usecases/usecase.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/usecases/register_usecase.dart';

/// Feature-scoped entry for account creation (delegates to shared [RegisterUseCase]).
abstract class RegistrationGateway {
  Future<Either<Failure, AuthResponseEntity>> register(RegisterParams params);
}
