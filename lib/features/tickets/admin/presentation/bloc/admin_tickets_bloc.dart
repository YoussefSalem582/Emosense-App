import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/usecases/usecase.dart';
import '../../../shared/domain/entities/ticket.dart';
import '../../../shared/domain/repositories/ticket_repository.dart';
import '../../../shared/domain/usecases/assign_ticket_usecase.dart';
import '../../../shared/domain/usecases/create_ticket_usecase.dart';
import '../../../shared/domain/usecases/get_ticket_statistics_usecase.dart';
import '../../../shared/domain/usecases/load_tickets_usecase.dart';
import '../../../shared/domain/usecases/ticket_no_params.dart';
import '../../../shared/domain/usecases/update_ticket_status_usecase.dart';
import '../../../shared/presentation/models/ticket_ui_models.dart';

part 'admin_tickets_event.dart';
part 'admin_tickets_state.dart';

/// Manages ticket list CRUD/filtering for admin screens.
class AdminTicketsBloc extends Bloc<AdminTicketsEvent, AdminTicketsState> {
  AdminTicketsBloc({
    required LoadTicketsUseCase loadTicketsUseCase,
    required CreateTicketUseCase createTicketUseCase,
    required UpdateTicketStatusUseCase updateTicketStatusUseCase,
    required AssignTicketUseCase assignTicketUseCase,
    required GetTicketStatisticsUseCase getTicketStatisticsUseCase,
  }) : _loadTicketsUseCase = loadTicketsUseCase,
       _createTicketUseCase = createTicketUseCase,
       _updateTicketStatusUseCase = updateTicketStatusUseCase,
       _assignTicketUseCase = assignTicketUseCase,
       _getTicketStatisticsUseCase = getTicketStatisticsUseCase,
       super(const AdminTicketsInitial()) {
    on<AdminTicketsLoadRequested>(_onLoad);
    on<AdminTicketsFilterChanged>(_onFilterChanged);
    on<AdminTicketsPriorityFilterChanged>(_onPriorityFilterChanged);
    on<AdminTicketsSearchQueryChanged>(_onSearchQueryChanged);
    on<AdminTicketsFilterIndexChanged>(_onFilterIndexChanged);
    on<AdminTicketsCreateRequested>(_onCreate);
    on<AdminTicketsStatusUpdateRequested>(_onStatusUpdate);
    on<AdminTicketsAssignRequested>(_onAssign);
    on<AdminTicketsStatisticsRequested>(_onStatistics);
    on<AdminTicketsPriorityUpdateRequested>(_onPriorityUpdate);
  }

  final LoadTicketsUseCase _loadTicketsUseCase;
  final CreateTicketUseCase _createTicketUseCase;
  final UpdateTicketStatusUseCase _updateTicketStatusUseCase;
  final AssignTicketUseCase _assignTicketUseCase;
  final GetTicketStatisticsUseCase _getTicketStatisticsUseCase;

  TicketFilter _currentFilter = TicketFilter.empty();
  final TicketSortBy _currentSortBy = TicketSortBy.createdDate;
  int _selectedFilterIndex = 0;

  String get selectedFilter =>
      _currentFilter.status?.displayName ?? 'all';
  String get selectedPriority =>
      _currentFilter.priority?.displayName ?? 'all';
  String get searchQuery => _currentFilter.searchQuery;
  int get selectedFilterIndex => _selectedFilterIndex;

  Future<void> _onLoad(
    AdminTicketsLoadRequested event,
    Emitter<AdminTicketsState> emit,
  ) =>
      _loadAllTickets(emit);

  Future<void> _onFilterChanged(
    AdminTicketsFilterChanged event,
    Emitter<AdminTicketsState> emit,
  ) async {
    final status =
        event.filter == 'all'
            ? null
            : TicketStatus.fromString(event.filter);
    _currentFilter = _currentFilter.copyWith(status: status);
    await _loadAllTickets(emit);
  }

  Future<void> _onPriorityFilterChanged(
    AdminTicketsPriorityFilterChanged event,
    Emitter<AdminTicketsState> emit,
  ) async {
    final priorityEnum =
        event.priority == 'all'
            ? null
            : TicketPriority.fromString(event.priority);
    _currentFilter = _currentFilter.copyWith(priority: priorityEnum);
    await _loadAllTickets(emit);
  }

  Future<void> _onSearchQueryChanged(
    AdminTicketsSearchQueryChanged event,
    Emitter<AdminTicketsState> emit,
  ) async {
    _currentFilter = _currentFilter.copyWith(searchQuery: event.query);
    await _loadAllTickets(emit);
  }

  Future<void> _onFilterIndexChanged(
    AdminTicketsFilterIndexChanged event,
    Emitter<AdminTicketsState> emit,
  ) async {
    _selectedFilterIndex = event.index;
    String filterName;
    switch (event.index) {
      case 0:
        filterName = 'all';
        break;
      case 1:
        filterName = 'open';
        break;
      case 2:
        filterName = 'in_progress';
        break;
      case 3:
        filterName = 'resolved';
        break;
      case 4:
        filterName = 'closed';
        break;
      default:
        filterName = 'all';
    }
    final status =
        filterName == 'all' ? null : TicketStatus.fromString(filterName);
    _currentFilter = _currentFilter.copyWith(status: status);
    await _loadAllTickets(emit);
  }

