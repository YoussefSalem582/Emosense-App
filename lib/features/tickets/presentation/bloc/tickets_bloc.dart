import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/entities/ticket.dart';
import '../../domain/repositories/ticket_repository.dart';
import '../../domain/usecases/ticket_usecases.dart';

part 'tickets_event.dart';
part 'tickets_state.dart';

class TicketsBloc extends Bloc<TicketsEvent, TicketsState> {
  final LoadTicketsUseCase _loadTicketsUseCase;
  final CreateTicketUseCase _createTicketUseCase;
  final UpdateTicketStatusUseCase _updateTicketStatusUseCase;
  final AssignTicketUseCase _assignTicketUseCase;
  final GetTicketStatisticsUseCase _getTicketStatisticsUseCase;

  TicketsBloc({
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
       super(const TicketsInitial()) {
    on<TicketsLoadAllRequested>(_onLoadAll);
    on<TicketsLoadEmployeeRequested>(_onLoadEmployee);
    on<TicketsFilterChanged>(_onFilterChanged);
    on<TicketsPriorityFilterChanged>(_onPriorityFilterChanged);
    on<TicketsSearchQueryChanged>(_onSearchQueryChanged);
    on<TicketsFilterIndexChanged>(_onFilterIndexChanged);
    on<TicketsCreateRequested>(_onCreate);
    on<TicketsStatusUpdateRequested>(_onStatusUpdate);
    on<TicketsAssignRequested>(_onAssign);
    on<TicketsStatisticsRequested>(_onStatistics);
    on<TicketsPriorityUpdateRequested>(_onPriorityUpdate);
  }

  TicketFilter _currentFilter = TicketFilter.empty();
  final TicketSortBy _currentSortBy = TicketSortBy.createdDate;
  bool _isAdminView = false;
  int _selectedFilterIndex = 0;

  String get selectedFilter =>
      _currentFilter.status?.displayName ?? 'all';
  String get selectedPriority =>
      _currentFilter.priority?.displayName ?? 'all';
  String get searchQuery => _currentFilter.searchQuery;
  int get selectedFilterIndex => _selectedFilterIndex;

  Future<void> _onLoadAll(
    TicketsLoadAllRequested event,
    Emitter<TicketsState> emit,
  ) =>
      _loadAllTickets(emit, isAdminView: event.isAdminView);

  Future<void> _onLoadEmployee(
    TicketsLoadEmployeeRequested event,
    Emitter<TicketsState> emit,
  ) =>
      _loadAllTickets(emit, isAdminView: false);

  Future<void> _onFilterChanged(
    TicketsFilterChanged event,
    Emitter<TicketsState> emit,
  ) async {
    final status =
        event.filter == 'all' ? null : TicketStatus.fromString(event.filter);
    _currentFilter = _currentFilter.copyWith(status: status);
    await _loadAllTickets(emit, isAdminView: event.isAdminView);
  }

  Future<void> _onPriorityFilterChanged(
    TicketsPriorityFilterChanged event,
    Emitter<TicketsState> emit,
  ) async {
    final priorityEnum =
        event.priority == 'all'
            ? null
            : TicketPriority.fromString(event.priority);
    _currentFilter = _currentFilter.copyWith(priority: priorityEnum);
    await _loadAllTickets(emit, isAdminView: event.isAdminView);
  }

  Future<void> _onSearchQueryChanged(
    TicketsSearchQueryChanged event,
    Emitter<TicketsState> emit,
  ) async {
    _currentFilter = _currentFilter.copyWith(searchQuery: event.query);
    await _loadAllTickets(emit, isAdminView: event.isAdminView);
  }

  Future<void> _onFilterIndexChanged(
    TicketsFilterIndexChanged event,
    Emitter<TicketsState> emit,
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
    await _loadAllTickets(emit, isAdminView: event.isAdminView);
  }

  Future<void> _onCreate(
    TicketsCreateRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());
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
        (failure) => emit(TicketsError(failure.message)),
        (_) => _loadAllTickets(emit, isAdminView: _isAdminView),
      );
    } catch (e) {
      emit(TicketsError('Failed to create ticket: $e'));
    }
  }

  Future<void> _onStatusUpdate(
    TicketsStatusUpdateRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());
    try {
      final result = await _updateTicketStatusUseCase(
        UpdateTicketStatusParams(
          ticketId: event.ticketId,
          newStatus: event.status,
        ),
      );

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (_) => _loadAllTickets(emit, isAdminView: _isAdminView),
      );
    } catch (e) {
      emit(TicketsError('Failed to update ticket status: $e'));
    }
  }

  Future<void> _onAssign(
    TicketsAssignRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());
    try {
      final result = await _assignTicketUseCase(
        AssignTicketParams(
          ticketId: event.ticketId,
          assigneeId: event.employeeId,
        ),
      );

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (_) => _loadAllTickets(emit, isAdminView: _isAdminView),
      );
    } catch (e) {
      emit(TicketsError('Failed to assign ticket: $e'));
    }
  }

  Future<void> _onStatistics(
    TicketsStatisticsRequested event,
    Emitter<TicketsState> emit,
  ) async {
    try {
      final result = await _getTicketStatisticsUseCase(const NoParams());

      result.fold(
        (failure) => emit(TicketsError(failure.message)),
        (statistics) {
          if (event.isAdminView) {
            _emitAdminStatistics(emit, statistics);
          } else {
            _emitEmployeeStatistics(emit, statistics);
          }
        },
      );
    } catch (e) {
      emit(TicketsError('Failed to load statistics: $e'));
    }
  }

  Future<void> _onPriorityUpdate(
    TicketsPriorityUpdateRequested event,
    Emitter<TicketsState> emit,
  ) async {
    emit(const TicketsLoading());
    try {
      await _loadAllTickets(emit, isAdminView: _isAdminView);
    } catch (e) {
      emit(TicketsError('Failed to update ticket priority: $e'));
    }
  }

  Future<void> _loadAllTickets(
    Emitter<TicketsState> emit, {
    required bool isAdminView,
  }) async {
    _isAdminView = isAdminView;
    emit(const TicketsLoading());

    try {
      final filter =
          isAdminView
              ? _currentFilter
              : _currentFilter.copyWith(source: TicketSource.employee);

      final params = LoadTicketsParams(filter: filter, sortBy: _currentSortBy);

      final result = await _loadTicketsUseCase(params);

      result.fold((failure) => emit(TicketsError(failure.message)), (tickets) {
        if (isAdminView) {
          _emitAdminSuccess(emit, tickets);
        } else {
          _emitEmployeeSuccess(emit, tickets);
        }
      });
    } catch (e) {
      emit(TicketsError('Failed to load tickets: $e'));
    }
  }

  void _emitAdminSuccess(Emitter<TicketsState> emit, List<Ticket> tickets) {
    final allTickets = tickets.map((ticket) => ticket.toMap()).toList();
    final filteredTickets = _filterTickets(allTickets);

    final data = AdminTicketsData(
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

    emit(TicketsSuccess.admin(data));
  }

  void _emitEmployeeSuccess(Emitter<TicketsState> emit, List<Ticket> tickets) {
    final allTickets = tickets.map((ticket) => ticket.toMap()).toList();

    final data = EmployeeTicketsData(
      assignedTickets: allTickets,
      recentTickets: allTickets.take(5).toList(),
      myTicketsCount: allTickets.length,
      pendingCount: allTickets.where((t) => t['status'] == 'Open').length,
      inProgressCount:
          allTickets.where((t) => t['status'] == 'In Progress').length,
      completedCount: allTickets.where((t) => t['status'] == 'Resolved').length,
    );

    emit(TicketsSuccess.employee(data));
  }

  void _emitAdminStatistics(
    Emitter<TicketsState> emit,
    TicketStatistics statistics,
  ) {
    final data = AdminTicketsData(
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

    emit(TicketsSuccess.admin(data));
  }

  void _emitEmployeeStatistics(
    Emitter<TicketsState> emit,
    TicketStatistics statistics,
  ) {
    final data = EmployeeTicketsData(
      assignedTickets: [],
      recentTickets: [],
      myTicketsCount: statistics.totalCount,
      pendingCount: statistics.openCount,
      inProgressCount: statistics.inProgressCount,
      completedCount: statistics.resolvedCount,
    );

    emit(TicketsSuccess.employee(data));
  }

  List<Map<String, dynamic>> _filterTickets(
    List<Map<String, dynamic>> tickets,
  ) {
    var filtered = tickets;

    if (_currentFilter.status != null) {
      filtered =
          filtered
              .where(
                (ticket) =>
                    ticket['status'] == _currentFilter.status!.displayName,
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
                ticket['description']?.toString().toLowerCase().contains(
                      query,
                    ) ==
                    true ||
                ticket['customer']?.toString().toLowerCase().contains(query) ==
                    true ||
                ticket['id']?.toString().toLowerCase().contains(query) == true;
          }).toList();
    }

    return filtered;
  }
}
