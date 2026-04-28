import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/features/employee/shared/domain/entities/employee_analytics_data.dart';
import 'package:emosense_mobile/features/employee/shared/domain/repositories/employee_analytics_repository.dart';

part 'employee_analytics_event.dart';
part 'employee_analytics_state.dart';

class EmployeeAnalyticsBloc
    extends Bloc<EmployeeAnalyticsEvent, EmployeeAnalyticsState> {
  EmployeeAnalyticsBloc({required EmployeeAnalyticsRepository repository})
    : _repository = repository,
      super(const EmployeeAnalyticsInitial()) {
    on<EmployeeAnalyticsFetched>(_onFetched);
    on<EmployeeAnalyticsRefreshRequested>(_onRefresh);
  }

  final EmployeeAnalyticsRepository _repository;
  String _timeRange = 'This Week';

  Future<void> _onFetched(
    EmployeeAnalyticsFetched event,
    Emitter<EmployeeAnalyticsState> emit,
  ) async {
    if (event.timeRange != null) {
      _timeRange = event.timeRange!;
    }
    await _fetch(emit);
  }

  Future<void> _onRefresh(
    EmployeeAnalyticsRefreshRequested event,
    Emitter<EmployeeAnalyticsState> emit,
  ) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<EmployeeAnalyticsState> emit) async {
    emit(const EmployeeAnalyticsLoading());

    try {
      final data = await _repository.fetchOverview(timeRange: _timeRange);
      emit(EmployeeAnalyticsSuccess(data));
    } catch (e) {
      emit(EmployeeAnalyticsError(e.toString()));
    }
  }
}
