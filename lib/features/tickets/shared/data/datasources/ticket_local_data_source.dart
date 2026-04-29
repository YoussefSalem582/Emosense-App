import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';

/// Local / in-memory persistence for tickets (mock cache or Hive/SQL later).
abstract class TicketLocalDataSource {
  Future<List<Ticket>> getAllTickets();

  Future<List<Ticket>> getTicketsByFilter(TicketFilter filter);

  Future<Ticket?> getTicketById(String id);

  Future<Ticket> createTicket(Ticket ticket);

  Future<Ticket> updateTicket(Ticket ticket);

  Future<void> deleteTicket(String id);

  Future<Ticket> assignTicket(String ticketId, String assigneeId);

  Future<Ticket> updateTicketStatus(String ticketId, TicketStatus status);

  Future<Ticket> updateTicketPriority(String ticketId, TicketPriority priority);

  Future<List<Ticket>> getTicketsAssignedTo(String assigneeId);

  Future<List<Ticket>> getTicketsCreatedBy(String userId);

  Future<List<Ticket>> searchTickets(String query);

  Future<TicketStatistics> getTicketStatistics();
}
