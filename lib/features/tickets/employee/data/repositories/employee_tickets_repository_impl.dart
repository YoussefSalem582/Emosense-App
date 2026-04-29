import '../../../shared/domain/entities/ticket.dart';
import '../../../shared/domain/repositories/ticket_repository.dart';
import '../../domain/repositories/employee_tickets_repository.dart';

/// Delegates employee operations to the shared [TicketRepository] backend.
final class EmployeeTicketsRepositoryImpl implements EmployeeTicketsRepository {
  EmployeeTicketsRepositoryImpl(this._ticketRepository);

  final TicketRepository _ticketRepository;

  @override
  Future<List<Ticket>> getTicketsByFilter(TicketFilter filter) =>
      _ticketRepository.getTicketsByFilter(filter);

  @override
  Future<Ticket> createTicket(Ticket ticket) =>
      _ticketRepository.createTicket(ticket);
}
