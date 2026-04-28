import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Services
import '../../data/services/emotion_api_service.dart';
import '../../features/analysis/data/repositories/video_analysis_repository_impl.dart';
import '../../features/analysis/data/services/video_analysis_api_service.dart';
import '../../features/analysis/domain/repositories/video_analysis_repository.dart';
import '../../features/analysis/presentation/bloc/text_analysis_bloc.dart';
import '../../features/analysis/presentation/bloc/video_analysis_bloc.dart';
import '../../features/analysis/presentation/bloc/voice_analysis_bloc.dart';
import '../../features/tickets/data/repositories/mock_ticket_repository.dart';
import '../../features/tickets/domain/repositories/ticket_repository.dart';
import '../../features/tickets/domain/usecases/ticket_usecases.dart';
import '../../features/tickets/presentation/bloc/tickets_bloc.dart';
import '../../features/admin/presentation/bloc/admin_dashboard_bloc.dart';
import '../../features/employee/presentation/bloc/employee_analytics_bloc.dart';
import '../../features/employee/presentation/bloc/employee_dashboard_bloc.dart';
import '../../features/employee/presentation/bloc/employee_performance_bloc.dart';
import '../../features/auth/presentation/bloc/user_bloc.dart';
import '../../features/emotion/presentation/bloc/emotion_bloc.dart';
import '../network/connection_bloc.dart';

final GetIt sl = GetIt.instance;

/// Registers all dependencies (aligned with reference app naming).
Future<void> initDependencies() async {
  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  _initAnalysis();
  _initTickets();
  _initGlobalBlocs();
}

void _initAnalysis() {
  sl.registerLazySingleton<VideoAnalysisApiService>(
    () => VideoAnalysisApiService(client: sl()),
  );
  sl.registerLazySingleton<EmotionApiService>(
    () => EmotionApiService(client: sl()),
  );
  sl.registerLazySingleton<VideoAnalysisRepository>(
    () => VideoAnalysisRepositoryImpl(sl()),
  );
  sl.registerFactory<VideoAnalysisBloc>(() => VideoAnalysisBloc(sl()));
  sl.registerFactory<TextAnalysisBloc>(() => TextAnalysisBloc(sl()));
  sl.registerFactory<VoiceAnalysisBloc>(() => VoiceAnalysisBloc());
}

void _initGlobalBlocs() {
  sl.registerFactory<UserBloc>(() => UserBloc());
  sl.registerFactory<EmotionBloc>(() => EmotionBloc(sl()));
  sl.registerFactory<ConnectionBloc>(() => ConnectionBloc());
  sl.registerFactory<EmployeeDashboardBloc>(() => EmployeeDashboardBloc());
  sl.registerFactory<EmployeeAnalyticsBloc>(() => EmployeeAnalyticsBloc());
  sl.registerFactory<EmployeePerformanceBloc>(() => EmployeePerformanceBloc());
  sl.registerFactory<AdminDashboardBloc>(() => AdminDashboardBloc());
}

void _initTickets() {
  sl.registerLazySingleton<TicketRepository>(() => MockTicketRepository());

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
