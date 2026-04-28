import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/features/employee/performance/domain/entities/employee_performance_data.dart';
import 'package:emosense_mobile/features/employee/performance/domain/repositories/employee_performance_repository.dart';

part 'employee_performance_event.dart';
part 'employee_performance_state.dart';

class EmployeePerformanceBloc
    extends Bloc<EmployeePerformanceEvent, EmployeePerformanceState> {
  EmployeePerformanceBloc({required EmployeePerformanceRepository repository})
    : _repository = repository,
      super(const EmployeePerformanceInitial()) {
    on<EmployeePerformanceLoadRequested>(_onLoad);
    on<EmployeePerformanceRefreshRequested>(_onRefresh);
  }

  final EmployeePerformanceRepository _repository;

  Future<void> _onLoad(
    EmployeePerformanceLoadRequested event,
    Emitter<EmployeePerformanceState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onRefresh(
    EmployeePerformanceRefreshRequested event,
    Emitter<EmployeePerformanceState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<EmployeePerformanceState> emit) async {
    emit(const EmployeePerformanceLoading());

    try {
      final data = await _repository.fetchOverview();
      emit(EmployeePerformanceSuccess(data));
    } catch (e) {
      emit(EmployeePerformanceError(e.toString()));
    }
  }
}
