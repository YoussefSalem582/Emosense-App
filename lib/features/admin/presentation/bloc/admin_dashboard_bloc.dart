import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  AdminDashboardBloc() : super(const AdminDashboardInitial()) {
    on<AdminDashboardLoadRequested>(_onLoad);
    on<AdminDashboardRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    AdminDashboardLoadRequested event,
    Emitter<AdminDashboardState> emit,
  ) async {
    emit(const AdminDashboardLoading());

    try {
      await Future.delayed(const Duration(seconds: 1));

      emit(
        AdminDashboardLoaded({
          'totalUsers': 5,
          'activeUsers': 3,
          'totalAnalyses': 57,
          'systemHealth': 89.5,
          'criticalAlerts': 3,
          'pendingTasks': 17,
          'serverUptime': 99.9,
        }),
      );
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }

  Future<void> _onRefresh(
    AdminDashboardRefreshRequested event,
    Emitter<AdminDashboardState> emit,
  ) async {
    try {
      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        AdminDashboardLoaded({
          'totalUsers': 5 + (DateTime.now().millisecond % 10),
          'activeUsers': 3 + (DateTime.now().millisecond % 5),
          'totalAnalyses': 57 + (DateTime.now().millisecond % 20),
          'systemHealth': 89.5 + (DateTime.now().millisecond % 10) / 10,
          'criticalAlerts': DateTime.now().millisecond % 5,
          'pendingTasks': 17 + (DateTime.now().millisecond % 8),
          'serverUptime': 99.9,
        }),
      );
    } catch (e) {
      emit(AdminDashboardError(e.toString()));
    }
  }
}