  Future<void> _onCreate(
    AdminTicketsCreateRequested event,
    Emitter<AdminTicketsState> emit,
  ) async {
    emit(const AdminTicketsLoading());
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
        (failure) => emit(AdminTicketsError(failure.message)),
        (_) => _loadAllTickets(emit),
      );
    } catch (e) {
      emit(AdminTicketsError('Failed to create ticket: $e'));
    }
  }

  Future<void> _onStatusUpdate(
    AdminTicketsStatusUpdateRequested event,
    Emitter<AdminTicketsState> emit,
  ) async {
    emit(const AdminTicketsLoading());
    try {
      final result = await _updateTicketStatusUseCase(
        UpdateTicketStatusParams(
          ticketId: event.ticketId,
          newStatus: event.status,
        ),
      );

      result.fold(
        (failure) => emit(AdminTicketsError(failure.message)),
        (_) => _loadAllTickets(emit),
      );
    } catch (e) {
      emit(AdminTicketsError('Failed to update ticket status: $e'));
    }
  }

  Future<void> _onAssign(
    AdminTicketsAssignRequested event,
    Emitter<AdminTicketsState> emit,
  ) async {
    emit(const AdminTicketsLoading());
    try {
      final result = await _assignTicketUseCase(
        AssignTicketParams(
          ticketId: event.ticketId,
          assigneeId: event.employeeId,
        ),
      );

      result.fold(
        (failure) => emit(AdminTicketsError(failure.message)),
        (_) => _loadAllTickets(emit),
      );
    } catch (e) {
      emit(AdminTicketsError('Failed to assign ticket: $e'));
    }
  }

  Future<void> _onStatistics(
    AdminTicketsStatisticsRequested event,
    Emitter<AdminTicketsState> emit,
  ) async {
    try {
      final result = await _getTicketStatisticsUseCase(const NoParams());

      result.fold(
        (failure) => emit(AdminTicketsError(failure.message)),
        (statistics) =>
            emit(AdminTicketsSuccess(_buildAdminStatisticsData(statistics))),
      );
    } catch (e) {
      emit(AdminTicketsError('Failed to load statistics: $e'));
    }
  }

  Future<void> _onPriorityUpdate(
    AdminTicketsPriorityUpdateRequested event,
    Emitter<AdminTicketsState> emit,
  ) async {
    emit(const AdminTicketsLoading());
    try {
      await _loadAllTickets(emit);
    } catch (e) {
      emit(AdminTicketsError('Failed to update ticket priority: $e'));
    }
  }

  Future<void> _loadAllTickets(Emitter<AdminTicketsState> emit) async {
    emit(const AdminTicketsLoading());

    try {
      final params =
          LoadTicketsParams(filter: _currentFilter, sortBy: _currentSortBy);

      final result = await _loadTicketsUseCase(params);

      result.fold(
        (failure) => emit(AdminTicketsError(failure.message)),
        (tickets) {
          emit(AdminTicketsSuccess(_buildLoadedTicketsData(tickets)));
        },
      );
    } catch (e) {
      emit(AdminTicketsError('Failed to load tickets: $e'));
    }
  }

  AdminTicketsData _buildLoadedTicketsData(List<Ticket> tickets) {
    final allTickets = tickets.map((ticket) => ticket.toMap()).toList();
    final filteredTickets = _filterTickets(allTickets);

    return AdminTicketsData(
      allTickets: allTickets,
      filteredTickets: filteredTickets,
      totalCount: allTickets.length,
      openCount: allTickets.where((t) => t['status'] == 'Open').length,
      inProgressCount:
          allTickets.where((t) => t['status'] == 'In Progress').length,
      resolvedCount: allTickets.where((t) => t['status'] == 'Resolved').length,
      closedCount: allTickets.where((t) => t['status'] == 'Closed').length,
      highPriorityCount:
          allTickets.where((t) => t['priority'] == 'High').length,
      mediumPriorityCount:
          allTickets.where((t) => t['priority'] == 'Medium').length,
      lowPriorityCount: allTickets.where((t) => t['priority'] == 'Low').length,
      criticalCount:
          allTickets.where((t) => t['priority'] == 'Critical').length,
      recentTickets: allTickets.take(5).toList(),
    );
  }

  AdminTicketsData _buildAdminStatisticsData(TicketStatistics statistics) =>
      AdminTicketsData(
        allTickets: [],
        filteredTickets: [],
        totalCount: statistics.totalCount,
        openCount: statistics.openCount,
        inProgressCount: statistics.inProgressCount,
        resolvedCount: statistics.resolvedCount,
        closedCount: statistics.closedCount,
        highPriorityCount: statistics.highPriorityCount,
        mediumPriorityCount: 0,
        lowPriorityCount: 0,
        criticalCount: statistics.criticalPriorityCount,
        recentTickets: [],
      );

  List<Map<String, dynamic>> _filterTickets(
    List<Map<String, dynamic>> tickets,
  ) {
    var filtered = tickets;

    if (_currentFilter.status != null) {
      filtered =
          filtered
              .where(
                (ticket) =>
                    ticket['status'] ==
                    _currentFilter.status!.displayName,
              )
              .toList();
    }

    if (_currentFilter.priority != null) {
      filtered =
          filtered
              .where(
                (ticket) =>
                    ticket['priority'] ==
                    _currentFilter.priority!.displayName,
              )
              .toList();
    }

    if (_currentFilter.searchQuery.isNotEmpty) {
      filtered =
          filtered.where((ticket) {
            final query = _currentFilter.searchQuery.toLowerCase();
            return ticket['title']?.toString().toLowerCase().contains(query) ==
                    true ||
                ticket['description']
                        ?.toString()
                        .toLowerCase()
                        .contains(query) ==
                    true ||
                ticket['customer']
                        ?.toString()
                        .toLowerCase()
                        .contains(query) ==
                    true ||
                ticket['id']?.toString().toLowerCase().contains(query) ==
                    true;
          }).toList();
    }

    return filtered;
  }
}
