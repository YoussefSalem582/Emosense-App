part of 'employee_tickets_bloc.dart';

abstract class EmployeeTicketsEvent extends Equatable {
  const EmployeeTicketsEvent();

  @override
  List<Object?> get props => [];
}

/// Load employee-scoped ticket list ([TicketSource.employee]) with current filters.
class EmployeeTicketsLoadRequested extends EmployeeTicketsEvent {
  const EmployeeTicketsLoadRequested();
}

class EmployeeTicketsCreateRequested extends EmployeeTicketsEvent {
  final Map<String, dynamic> ticketData;

  const EmployeeTicketsCreateRequested(this.ticketData);

  @override
  List<Object?> get props => [ticketData];
}
