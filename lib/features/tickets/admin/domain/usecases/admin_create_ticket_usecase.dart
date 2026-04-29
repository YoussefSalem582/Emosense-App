import 'package:emosense_mobile/features/tickets/shared/domain/usecases/create_ticket_usecase.dart';

/// Creates tickets through the admin ticket repository facade.
final class AdminCreateTicketUseCase extends CreateTicketUseCase {
  AdminCreateTicketUseCase(super.creator);
}
