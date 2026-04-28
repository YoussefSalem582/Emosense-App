import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Services
import '../services/emotion_api_service.dart';
import '../../features/analysis/data/datasources/video_analysis_remote_data_source.dart';
import '../../features/analysis/data/repositories/video_analysis_repository_impl.dart';
import '../../features/analysis/data/services/video_analysis_api_service.dart';
import '../../features/analysis/domain/repositories/video_analysis_repository.dart';
import '../../features/analysis/presentation/bloc/text_analysis_bloc.dart';
import '../../features/analysis/presentation/bloc/video_analysis_bloc.dart';
import '../../features/analysis/presentation/bloc/voice_analysis_bloc.dart';
import '../../features/tickets/data/datasources/mock_ticket_local_data_source.dart';
import '../../features/tickets/data/datasources/ticket_local_data_source.dart';
import '../../features/tickets/data/repositories/ticket_repository_impl.dart';
import '../../features/tickets/domain/repositories/ticket_repository.dart';
import '../../features/tickets/domain/usecases/assign_ticket_usecase.dart';
import '../../features/tickets/domain/usecases/create_ticket_usecase.dart';
import '../../features/tickets/domain/usecases/get_ticket_statistics_usecase.dart';
import '../../features/tickets/domain/usecases/load_tickets_usecase.dart';
import '../../features/tickets/domain/usecases/update_ticket_status_usecase.dart';
import '../../features/tickets/presentation/bloc/tickets_bloc.dart';
import '../../features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import '../../features/employee/presentation/bloc/employee_analytics_bloc.dart';
import '../../features/employee/presentation/bloc/employee_dashboard_bloc.dart';
import '../../features/employee/presentation/bloc/employee_performance_bloc.dart';
import '../../features/auth/auth_choice/presentation/bloc/auth_choice_bloc.dart';
import '../../features/auth/login/presentation/bloc/login_bloc.dart';
import '../../features/auth/onboarding/presentation/bloc/onboarding_bloc.dart';
import '../../features/auth/role_selection/presentation/bloc/role_selection_bloc.dart';
import '../../features/auth/signup/presentation/bloc/signup_bloc.dart';
import '../../features/auth/shared/data/datasources/auth_local_datasource.dart';
import '../../features/auth/splash/presentation/bloc/splash_bloc.dart';
import '../../features/auth/shared/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/shared/data/datasources/auth_remote_datasource_mock.dart';
import '../../features/auth/shared/data/repositories/auth_repository_impl.dart';
import '../../features/auth/shared/domain/repositories/auth_repository.dart';
import '../../features/auth/shared/domain/usecases/delete_account_usecase.dart';
import '../../features/auth/shared/domain/usecases/forgot_password_usecase.dart';
import '../../features/auth/shared/domain/usecases/get_cached_user_usecase.dart';
import '../../features/auth/shared/domain/usecases/google_sign_in_usecase.dart';
import '../../features/auth/shared/domain/usecases/login_usecase.dart';
import '../../features/auth/shared/domain/usecases/logout_usecase.dart';
import '../../features/auth/shared/domain/usecases/register_usecase.dart';
import '../../features/auth/shared/presentation/bloc/auth_bloc.dart';
import '../../features/emotion/presentation/bloc/emotion_bloc.dart';
import '../network/connection_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registers all dependencies (aligned with reference app naming).
Future<void> initDependencies() async {
  sl.registerLazySingleton<http.Client>(() => http.Client());

  _initAnalysis();
  _initEmotion();
  _initTickets();
  _initAuthSlice();
  _initEmployee();
  _initAdmin();
  _initConnectivity();
}

// ─── Analysis (video/text/voice) ─────────────────────────────────────────────
void _initAnalysis() {
  sl.registerLazySingleton<VideoAnalysisRemoteDataSource>(
    () => VideoAnalysisApiService(client: sl()),
  );
  sl.registerLazySingleton<VideoAnalysisRepository>(
    () => VideoAnalysisRepositoryImpl(sl()),
  );
  sl.registerFactory<VideoAnalysisBloc>(() => VideoAnalysisBloc(sl()));
  sl.registerFactory<TextAnalysisBloc>(() => TextAnalysisBloc(sl()));
  sl.registerFactory<VoiceAnalysisBloc>(() => VoiceAnalysisBloc());
}

// ─── Emotion API + dashboards ───────────────────────────────────────────────
void _initEmotion() {
  sl.registerLazySingleton<EmotionApiService>(
    () => EmotionApiService(client: sl()),
  );
  sl.registerFactory<EmotionBloc>(() => EmotionBloc(sl()));
}

// ─── Tickets ─────────────────────────────────────────────────────────────────
void _initTickets() {
  sl.registerLazySingleton<TicketLocalDataSource>(
    () => MockTicketLocalDataSource(),
  );
  sl.registerLazySingleton<TicketRepository>(() => TicketRepositoryImpl(sl()));

  sl.registerFactory<LoadTicketsUseCase>(() => LoadTicketsUseCase(sl()));
  sl.registerFactory<CreateTicketUseCase>(() => CreateTicketUseCase(sl()));
  sl.registerFactory<UpdateTicketStatusUseCase>(
    () => UpdateTicketStatusUseCase(sl()),
  );
  sl.registerFactory<AssignTicketUseCase>(() => AssignTicketUseCase(sl()));
  sl.registerFactory<GetTicketStatisticsUseCase>(
    () => GetTicketStatisticsUseCase(sl()),
  );

  sl.registerFactory<TicketsBloc>(
    () => TicketsBloc(
      loadTicketsUseCase: sl(),
      createTicketUseCase: sl(),
      updateTicketStatusUseCase: sl(),
      assignTicketUseCase: sl(),
      getTicketStatisticsUseCase: sl(),
    ),
  );
}

void _initAuthSlice() {
  sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceMock());
  sl.registerLazySingleton<AuthLocalDataSource>(() => AuthLocalDataSourceImpl());
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDataSource: sl(), localDataSource: sl()),
  );

  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => RegisterUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));
  sl.registerLazySingleton(() => ForgotPasswordUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));
  sl.registerLazySingleton(() => GoogleSignInUseCase(sl()));

  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      loginUseCase: sl(),
      registerUseCase: sl(),
      logoutUseCase: sl(),
      deleteAccountUseCase: sl(),
      forgotPasswordUseCase: sl(),
      getCachedUserUseCase: sl(),
      googleSignInUseCase: sl(),
    ),
  );

  sl.registerFactory(() => SplashBloc(authBloc: sl<AuthBloc>()));
  sl.registerFactory(OnboardingBloc.new);
  sl.registerFactory(AuthChoiceBloc.new);
  sl.registerFactory(LoginBloc.new);
  sl.registerFactory(SignUpBloc.new);
  sl.registerFactory(RoleSelectionBloc.new);
}

void _initEmployee() {
  sl.registerFactory<EmployeeDashboardBloc>(() => EmployeeDashboardBloc());
  sl.registerFactory<EmployeeAnalyticsBloc>(() => EmployeeAnalyticsBloc());
  sl.registerFactory<EmployeePerformanceBloc>(() => EmployeePerformanceBloc());
}

void _initAdmin() {
  sl.registerFactory<AdminDashboardBloc>(() => AdminDashboardBloc());
}

void _initConnectivity() {
  sl.registerFactory<ConnectionBloc>(() => ConnectionBloc());
}
