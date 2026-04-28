part of 'tickets_bloc.dart';

abstract class TicketsEvent extends Equatable {
  const TicketsEvent();

  @override
  List<Object?> get props => [];
}

class TicketsLoadAllRequested extends TicketsEvent {
  final bool isAdminView;

  const TicketsLoadAllRequested({this.isAdminView = true});

  @override
  List<Object?> get props => [isAdminView];
}

class TicketsLoadEmployeeRequested extends TicketsEvent {
  const TicketsLoadEmployeeRequested();
}

class TicketsFilterChanged extends TicketsEvent {
  final String filter;
  final bool isAdminView;

  const TicketsFilterChanged(this.filter, {this.isAdminView = true});

  @override
  List<Object?> get props => [filter, isAdminView];
}

class TicketsPriorityFilterChanged extends TicketsEvent {
  final String priority;
  final bool isAdminView;

  const TicketsPriorityFilterChanged(this.priority, {this.isAdminView = true});

  @override
  List<Object?> get props => [priority, isAdminView];
}

class TicketsSearchQueryChanged extends TicketsEvent {
  final String query;
  final bool isAdminView;

  const TicketsSearchQueryChanged(this.query, {this.isAdminView = true});

  @override
  List<Object?> get props => [query, isAdminView];
}

class TicketsFilterIndexChanged extends TicketsEvent {
  final int index;
  final bool isAdminView;

  const TicketsFilterIndexChanged(this.index, {this.isAdminView = true});

  @override
  List<Object?> get props => [index, isAdminView];
}

class TicketsCreateRequested extends TicketsEvent {
  final Map<String, dynamic> ticketData;

  const TicketsCreateRequested(this.ticketData);

  @override
  List<Object?> get props => [ticketData];
}

class TicketsStatusUpdateRequested extends TicketsEvent {
  final String ticketId;
  final TicketStatus status;

  const TicketsStatusUpdateRequested(this.ticketId, this.status);

  @override
  List<Object?> get props => [ticketId, status];
}

class TicketsAssignRequested extends TicketsEvent {
  final String ticketId;
  final String employeeId;

  const TicketsAssignRequested(this.ticketId, this.employeeId);

  @override
  List<Object?> get props => [ticketId, employeeId];
}

class TicketsStatisticsRequested extends TicketsEvent {
  final bool isAdminView;

  const TicketsStatisticsRequested({this.isAdminView = true});

  @override
  List<Object?> get props => [isAdminView];
}

class TicketsPriorityUpdateRequested extends TicketsEvent {
  final String ticketId;
  final TicketPriority priority;

  const TicketsPriorityUpdateRequested(this.ticketId, this.priority);

  @override
  List<Object?> get props => [ticketId, priority];
}
