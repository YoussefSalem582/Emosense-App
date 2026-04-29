part of 'employee_dashboard_bloc.dart';

abstract class EmployeeDashboardState extends Equatable {
  const EmployeeDashboardState();

  @override
  List<Object?> get props => [];
}

class EmployeeDashboardInitial extends EmployeeDashboardState {
  const EmployeeDashboardInitial();
}

class EmployeeDashboardLoading extends EmployeeDashboardState {
  const EmployeeDashboardLoading();
}

class EmployeeDashboardSuccess extends EmployeeDashboardState {
  final EmployeeDashboardData data;

  const EmployeeDashboardSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeeDashboardError extends EmployeeDashboardState {
  final String message;

  const EmployeeDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
