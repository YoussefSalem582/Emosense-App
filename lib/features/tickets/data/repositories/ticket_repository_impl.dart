import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../datasources/ticket_local_data_source.dart';

/// Domain repository backed by [TicketLocalDataSource] (mock or persistent store).
class TicketRepositoryImpl implements TicketRepository {
  TicketRepositoryImpl(this._localDataSource);

  final TicketLocalDataSource _localDataSource;

  @override
  Future<List<Ticket>> getAllTickets() => _localDataSource.getAllTickets();

  @override
  Future<List<Ticket>> getTicketsByFilter(TicketFilter filter) =>
      _localDataSource.getTicketsByFilter(filter);

  @override
  Future<Ticket?> getTicketById(String id) =>
      _localDataSource.getTicketById(id);

  @override
  Future<Ticket> createTicket(Ticket ticket) =>
      _localDataSource.createTicket(ticket);

  @override
  Future<Ticket> updateTicket(Ticket ticket) =>
      _localDataSource.updateTicket(ticket);

  @override
  Future<void> deleteTicket(String id) => _localDataSource.deleteTicket(id);

  @override
  Future<Ticket> assignTicket(String ticketId, String assigneeId) =>
      _localDataSource.assignTicket(ticketId, assigneeId);

  @override
  Future<Ticket> updateTicketStatus(String ticketId, TicketStatus status) =>
      _localDataSource.updateTicketStatus(ticketId, status);

  @override
  Future<Ticket> updateTicketPriority(
    String ticketId,
    TicketPriority priority,
  ) => _localDataSource.updateTicketPriority(ticketId, priority);

  @override
  Future<List<Ticket>> getTicketsAssignedTo(String assigneeId) =>
      _localDataSource.getTicketsAssignedTo(assigneeId);

  @override
  Future<List<Ticket>> getTicketsCreatedBy(String userId) =>
      _localDataSource.getTicketsCreatedBy(userId);

  @override
  Future<List<Ticket>> searchTickets(String query) =>
      _localDataSource.searchTickets(query);

  @override
  Future<TicketStatistics> getTicketStatistics() =>
      _localDataSource.getTicketStatistics();
}
