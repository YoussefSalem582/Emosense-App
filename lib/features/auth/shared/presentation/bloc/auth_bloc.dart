import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/no_params.dart';
import '../../../../../core/usecases/usecase.dart';
import '../../../login/domain/repositories/credential_login_gateway.dart';
import '../../../signup/domain/repositories/registration_gateway.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/delete_account_usecase.dart';
import '../../domain/usecases/forgot_password_usecase.dart';
import '../../domain/usecases/get_cached_user_usecase.dart';
import '../../domain/usecases/google_sign_in_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_event.dart';
import 'auth_state.dart';

/// Global authentication orchestrator (adapted from reference `AuthBloc`, Emosense types).
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required CredentialLoginGateway credentialLoginGateway,
    required RegistrationGateway registrationGateway,
    required LogoutUseCase logoutUseCase,
    required DeleteAccountUseCase deleteAccountUseCase,
    required ForgotPasswordUseCase forgotPasswordUseCase,
    required GetCachedUserUseCase getCachedUserUseCase,
    required GoogleSignInUseCase googleSignInUseCase,
  })  : _credentialLoginGateway = credentialLoginGateway,
        _registrationGateway = registrationGateway,
        _logoutUseCase = logoutUseCase,
        _deleteAccountUseCase = deleteAccountUseCase,
        _forgotPasswordUseCase = forgotPasswordUseCase,
        _getCachedUserUseCase = getCachedUserUseCase,
        _googleSignInUseCase = googleSignInUseCase,
        super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheckRequested);
    on<AuthLoginRequested>(_onLoginRequested);
    on<AuthRegisterRequested>(_onRegisterRequested);
    on<AuthLogoutRequested>(_onLogoutRequested);
    on<AuthDeleteAccountRequested>(_onDeleteAccountRequested);
    on<AuthForgotPasswordRequested>(_onForgotPasswordRequested);
    on<AuthErrorCleared>(_onErrorCleared);
    on<AuthPreferencesUpdated>(_onPreferencesUpdated);
    on<AuthGoogleSignInRequested>(_onGoogleSignInRequested);
    on<AuthSessionExpired>(_onSessionExpired);
  }

  final CredentialLoginGateway _credentialLoginGateway;
  final RegistrationGateway _registrationGateway;
  final LogoutUseCase _logoutUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final ForgotPasswordUseCase _forgotPasswordUseCase;
  final GetCachedUserUseCase _getCachedUserUseCase;
  final GoogleSignInUseCase _googleSignInUseCase;

  Future<void> _onCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _getCachedUserUseCase(const NoParams());
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (UserEntity? user) {
        if (user != null) {
          emit(AuthAuthenticated(user: user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  Future<void> _onLoginRequested(
    AuthLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _credentialLoginGateway.login(
      LoginParams(
        email: event.email,
        password: event.password,
        role: event.role,
      ),
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (auth) => emit(AuthAuthenticated(user: auth.user)),
    );
  }

  Future<void> _onRegisterRequested(
    AuthRegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _registrationGateway.register(
      RegisterParams(
        email: event.email,
        password: event.password,
        passwordConfirmation: event.passwordConfirmation,
        firstName: event.firstName,
        middleName: event.middleName,
        lastName: event.lastName,
        phone: event.phone,
        birthDate: event.birthDate,
        employeeId: event.employeeId,
        department: event.department,
        role: event.role,
      ),
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (auth) => emit(AuthAuthenticated(user: auth.user)),
    );
  }

  Future<void> _onLogoutRequested(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    await _logoutUseCase(const NoParams());
    emit(const AuthUnauthenticated());
  }

  Future<void> _onDeleteAccountRequested(
    AuthDeleteAccountRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _deleteAccountUseCase(const NoParams());
    result.fold((failure) => emit(_mapFailureToState(failure)), (_) {
      emit(const AuthUnauthenticated());
    });
  }

  Future<void> _onForgotPasswordRequested(
    AuthForgotPasswordRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _forgotPasswordUseCase(
      ForgotPasswordParams(email: event.email),
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (message) => emit(AuthForgotPasswordSuccess(message: message)),
    );
  }

  void _onErrorCleared(AuthErrorCleared event, Emitter<AuthState> emit) {
    emit(const AuthUnauthenticated());
  }

  void _onPreferencesUpdated(
    AuthPreferencesUpdated event,
    Emitter<AuthState> emit,
  ) {
    final cur = state;
    if (cur is AuthAuthenticated) {
      emit(
        cur.copyWith(
          user: UserEntity(
            id: cur.user.id,
            name: cur.user.name,
            email: cur.user.email,
            role: cur.user.role,
            avatar: cur.user.avatar,
            createdAt: cur.user.createdAt,
            preferences: event.preferences,
          ),
        ),
      );
    }
  }

  Future<void> _onGoogleSignInRequested(
    AuthGoogleSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _googleSignInUseCase(
      GoogleSignInParams(idToken: event.idToken),
    );
    result.fold(
      (failure) => emit(_mapFailureToState(failure)),
      (auth) => emit(AuthAuthenticated(user: auth.user)),
    );
  }

  Future<void> _onSessionExpired(
    AuthSessionExpired event,
    Emitter<AuthState> emit,
  ) async {
    if (state is AuthUnauthenticated) return;
    emit(const AuthLoading());
    await _logoutUseCase(const NoParams());
    emit(const AuthUnauthenticated());
  }

  AuthError _mapFailureToState(Failure failure) {
    if (failure is ValidationFailure) {
      return AuthError(
        message: failure.message,
      );
    }
    return AuthError(message: failure.message);
  }
}
