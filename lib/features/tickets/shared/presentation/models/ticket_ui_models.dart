import 'package:equatable/equatable.dart';

/// Aggregated ticket list view data for admin UIs (maps from domain).
class AdminTicketsData extends Equatable {
  final List<Map<String, dynamic>> allTickets;
  final List<Map<String, dynamic>> filteredTickets;
  final int totalCount;
  final int openCount;
  final int inProgressCount;
  final int resolvedCount;
  final int closedCount;
  final int highPriorityCount;
  final int mediumPriorityCount;
  final int lowPriorityCount;
  final int criticalCount;
  final List<Map<String, dynamic>> recentTickets;

  const AdminTicketsData({
    required this.allTickets,
    required this.filteredTickets,
    required this.totalCount,
    required this.openCount,
    required this.inProgressCount,
    required this.resolvedCount,
    required this.closedCount,
    required this.highPriorityCount,
    required this.mediumPriorityCount,
    required this.lowPriorityCount,
    required this.criticalCount,
    required this.recentTickets,
  });

  @override
  List<Object?> get props => [
    allTickets,
    filteredTickets,
    totalCount,
    openCount,
    inProgressCount,
    resolvedCount,
    closedCount,
    highPriorityCount,
    mediumPriorityCount,
    lowPriorityCount,
    criticalCount,
    recentTickets,
  ];
}

/// Aggregated ticket list view data for employee UIs (maps from domain).
class EmployeeTicketsData extends Equatable {
  final List<Map<String, dynamic>> assignedTickets;
  final List<Map<String, dynamic>> recentTickets;
  final int myTicketsCount;
  final int pendingCount;
  final int inProgressCount;
  final int completedCount;

  const EmployeeTicketsData({
    required this.assignedTickets,
    required this.recentTickets,
    required this.myTicketsCount,
    required this.pendingCount,
    required this.inProgressCount,
    required this.completedCount,
  });

  @override
  List<Object?> get props => [
    assignedTickets,
    recentTickets,
    myTicketsCount,
    pendingCount,
    inProgressCount,
    completedCount,
  ];
}
