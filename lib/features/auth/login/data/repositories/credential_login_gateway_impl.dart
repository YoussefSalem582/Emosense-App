import 'package:emosense_mobile/core/errors/failures.dart';
import 'package:emosense_mobile/core/usecases/usecase.dart';
import 'package:emosense_mobile/features/auth/login/domain/repositories/credential_login_gateway.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/usecases/login_usecase.dart';

class CredentialLoginGatewayImpl implements CredentialLoginGateway {
  CredentialLoginGatewayImpl({required LoginUseCase login}) : _login = login;

  final LoginUseCase _login;

  @override
  Future<Either<Failure, AuthResponseEntity>> login(LoginParams params) => _login(params);
}
