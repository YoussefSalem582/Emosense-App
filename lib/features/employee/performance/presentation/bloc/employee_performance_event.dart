part of 'employee_performance_bloc.dart';

abstract class EmployeePerformanceEvent extends Equatable {
  const EmployeePerformanceEvent();

  @override
  List<Object?> get props => [];
}

class EmployeePerformanceLoadRequested extends EmployeePerformanceEvent {
  const EmployeePerformanceLoadRequested();
}

class EmployeePerformanceRefreshRequested extends EmployeePerformanceEvent {
  const EmployeePerformanceRefreshRequested();
}
