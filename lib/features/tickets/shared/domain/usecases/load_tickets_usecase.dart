import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/ticket_ports.dart';
import 'ticket_failures.dart';

/// Use case for loading tickets with filtering.
class LoadTicketsUseCase implements UseCase<List<Ticket>, LoadTicketsParams> {
  LoadTicketsUseCase(this.reader);

  final TicketListReader reader;

  @override
  Future<Either<Failure, List<Ticket>>> call(LoadTicketsParams params) async {
    try {
      final tickets = await reader.getTicketsByFilter(params.filter);

      final sortedTickets = _sortTickets(tickets, params.sortBy);
      final paginatedTickets = _paginateTickets(
        sortedTickets,
        params.page,
        params.pageSize,
      );

      return eitherRight(paginatedTickets);
    } catch (e) {
      return eitherLeft(TicketFailure(e.toString()));
    }
  }

  List<Ticket> _sortTickets(List<Ticket> tickets, TicketSortBy sortBy) {
    switch (sortBy) {
      case TicketSortBy.createdDate:
        return tickets..sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case TicketSortBy.updatedDate:
        return tickets..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
      case TicketSortBy.priority:
        return tickets
          ..sort((a, b) => b.priority.index.compareTo(a.priority.index));
      case TicketSortBy.status:
        return tickets
          ..sort((a, b) => a.status.index.compareTo(b.status.index));
      case TicketSortBy.title:
        return tickets..sort((a, b) => a.title.compareTo(b.title));
    }
  }

  List<Ticket> _paginateTickets(List<Ticket> tickets, int page, int pageSize) {
    final startIndex = page * pageSize;
    if (startIndex >= tickets.length) return [];
    final endIndex = (startIndex + pageSize).clamp(0, tickets.length);
    return tickets.sublist(startIndex, endIndex);
  }
}

class LoadTicketsParams {
  const LoadTicketsParams({
    required this.filter,
    this.sortBy = TicketSortBy.createdDate,
    this.page = 0,
    this.pageSize = 20,
  });

  final TicketFilter filter;
  final TicketSortBy sortBy;
  final int page;
  final int pageSize;
}

enum TicketSortBy { createdDate, updatedDate, priority, status, title }
