part of 'employee_analytics_bloc.dart';

abstract class EmployeeAnalyticsEvent extends Equatable {
  const EmployeeAnalyticsEvent();

  @override
  List<Object?> get props => [];
}

/// Loads analytics; [timeRange] updates the selection when non-null.
class EmployeeAnalyticsFetched extends EmployeeAnalyticsEvent {
  final String? timeRange;

  const EmployeeAnalyticsFetched({this.timeRange});

  @override
  List<Object?> get props => [timeRange];
}

class EmployeeAnalyticsRefreshRequested extends EmployeeAnalyticsEvent {
  const EmployeeAnalyticsRefreshRequested();
}
