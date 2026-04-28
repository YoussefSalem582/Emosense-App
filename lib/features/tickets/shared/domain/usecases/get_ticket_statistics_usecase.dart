import '../../../../../core/errors/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../repositories/ticket_repository.dart';
import 'ticket_no_params.dart';

/// Use case for getting ticket statistics.
class GetTicketStatisticsUseCase
    implements UseCase<TicketStatistics, NoParams> {
  GetTicketStatisticsUseCase(this.repository);

  final TicketRepository repository;

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
