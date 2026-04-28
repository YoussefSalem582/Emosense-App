part of 'employee_performance_bloc.dart';

abstract class EmployeePerformanceState extends Equatable {
  const EmployeePerformanceState();

  @override
  List<Object?> get props => [];
}

class EmployeePerformanceInitial extends EmployeePerformanceState {
  const EmployeePerformanceInitial();
}

class EmployeePerformanceLoading extends EmployeePerformanceState {
  const EmployeePerformanceLoading();
}

class EmployeePerformanceSuccess extends EmployeePerformanceState {
  final EmployeePerformanceData data;

  const EmployeePerformanceSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeePerformanceError extends EmployeePerformanceState {
  final String message;

  const EmployeePerformanceError(this.message);

  @override
  List<Object?> get props => [message];
}
