import '../../../shared/domain/entities/ticket.dart';
import '../../../shared/domain/repositories/ticket_repository.dart';
import '../../domain/repositories/admin_tickets_repository.dart';

/// Delegates admin operations to the shared [TicketRepository] backend.
final class AdminTicketsRepositoryImpl implements AdminTicketsRepository {
  AdminTicketsRepositoryImpl(this._ticketRepository);

  final TicketRepository _ticketRepository;

  @override
  Future<List<Ticket>> getTicketsByFilter(TicketFilter filter) =>
      _ticketRepository.getTicketsByFilter(filter);

  @override
  Future<Ticket?> getTicketById(String id) =>
      _ticketRepository.getTicketById(id);

  @override
  Future<Ticket> createTicket(Ticket ticket) =>
      _ticketRepository.createTicket(ticket);

  @override
  Future<Ticket> assignTicket(String ticketId, String assigneeId) =>
      _ticketRepository.assignTicket(ticketId, assigneeId);

  @override
  Future<Ticket> updateTicketStatus(String ticketId, TicketStatus status) =>
      _ticketRepository.updateTicketStatus(ticketId, status);

  @override
  Future<TicketStatistics> getTicketStatistics() =>
      _ticketRepository.getTicketStatistics();
}
