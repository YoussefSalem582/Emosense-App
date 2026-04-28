import 'package:equatable/equatable.dart';

/// Performance summary for the employee performance tab (mock/API-backed).
class EmployeePerformanceData extends Equatable {
  const EmployeePerformanceData({
    required this.overallScore,
    required this.ranking,
    required this.totalEmployees,
    required this.monthlyProgress,
    required this.keyMetrics,
    required this.performanceBreakdown,
    required this.achievements,
    required this.weeklyTrends,
    required this.goals,
  });

  final int overallScore;
  final int ranking;
  final int totalEmployees;
  final double monthlyProgress;
  final List<Map<String, dynamic>> keyMetrics;
  final Map<String, dynamic> performanceBreakdown;
  final List<Map<String, dynamic>> achievements;
  final List<Map<String, dynamic>> weeklyTrends;
  final List<Map<String, dynamic>> goals;

  @override
  List<Object?> get props => [
    overallScore,
    ranking,
    totalEmployees,
    monthlyProgress,
    keyMetrics,
    performanceBreakdown,
    achievements,
    weeklyTrends,
    goals,
  ];
}
