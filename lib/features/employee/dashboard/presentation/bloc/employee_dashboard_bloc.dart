import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_dashboard_event.dart';
part 'employee_dashboard_state.dart';

class EmployeeDashboardBloc
    extends Bloc<EmployeeDashboardEvent, EmployeeDashboardState> {
  EmployeeDashboardBloc() : super(const EmployeeDashboardInitial()) {
    on<EmployeeDashboardLoadRequested>(_onLoad);
    on<EmployeeDashboardRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    EmployeeDashboardLoadRequested event,
    Emitter<EmployeeDashboardState> emit,
  ) async {
    await _loadDashboard(emit);
  }

  Future<void> _onRefresh(
    EmployeeDashboardRefreshRequested event,
    Emitter<EmployeeDashboardState> emit,
  ) async {
    await _loadDashboard(emit);
  }

  Future<void> _loadDashboard(Emitter<EmployeeDashboardState> emit) async {
    emit(const EmployeeDashboardLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 500));

      emit(
        EmployeeDashboardSuccess(
          EmployeeDashboardData(
            ticketsResolved: 42,
            activeTickets: 8,
            customerSatisfaction: 4.8,
            efficiencyScore: 94,
            recentTickets: _recentTickets(),
            quickStats: _quickStats(),
          ),
        ),
      );
    } catch (e) {
      emit(EmployeeDashboardError(e.toString()));
    }
  }

  List<Map<String, dynamic>> _recentTickets() {
    return [
      {
        'id': '#TK-001',
        'title': 'Product Quality Issue',
        'customer': 'Sarah Johnson',
        'priority': 'High',
        'status': 'Open',
        'time': '2 hours ago',
      },
      {
        'id': '#TK-002',
        'title': 'Shipping Delay',
        'customer': 'Mike Chen',
        'priority': 'Medium',
        'status': 'In Progress',
        'time': '4 hours ago',
      },
      {
        'id': '#TK-003',
        'title': 'Account Access',
        'customer': 'Emily Davis',
        'priority': 'Low',
        'status': 'Resolved',
        'time': '1 day ago',
      },
    ];
  }

  List<Map<String, dynamic>> _quickStats() {
    return [
      {
        'title': 'Today\'s Tickets',
        'value': '15',
        'trend': '+3 from yesterday',
        'isPositive': true,
      },
      {
        'title': 'Avg Resolution Time',
        'value': '2.1h',
        'trend': '-0.3h improvement',
        'isPositive': true,
      },
      {
        'title': 'Customer Rating',
        'value': '4.8/5',
        'trend': '+0.2 vs last week',
        'isPositive': true,
      },
    ];
  }
}
