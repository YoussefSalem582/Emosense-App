part of 'tickets_bloc.dart';

abstract class TicketsState extends Equatable {
  const TicketsState();

  @override
  List<Object?> get props => [];
}

class TicketsInitial extends TicketsState {
  const TicketsInitial();
}

class TicketsLoading extends TicketsState {
  const TicketsLoading();
}

class TicketsSuccess extends TicketsState {
  final bool isAdminView;
  final AdminTicketsData? adminData;
  final EmployeeTicketsData? employeeData;

  const TicketsSuccess.admin(this.adminData)
    : isAdminView = true,
      employeeData = null;

  const TicketsSuccess.employee(this.employeeData)
    : isAdminView = false,
      adminData = null;

  @override
  List<Object?> get props => [isAdminView, adminData, employeeData];
}

class TicketsError extends TicketsState {
  final String message;

  const TicketsError(this.message);

  @override
  List<Object?> get props => [message];
}

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
