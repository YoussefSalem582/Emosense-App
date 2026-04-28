import 'package:emosense_mobile/core/errors/failures.dart';
import 'package:emosense_mobile/core/usecases/usecase.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/usecases/register_usecase.dart';
import 'package:emosense_mobile/features/auth/signup/domain/repositories/registration_gateway.dart';

class RegistrationGatewayImpl implements RegistrationGateway {
  RegistrationGatewayImpl({required RegisterUseCase register}) : _register = register;

  final RegisterUseCase _register;

  @override
  Future<Either<Failure, AuthResponseEntity>> register(RegisterParams params) =>
      _register(params);
}
