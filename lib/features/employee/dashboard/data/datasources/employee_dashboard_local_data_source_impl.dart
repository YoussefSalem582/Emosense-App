import 'package:emosense_mobile/features/employee/dashboard/data/datasources/employee_dashboard_local_data_source.dart';
import 'package:emosense_mobile/features/employee/dashboard/domain/entities/employee_dashboard_data.dart';

class EmployeeDashboardLocalDataSourceImpl
    implements EmployeeDashboardLocalDataSource {
  @override
  Future<EmployeeDashboardData> fetchOverview() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return EmployeeDashboardData(
      ticketsResolved: 42,
      activeTickets: 8,
      customerSatisfaction: 4.8,
      efficiencyScore: 94,
      recentTickets: _recentTickets(),
      quickStats: _quickStats(),
    );
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
