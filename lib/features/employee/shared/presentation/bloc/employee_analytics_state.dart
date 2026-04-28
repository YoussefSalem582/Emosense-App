part of 'employee_analytics_bloc.dart';

abstract class EmployeeAnalyticsState extends Equatable {
  const EmployeeAnalyticsState();

  @override
  List<Object?> get props => [];
}

class EmployeeAnalyticsInitial extends EmployeeAnalyticsState {
  const EmployeeAnalyticsInitial();
}

class EmployeeAnalyticsLoading extends EmployeeAnalyticsState {
  const EmployeeAnalyticsLoading();
}

class EmployeeAnalyticsSuccess extends EmployeeAnalyticsState {
  final EmployeeAnalyticsData data;

  const EmployeeAnalyticsSuccess(this.data);

  @override
  List<Object?> get props => [data];
}

class EmployeeAnalyticsError extends EmployeeAnalyticsState {
  final String message;

  const EmployeeAnalyticsError(this.message);

  @override
  List<Object?> get props => [message];
}
