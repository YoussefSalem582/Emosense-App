import 'package:equatable/equatable.dart';

/// Aggregated analytics metrics for shared analytics sections (mock/API-backed).
class EmployeeAnalyticsData extends Equatable {
  const EmployeeAnalyticsData({
    required this.timeRange,
    required this.metrics,
    required this.performanceData,
    required this.ticketTypes,
    required this.priorityDistribution,
    required this.resolutionSpeed,
    required this.goals,
  });

  final String timeRange;
  final List<Map<String, dynamic>> metrics;
  final Map<String, dynamic> performanceData;
  final List<Map<String, dynamic>> ticketTypes;
  final Map<String, dynamic> priorityDistribution;
  final List<Map<String, dynamic>> resolutionSpeed;
  final List<Map<String, dynamic>> goals;

  @override
  List<Object?> get props => [
    timeRange,
    metrics,
    performanceData,
    ticketTypes,
    priorityDistribution,
    resolutionSpeed,
    goals,
  ];
}
