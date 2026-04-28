import '../../../../../core/errors/failures.dart';

/// Domain-level ticket failure.
class TicketFailure extends Failure {
  const TicketFailure(super.message);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure(super.message);
}
