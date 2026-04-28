import 'package:emosense_mobile/core/errors/failures.dart';
import 'package:emosense_mobile/core/usecases/usecase.dart';
import 'package:emosense_mobile/features/tickets/shared/domain/entities/ticket.dart';
import 'package:emosense_mobile/features/tickets/shared/domain/usecases/ticket_failures.dart';

import '../repositories/admin_tickets_repository.dart';

/// Use case for assigning tickets (admin flow).
class AssignTicketUseCase implements UseCase<Ticket, AssignTicketParams> {
  AssignTicketUseCase(this.repository);

  final AdminTicketsRepository repository;

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
