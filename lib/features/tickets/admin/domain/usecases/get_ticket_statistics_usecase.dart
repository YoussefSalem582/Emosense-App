import 'package:emosense_mobile/core/errors/failures.dart';
import 'package:emosense_mobile/core/usecases/usecase.dart';
import 'package:emosense_mobile/features/tickets/shared/domain/repositories/ticket_repository.dart';
import 'package:emosense_mobile/features/tickets/shared/domain/usecases/ticket_no_params.dart';

import '../repositories/admin_tickets_repository.dart';

/// Use case for getting ticket statistics (admin flow).
class GetTicketStatisticsUseCase
    implements UseCase<TicketStatistics, NoParams> {
  GetTicketStatisticsUseCase(this.repository);

  final AdminTicketsRepository repository;

  @override
  Future<Either<Failure, TicketStatistics>> call(NoParams params) async {
    try {
      final statistics = await repository.getTicketStatistics();
      return eitherRight(statistics);
    } catch (e) {
      return eitherLeft(ServerFailure(e.toString()));
    }
  }
}
