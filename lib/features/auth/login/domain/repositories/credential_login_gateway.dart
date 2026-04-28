import 'package:emosense_mobile/core/errors/failures.dart';
import 'package:emosense_mobile/core/usecases/usecase.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/usecases/login_usecase.dart';

/// Feature-scoped entry point for email/password sign-in (delegates to shared [LoginUseCase]).
abstract class CredentialLoginGateway {
  Future<Either<Failure, AuthResponseEntity>> login(LoginParams params);
}
