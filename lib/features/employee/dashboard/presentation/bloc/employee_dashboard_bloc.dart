import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/features/employee/dashboard/domain/entities/employee_dashboard_data.dart';
import 'package:emosense_mobile/features/employee/dashboard/domain/repositories/employee_dashboard_repository.dart';

part 'employee_dashboard_event.dart';
part 'employee_dashboard_state.dart';

class EmployeeDashboardBloc
    extends Bloc<EmployeeDashboardEvent, EmployeeDashboardState> {
  EmployeeDashboardBloc({required EmployeeDashboardRepository repository})
    : _repository = repository,
      super(const EmployeeDashboardInitial()) {
    on<EmployeeDashboardLoadRequested>(_onLoad);
    on<EmployeeDashboardRefreshRequested>(_onRefresh);
  }

  final EmployeeDashboardRepository _repository;

  Future<void> _onLoad(
    EmployeeDashboardLoadRequested event,
    Emitter<EmployeeDashboardState> emit,
  ) async {
    await _loadDashboard(emit);
  }

  Future<void> _onRefresh(
    EmployeeDashboardRefreshRequested event,
    Emitter<EmployeeDashboardState> emit,
  ) async {
    await _loadDashboard(emit);
  }

  Future<void> _loadDashboard(Emitter<EmployeeDashboardState> emit) async {
    emit(const EmployeeDashboardLoading());

    try {
      final data = await _repository.fetchOverview();
      emit(EmployeeDashboardSuccess(data));
    } catch (e) {
      emit(EmployeeDashboardError(e.toString()));
    }
  }
}
