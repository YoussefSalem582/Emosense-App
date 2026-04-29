import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/usecases/usecase.dart';
import '../../../shared/domain/entities/ticket.dart';
import '../../../shared/domain/usecases/create_ticket_usecase.dart';
import '../../../shared/domain/usecases/load_tickets_usecase.dart';
import '../../domain/usecases/employee_create_ticket_usecase.dart';
import '../../domain/usecases/employee_load_tickets_usecase.dart';
import '../../../shared/presentation/models/ticket_ui_models.dart';

part 'employee_tickets_event.dart';
part 'employee_tickets_state.dart';

/// Manages ticket lists for employee screens (filters to [TicketSource.employee]).
class EmployeeTicketsBloc
    extends Bloc<EmployeeTicketsEvent, EmployeeTicketsState> {
  EmployeeTicketsBloc({
    required EmployeeLoadTicketsUseCase loadTicketsUseCase,
    required EmployeeCreateTicketUseCase createTicketUseCase,
  }) : _loadTicketsUseCase = loadTicketsUseCase,
       _createTicketUseCase = createTicketUseCase,
       super(const EmployeeTicketsInitial()) {
    on<EmployeeTicketsLoadRequested>(_onLoad);
    on<EmployeeTicketsCreateRequested>(_onCreate);
  }

  final EmployeeLoadTicketsUseCase _loadTicketsUseCase;
  final EmployeeCreateTicketUseCase _createTicketUseCase;

  Future<void> _onLoad(
    EmployeeTicketsLoadRequested event,
    Emitter<EmployeeTicketsState> emit,
  ) => _loadTickets(emit);

  Future<void> _onCreate(
    EmployeeTicketsCreateRequested event,
    Emitter<EmployeeTicketsState> emit,
  ) async {
    emit(const EmployeeTicketsLoading());
    try {
      final data = event.ticketData;
      final ticket = Ticket(
        id: '',
        title: data['title'] ?? '',
        description: data['description'] ?? '',
        status: TicketStatus.open,
        priority: TicketPriority.fromString(data['priority'] ?? 'Medium'),
        source: TicketSource.employee,
        customerName: data['customer'] ?? data['customerName'] ?? '',
        category: data['category'] ?? 'General',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        referenceUrl: data['referenceUrl'],
      );

      final result = await _createTicketUseCase(
        CreateTicketParams(ticket: ticket),
      );

      result.fold(
        (failure) => emit(EmployeeTicketsError(failure.message)),
        (_) => _loadTickets(emit),
      );
    } catch (e) {
      emit(EmployeeTicketsError('Failed to create ticket: $e'));
    }
  }

  Future<void> _loadTickets(Emitter<EmployeeTicketsState> emit) async {
    emit(const EmployeeTicketsLoading());

    try {
      final filter = TicketFilter.empty().copyWith(
        source: TicketSource.employee,
      );
      final params = LoadTicketsParams(
        filter: filter,
        sortBy: TicketSortBy.createdDate,
      );

      final result = await _loadTicketsUseCase(params);

      result.fold((failure) => emit(EmployeeTicketsError(failure.message)), (
        tickets,
      ) {
        emit(EmployeeTicketsSuccess(_buildEmployeeData(tickets)));
      });
    } catch (e) {
      emit(EmployeeTicketsError('Failed to load tickets: $e'));
    }
  }

  EmployeeTicketsData _buildEmployeeData(List<Ticket> tickets) {
    final allTickets = tickets.map((ticket) => ticket.toMap()).toList();

    return EmployeeTicketsData(
      assignedTickets: allTickets,
      recentTickets: allTickets.take(5).toList(),
      myTicketsCount: allTickets.length,
      pendingCount: allTickets.where((t) => t['status'] == 'Open').length,
      inProgressCount:
          allTickets.where((t) => t['status'] == 'In Progress').length,
      completedCount: allTickets.where((t) => t['status'] == 'Resolved').length,
    );
  }
}
