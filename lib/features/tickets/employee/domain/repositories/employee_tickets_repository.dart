import '../../../shared/domain/repositories/ticket_ports.dart';

/// Employee-facing contract over the shared ticket persistence layer.
abstract class EmployeeTicketsRepository implements TicketListReader, TicketCreator {}
