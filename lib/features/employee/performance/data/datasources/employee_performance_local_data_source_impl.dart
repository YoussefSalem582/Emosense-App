import 'package:emosense_mobile/features/employee/performance/data/datasources/employee_performance_local_data_source.dart';
import 'package:emosense_mobile/features/employee/performance/domain/entities/employee_performance_data.dart';

class EmployeePerformanceLocalDataSourceImpl
    implements EmployeePerformanceLocalDataSource {
  @override
  Future<EmployeePerformanceData> fetchOverview() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return EmployeePerformanceData(
      overallScore: 94,
      ranking: 3,
      totalEmployees: 25,
      monthlyProgress: 0.87,
      keyMetrics: _keyMetrics(),
      performanceBreakdown: _performanceBreakdown(),
      achievements: _achievements(),
      weeklyTrends: _weeklyTrends(),
      goals: _goals(),
    );
  }

  List<Map<String, dynamic>> _keyMetrics() {
    return [
      {
        'title': 'Tickets Resolved',
        'value': '156',
        'unit': 'this month',
        'trend': '+12% vs last month',
        'isPositive': true,
      },
      {
        'title': 'Avg Resolution Time',
        'value': '2.1h',
        'unit': 'per ticket',
        'trend': '-0.3h improvement',
        'isPositive': true,
      },
      {
        'title': 'Customer Satisfaction',
        'value': '4.8/5',
        'unit': 'rating',
        'trend': '+0.2 vs last month',
        'isPositive': true,
      },
      {
        'title': 'First Contact Resolution',
        'value': '87%',
        'unit': 'success rate',
        'trend': '+5% improvement',
        'isPositive': true,
      },
      {
        'title': 'Escalation Rate',
        'value': '3%',
        'unit': 'of total tickets',
        'trend': '-2% improvement',
        'isPositive': true,
      },
      {
        'title': 'Team Collaboration',
        'value': '92%',
        'unit': 'score',
        'trend': '+4% vs last month',
        'isPositive': true,
      },
    ];
  }

  Map<String, dynamic> _performanceBreakdown() {
    return {
      'ticketResolution': 0.94,
      'customerSatisfaction': 0.96,
      'efficiency': 0.89,
      'teamwork': 0.92,
      'communication': 0.91,
    };
  }

  List<Map<String, dynamic>> _achievements() {
    return [
      {
        'title': 'Customer Champion',
        'description': '50+ tickets with 5-star ratings',
        'date': '2024-12-15',
        'icon': 'star',
      },
      {
        'title': 'Speed Demon',
        'description': 'Fastest average resolution time',
        'date': '2024-12-10',
        'icon': 'speed',
      },
      {
        'title': 'Team Player',
        'description': 'Helped 10+ colleagues this month',
        'date': '2024-12-05',
        'icon': 'group',
      },
    ];
  }

  List<Map<String, dynamic>> _weeklyTrends() {
    return [
      {'day': 'Mon', 'tickets': 18, 'satisfaction': 4.7},
      {'day': 'Tue', 'tickets': 22, 'satisfaction': 4.8},
      {'day': 'Wed', 'tickets': 25, 'satisfaction': 4.9},
      {'day': 'Thu', 'tickets': 20, 'satisfaction': 4.8},
      {'day': 'Fri', 'tickets': 19, 'satisfaction': 4.7},
      {'day': 'Sat', 'tickets': 15, 'satisfaction': 4.8},
      {'day': 'Sun', 'tickets': 12, 'satisfaction': 4.9},
    ];
  }

  List<Map<String, dynamic>> _goals() {
    return [
      {
        'title': 'Monthly Resolution Target',
        'target': 180,
        'current': 156,
        'progress': 0.87,
        'unit': 'tickets',
      },
      {
        'title': 'Customer Satisfaction Goal',
        'target': 4.5,
        'current': 4.8,
        'progress': 1.0,
        'unit': '/5 rating',
      },
      {
        'title': 'Efficiency Improvement',
        'target': 0.9,
        'current': 0.89,
        'progress': 0.99,
        'unit': 'score',
      },
    ];
  }
}
