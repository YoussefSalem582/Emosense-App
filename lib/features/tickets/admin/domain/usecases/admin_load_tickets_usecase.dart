import 'package:emosense_mobile/features/tickets/shared/domain/usecases/load_tickets_usecase.dart';

/// Loads tickets using the admin ticket repository facade.
final class AdminLoadTicketsUseCase extends LoadTicketsUseCase {
  AdminLoadTicketsUseCase(super.reader);
}
