import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Services
import '../../data/services/emotion_api_service.dart';
import '../../features/analysis/data/repositories/video_analysis_repository_impl.dart';
import '../../features/analysis/data/services/video_analysis_api_service.dart';
import '../../features/analysis/domain/repositories/video_analysis_repository.dart';
import '../../features/analysis/presentation/bloc/video_analysis_bloc.dart';
import '../../features/tickets/data/repositories/mock_ticket_repository.dart';
import '../../features/tickets/domain/repositories/ticket_repository.dart';
import '../../features/tickets/domain/usecases/ticket_usecases.dart';
import '../../features/tickets/presentation/bloc/tickets_bloc.dart';

// Cubits
import '../../presentation/cubit/emotion/emotion_cubit.dart';
import '../../presentation/cubit/user/user_cubit.dart';
import '../../presentation/cubit/text_analysis/text_analysis_cubit.dart';
import '../../presentation/cubit/voice_analysis/voice_analysis_cubit.dart';
import '../../presentation/cubit/analysis/analysis_cubit.dart';
import '../../presentation/cubit/employee_dashboard/employee_dashboard_cubit.dart';
import '../../presentation/cubit/employee_analytics/employee_analytics_cubit.dart';
import '../../presentation/cubit/employee_performance/employee_performance_cubit.dart';
import '../../presentation/cubit/admin_dashboard/admin_dashboard_cubit.dart';
final GetIt sl = GetIt.instance;

Future<void> init() async {
  // HTTP Client
  sl.registerLazySingleton<http.Client>(() => http.Client());

  _initAnalysis();
  _initTickets();
  _initPresentationCubits();
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
  sl.registerFactory<TextAnalysisCubit>(() => TextAnalysisCubit(sl()));
  sl.registerFactory<VoiceAnalysisCubit>(() => VoiceAnalysisCubit());
  sl.registerFactory<AnalysisCubit>(() => AnalysisCubit(sl()));
}

void _initPresentationCubits() {
  sl.registerFactory<EmotionCubit>(() => EmotionCubit(sl()));
  sl.registerFactory<UserCubit>(() => UserCubit());
  sl.registerFactory<EmployeeDashboardCubit>(() => EmployeeDashboardCubit());
  sl.registerFactory<EmployeeAnalyticsCubit>(() => EmployeeAnalyticsCubit());
  sl.registerFactory<EmployeePerformanceCubit>(
    () => EmployeePerformanceCubit(),
  );
  sl.registerFactory<AdminDashboardCubit>(() => AdminDashboardCubit());
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
