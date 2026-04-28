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
import '../../features/employee/analysis_tools/data/datasources/employee_analysis_tools_local_data_source.dart';
import '../../features/employee/analysis_tools/data/datasources/employee_analysis_tools_local_data_source_impl.dart';
import '../../features/employee/analysis_tools/data/repositories/employee_analysis_tools_repository_impl.dart';
import '../../features/employee/analysis_tools/domain/repositories/employee_analysis_tools_repository.dart';
import '../../features/employee/dashboard/data/datasources/employee_dashboard_local_data_source.dart';
import '../../features/employee/dashboard/data/datasources/employee_dashboard_local_data_source_impl.dart';
import '../../features/employee/dashboard/data/repositories/employee_dashboard_repository_impl.dart';
import '../../features/employee/dashboard/domain/repositories/employee_dashboard_repository.dart';
import '../../features/employee/dashboard/presentation/bloc/employee_dashboard_bloc.dart';
import '../../features/employee/navigation/data/datasources/employee_navigation_local_data_source.dart';
import '../../features/employee/navigation/data/datasources/employee_navigation_local_data_source_impl.dart';
import '../../features/employee/navigation/data/repositories/employee_navigation_repository_impl.dart';
import '../../features/employee/navigation/domain/repositories/employee_navigation_repository.dart';
import '../../features/employee/performance/data/datasources/employee_performance_local_data_source.dart';
import '../../features/employee/performance/data/datasources/employee_performance_local_data_source_impl.dart';
import '../../features/employee/performance/data/repositories/employee_performance_repository_impl.dart';
import '../../features/employee/performance/domain/repositories/employee_performance_repository.dart';
import '../../features/employee/performance/presentation/bloc/employee_performance_bloc.dart';
import '../../features/employee/profile/data/datasources/employee_profile_local_data_source.dart';
import '../../features/employee/profile/data/datasources/employee_profile_local_data_source_impl.dart';
import '../../features/employee/profile/data/repositories/employee_profile_repository_impl.dart';
import '../../features/employee/profile/domain/repositories/employee_profile_repository.dart';
import '../../features/employee/shared/data/datasources/employee_analytics_local_data_source.dart';
import '../../features/employee/shared/data/datasources/employee_analytics_local_data_source_impl.dart';
import '../../features/employee/shared/data/repositories/employee_analytics_repository_impl.dart';
import '../../features/employee/shared/domain/repositories/employee_analytics_repository.dart';
import '../../features/employee/shared/presentation/bloc/employee_analytics_bloc.dart';
import '../../features/auth/presentation/bloc/user_bloc.dart';
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
  sl.registerFactory<UserBloc>(() => UserBloc());
}

void _initEmployee() {
  sl.registerLazySingleton<EmployeeDashboardLocalDataSource>(
    () => EmployeeDashboardLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<EmployeeDashboardRepository>(
    () => EmployeeDashboardRepositoryImpl(sl()),
  );
  sl.registerFactory<EmployeeDashboardBloc>(
    () => EmployeeDashboardBloc(repository: sl()),
  );

  sl.registerLazySingleton<EmployeeAnalyticsLocalDataSource>(
    () => EmployeeAnalyticsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<EmployeeAnalyticsRepository>(
    () => EmployeeAnalyticsRepositoryImpl(sl()),
  );
  sl.registerFactory<EmployeeAnalyticsBloc>(
    () => EmployeeAnalyticsBloc(repository: sl()),
  );

  sl.registerLazySingleton<EmployeePerformanceLocalDataSource>(
    () => EmployeePerformanceLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<EmployeePerformanceRepository>(
    () => EmployeePerformanceRepositoryImpl(sl()),
  );
  sl.registerFactory<EmployeePerformanceBloc>(
    () => EmployeePerformanceBloc(repository: sl()),
  );

  sl.registerLazySingleton<EmployeeNavigationLocalDataSource>(
    () => EmployeeNavigationLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<EmployeeNavigationRepository>(
    () => EmployeeNavigationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<EmployeeProfileLocalDataSource>(
    () => EmployeeProfileLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<EmployeeProfileRepository>(
    () => EmployeeProfileRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<EmployeeAnalysisToolsLocalDataSource>(
    () => EmployeeAnalysisToolsLocalDataSourceImpl(),
  );
  sl.registerLazySingleton<EmployeeAnalysisToolsRepository>(
    () => EmployeeAnalysisToolsRepositoryImpl(sl()),
  );
}

void _initAdmin() {
  sl.registerFactory<AdminDashboardBloc>(() => AdminDashboardBloc());
}

void _initConnectivity() {
  sl.registerFactory<ConnectionBloc>(() => ConnectionBloc());
}
