import '../entities/ticket.dart';

/// Narrow port for loading ticket lists (used by [LoadTicketsUseCase]).
abstract class TicketListReader {
  Future<List<Ticket>> getTicketsByFilter(TicketFilter filter);
}

/// Narrow port for creating tickets (used by [CreateTicketUseCase]).
abstract class TicketCreator {
  Future<Ticket> createTicket(Ticket ticket);
}
