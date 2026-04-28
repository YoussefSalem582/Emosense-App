import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/ticket.dart';
import '../repositories/ticket_ports.dart';
import 'ticket_failures.dart';

/// Use case for creating a ticket.
class CreateTicketUseCase implements UseCase<Ticket, CreateTicketParams> {
  CreateTicketUseCase(this.creator);

  final TicketCreator creator;

  @override
  Future<Either<Failure, Ticket>> call(CreateTicketParams params) async {
    try {
      final validationResult = _validateTicket(params.ticket);
      if (validationResult != null) {
        return eitherLeft(ValidationFailure(validationResult));
      }

      final ticket = params.ticket.copyWith(
        id: _generateTicketId(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      final createdTicket = await creator.createTicket(ticket);
      return eitherRight(createdTicket);
    } catch (e) {
      return eitherLeft(TicketFailure(e.toString()));
    }
  }

  String? _validateTicket(Ticket ticket) {
    if (ticket.title.trim().isEmpty) {
      return 'Ticket title cannot be empty';
    }
    if (ticket.description.trim().isEmpty) {
      return 'Ticket description cannot be empty';
    }
    if (ticket.customerName.trim().isEmpty) {
      return 'Customer name cannot be empty';
    }
    return null;
  }

  String _generateTicketId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'TK-${timestamp.toString().substring(8)}';
  }
}

class CreateTicketParams {
  const CreateTicketParams({required this.ticket});

  final Ticket ticket;
}
