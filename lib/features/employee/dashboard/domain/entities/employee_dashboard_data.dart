import 'package:equatable/equatable.dart';

/// Snapshot for the employee dashboard tab (mock/API-backed via repository).
class EmployeeDashboardData extends Equatable {
  const EmployeeDashboardData({
    required this.ticketsResolved,
    required this.activeTickets,
    required this.customerSatisfaction,
    required this.efficiencyScore,
    required this.recentTickets,
    required this.quickStats,
  });

  final int ticketsResolved;
  final int activeTickets;
  final double customerSatisfaction;
  final int efficiencyScore;
  final List<Map<String, dynamic>> recentTickets;
  final List<Map<String, dynamic>> quickStats;

  @override
  List<Object?> get props => [
    ticketsResolved,
    activeTickets,
    customerSatisfaction,
    efficiencyScore,
    recentTickets,
    quickStats,
  ];
}
