part of 'admin_tickets_bloc.dart';

abstract class AdminTicketsEvent extends Equatable {
  const AdminTicketsEvent();

  @override
  List<Object?> get props => [];
}

class AdminTicketsLoadRequested extends AdminTicketsEvent {
  const AdminTicketsLoadRequested();
}

class AdminTicketsFilterChanged extends AdminTicketsEvent {
  final String filter;

  const AdminTicketsFilterChanged(this.filter);

  @override
  List<Object?> get props => [filter];
}

class AdminTicketsPriorityFilterChanged extends AdminTicketsEvent {
  final String priority;

  const AdminTicketsPriorityFilterChanged(this.priority);

  @override
  List<Object?> get props => [priority];
}

class AdminTicketsSearchQueryChanged extends AdminTicketsEvent {
  final String query;

  const AdminTicketsSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class AdminTicketsFilterIndexChanged extends AdminTicketsEvent {
  final int index;

  const AdminTicketsFilterIndexChanged(this.index);

  @override
  List<Object?> get props => [index];
}

class AdminTicketsCreateRequested extends AdminTicketsEvent {
  final Map<String, dynamic> ticketData;

  const AdminTicketsCreateRequested(this.ticketData);

  @override
  List<Object?> get props => [ticketData];
}

class AdminTicketsStatusUpdateRequested extends AdminTicketsEvent {
  final String ticketId;
  final TicketStatus status;

  const AdminTicketsStatusUpdateRequested(this.ticketId, this.status);

  @override
  List<Object?> get props => [ticketId, status];
}

class AdminTicketsAssignRequested extends AdminTicketsEvent {
  final String ticketId;
  final String employeeId;

  const AdminTicketsAssignRequested(this.ticketId, this.employeeId);

  @override
  List<Object?> get props => [ticketId, employeeId];
}

class AdminTicketsStatisticsRequested extends AdminTicketsEvent {
  const AdminTicketsStatisticsRequested();
}

class AdminTicketsPriorityUpdateRequested extends AdminTicketsEvent {
  final String ticketId;
  final TicketPriority priority;

  const AdminTicketsPriorityUpdateRequested(this.ticketId, this.priority);

  @override
  List<Object?> get props => [ticketId, priority];
}
