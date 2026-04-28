import '../../../../core/errors/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/ticket_repository.dart';
import 'ticket_failures.dart';

/// Use case for updating ticket status.
class UpdateTicketStatusUseCase
    implements UseCase<Ticket, UpdateTicketStatusParams> {
  UpdateTicketStatusUseCase(this.repository);

  final TicketRepository repository;

  @override
  Future<Either<Failure, Ticket>> call(UpdateTicketStatusParams params) async {
    try {
      final currentTicket = await repository.getTicketById(params.ticketId);
      if (currentTicket == null) {
        return eitherLeft(const NotFoundFailure('Ticket not found'));
      }

      final validationResult = _validateStatusTransition(
        currentTicket.status,
        params.newStatus,
      );
      if (validationResult != null) {
        return eitherLeft(ValidationFailure(validationResult));
      }

      final updatedTicket = await repository.updateTicketStatus(
        params.ticketId,
        params.newStatus,
      );

      return eitherRight(updatedTicket);
    } catch (e) {
      return eitherLeft(TicketFailure(e.toString()));
    }
  }

  String? _validateStatusTransition(TicketStatus from, TicketStatus to) {
    if (from == TicketStatus.closed && to != TicketStatus.open) {
      return 'Closed tickets can only be reopened';
    }
    if (from == TicketStatus.resolved && to == TicketStatus.open) {
      return 'Resolved tickets cannot be directly reopened. Contact admin.';
    }
    return null;
  }
}

class UpdateTicketStatusParams {
  const UpdateTicketStatusParams({
    required this.ticketId,
    required this.newStatus,
  });

  final String ticketId;
  final TicketStatus newStatus;
}
