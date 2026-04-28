import 'package:emosense_mobile/core/errors/failures.dart';
import 'package:emosense_mobile/core/usecases/usecase.dart';

import 'package:emosense_mobile/features/auth/shared/data/datasources/auth_local_datasource.dart';
import 'package:emosense_mobile/features/auth/shared/data/datasources/auth_remote_datasource.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/auth_response_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/entities/user_entity.dart';
import 'package:emosense_mobile/features/auth/shared/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remote = remoteDataSource,
        _local = localDataSource;

  final AuthRemoteDataSource _remote;
  final AuthLocalDataSource _local;

  @override
  Future<Either<Failure, AuthResponseEntity>> login({
    required String email,
    required String password,
    required UserRole role,
  }) async {
    try {
      final response = await _remote.login(
        email: email,
        password: password,
        role: role,
      );
      await _local.cacheAuthData(response: response);
      return eitherRight(response);
    } catch (e) {
      return eitherLeft(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> register({
    required RegisterRequest request,
  }) async {
    try {
      final response = await _remote.register(
        request: RegisterRequestDto(
          email: request.email,
          password: request.password,
          passwordConfirmation: request.passwordConfirmation,
          firstName: request.firstName,
          lastName: request.lastName,
          middleName: request.middleName,
          phone: request.phone,
          birthDate: request.birthDate,
          employeeId: request.employeeId,
          department: request.department,
          role: request.role,
        ),
      );
      await _local.cacheAuthData(response: response);
      return eitherRight(response);
    } catch (e) {
      return eitherLeft(AuthFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> logout() async {
    try {
      await _remote.logout();
      await _local.clearAuthData();
      return eitherRight(true);
    } catch (e) {
      await _local.clearAuthData();
      return eitherRight(true);
    }
  }

  @override
  Future<Either<Failure, bool>> deleteAccount() async {
    try {
      await _remote.deleteAccount();
      await _local.clearAuthData();
      return eitherRight(true);
    } catch (e) {
      return eitherLeft(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword({required String email}) async {
    try {
      final msg = await _remote.forgotPassword(email: email);
      return eitherRight(msg);
    } catch (e) {
      return eitherLeft(NetworkFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCachedUser() async {
    try {
      final user = await _local.getCachedUser();
      return eitherRight<Failure, UserEntity?>(user);
    } catch (e) {
      return eitherLeft(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final logged = await _local.hasSession();
      return eitherRight(logged);
    } catch (e) {
      return eitherLeft(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthResponseEntity>> googleSignIn({
    String? idToken,
  }) async {
    try {
      final response = await _remote.googleSignIn(idToken: idToken);
      await _local.cacheAuthData(response: response);
      return eitherRight(response);
    } catch (e) {
      return eitherLeft(AuthFailure(e.toString()));
    }
  }
}
