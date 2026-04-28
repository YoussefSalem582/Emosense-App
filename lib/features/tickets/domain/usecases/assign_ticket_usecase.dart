import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';
import 'ticket_failures.dart';

/// Use case for assigning tickets.
class AssignTicketUseCase implements UseCase<Ticket, AssignTicketParams> {
  AssignTicketUseCase(this.repository);

  final TicketRepository repository;

  @override
  Future<Either<Failure, Ticket>> call(AssignTicketParams params) async {
    try {
      final updatedTicket = await repository.assignTicket(
        params.ticketId,
        params.assigneeId,
      );
      return eitherRight(updatedTicket);
    } catch (e) {
      return eitherLeft(TicketFailure(e.toString()));
    }
  }
}

class AssignTicketParams {
  const AssignTicketParams({required this.ticketId, required this.assigneeId});

  final String ticketId;
  final String assigneeId;
}
