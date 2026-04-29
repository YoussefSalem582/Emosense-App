part of 'employee_dashboard_bloc.dart';

abstract class EmployeeDashboardEvent extends Equatable {
  const EmployeeDashboardEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeDashboardLoadRequested extends EmployeeDashboardEvent {
  const EmployeeDashboardLoadRequested();
}

class EmployeeDashboardRefreshRequested extends EmployeeDashboardEvent {
  const EmployeeDashboardRefreshRequested();
}
