import '../../../shared/domain/entities/ticket.dart';
import '../../../shared/domain/repositories/ticket_ports.dart';
import '../../../shared/domain/repositories/ticket_repository.dart';

/// Admin-facing contract over the shared ticket persistence layer.
abstract class AdminTicketsRepository
    implements TicketListReader, TicketCreator {
  Future<Ticket?> getTicketById(String id);

  Future<Ticket> assignTicket(String ticketId, String assigneeId);

  Future<Ticket> updateTicketStatus(String ticketId, TicketStatus status);

  Future<TicketStatistics> getTicketStatistics();
}
