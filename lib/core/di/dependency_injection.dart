import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

// Services
import '../../data/services/video_analysis_api_service.dart';
import '../../data/services/emotion_api_service.dart';

// Repositories
import '../../data/repositories/video_analysis_repository.dart';
import '../../features/tickets/data/repositories/mock_ticket_repository.dart';
import '../../features/tickets/domain/repositories/ticket_repository.dart';

// Use cases
import '../../features/tickets/domain/usecases/ticket_usecases.dart';

// Cubits / Bloc
import '../../presentation/cubit/video_analysis/video_analysis_cubit.dart';
import '../../presentation/cubit/emotion/emotion_cubit.dart';
import '../../presentation/cubit/user/user_cubit.dart';
import '../../presentation/cubit/text_analysis/text_analysis_cubit.dart';
import '../../presentation/cubit/voice_analysis/voice_analysis_cubit.dart';
import '../../presentation/cubit/analysis/analysis_cubit.dart';
import '../../presentation/cubit/employee_dashboard/employee_dashboard_cubit.dart';
import '../../presentation/cubit/employee_analytics/employee_analytics_cubit.dart';
import '../../presentation/cubit/employee_performance/employee_performance_cubit.dart';
import '../../presentation/cubit/admin_dashboard/admin_dashboard_cubit.dart';
import '../../features/tickets/presentation/bloc/tickets_bloc.dart';

final GetIt sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<http.Client>(() => http.Client());

  sl.registerLazySingleton<VideoAnalysisApiService>(
    () => VideoAnalysisApiService(client: sl()),
  );
  sl.registerLazySingleton<EmotionApiService>(
    () => EmotionApiService(client: sl()),
  );

  sl.registerLazySingleton<VideoAnalysisRepository>(
    () => VideoAnalysisRepository(sl()),
  );

  _initTickets();

  sl.registerFactory<VideoAnalysisCubit>(() => VideoAnalysisCubit(sl()));
  sl.registerFactory<TextAnalysisCubit>(() => TextAnalysisCubit(sl()));
  sl.registerFactory<VoiceAnalysisCubit>(() => VoiceAnalysisCubit());
  sl.registerFactory<AnalysisCubit>(() => AnalysisCubit(sl()));

  sl.registerFactory<EmotionCubit>(() => EmotionCubit(sl()));
  sl.registerFactory<UserCubit>(() => UserCubit());

  sl.registerFactory<EmployeeDashboardCubit>(() => EmployeeDashboardCubit());
  sl.registerFactory<EmployeeAnalyticsCubit>(() => EmployeeAnalyticsCubit());
  sl.registerFactory<EmployeePerformanceCubit>(
    () => EmployeePerformanceCubit(),
  );

  sl.registerFactory<AdminDashboardCubit>(() => AdminDashboardCubit());
}

/// Ticket use cases, mock repository, and [TicketsBloc] factory.
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
