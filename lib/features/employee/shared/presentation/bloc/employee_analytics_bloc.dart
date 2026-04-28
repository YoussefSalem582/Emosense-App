import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_analytics_event.dart';
part 'employee_analytics_state.dart';

class EmployeeAnalyticsBloc
    extends Bloc<EmployeeAnalyticsEvent, EmployeeAnalyticsState> {
  String _timeRange = 'This Week';

  EmployeeAnalyticsBloc() : super(const EmployeeAnalyticsInitial()) {
    on<EmployeeAnalyticsFetched>(_onFetched);
    on<EmployeeAnalyticsRefreshRequested>(_onRefresh);
  }

  Future<void> _onFetched(
    EmployeeAnalyticsFetched event,
    Emitter<EmployeeAnalyticsState> emit,
  ) async {
    if (event.timeRange != null) {
      _timeRange = event.timeRange!;
    }
    await _fetch(emit);
  }

  Future<void> _onRefresh(
    EmployeeAnalyticsRefreshRequested event,
    Emitter<EmployeeAnalyticsState> emit,
  ) async {
    await _fetch(emit);
  }

  Future<void> _fetch(Emitter<EmployeeAnalyticsState> emit) async {
    emit(const EmployeeAnalyticsLoading());

    try {
      await Future.delayed(const Duration(milliseconds: 800));

      emit(
        EmployeeAnalyticsSuccess(
          EmployeeAnalyticsData(
            timeRange: _timeRange,
            metrics: _metricsForTimeRange(),
            performanceData: _performanceData(),
            ticketTypes: _ticketTypes(),
            priorityDistribution: _priorityDistribution(),
            resolutionSpeed: _resolutionSpeed(),
            goals: _goals(),
          ),
        ),
      );
    } catch (e) {
      emit(EmployeeAnalyticsError(e.toString()));
    }
  }

  List<Map<String, dynamic>> _metricsForTimeRange() {
    return [
      {
        'title': 'Ticket Volume',
        'value': _timeRange == 'Today' ? '18' : '89',
        'unit': _timeRange == 'Today' ? 'today' : 'this week',
        'trend':
            _timeRange == 'Today' ? '+15% vs yesterday' : '+8% vs last week',
        'isPositiveTrend': true,
      },
      {
        'title': 'Resolution Rate',
        'value': _timeRange == 'Today' ? '96%' : '94%',
        'unit': 'success',
        'trend':
            _timeRange == 'Today' ? '+2% vs yesterday' : '+5% vs last week',
        'isPositiveTrend': true,
      },
      {
        'title': 'Customer Satisfaction',
        'value': '4.8/5',
        'unit': 'rating',
        'trend': '+0.2 vs last period',
        'isPositiveTrend': true,
      },
      {
        'title': 'Tickets Handled',
        'value': _timeRange == 'Today' ? '15' : '78',
        'unit': _timeRange == 'Today' ? 'today' : 'this week',
        'trend': _timeRange == 'Today' ? 'Target: 20' : 'Target: 80',
        'isPositiveTrend': _timeRange == 'Today' ? false : true,
      },
      {
        'title': 'First Resolution',
        'value': '87%',
        'unit': 'resolved',
        'trend': '+3% improvement',
        'isPositiveTrend': true,
      },
      {
        'title': 'Customer Escalations',
        'value': '2',
        'unit': _timeRange == 'Today' ? 'today' : 'this week',
        'trend': '-50% vs last period',
        'isPositiveTrend': true,
      },
    ];
  }

  Map<String, dynamic> _performanceData() {
    return {
      'bestDay': 'Wednesday',
      'bestDayImprovement': '+12%',
      'peakHour': '2-3 PM',
      'peakHourTickets': '23 tickets',
      'avgResolution': '2.1h',
      'avgResolutionUnit': 'per ticket',
    };
  }

  List<Map<String, dynamic>> _ticketTypes() {
    return [
      {'label': 'Product Issues', 'percentage': 0.45},
      {'label': 'Shipping', 'percentage': 0.25},
      {'label': 'Account', 'percentage': 0.20},
      {'label': 'Other', 'percentage': 0.10},
    ];
  }

  Map<String, dynamic> _priorityDistribution() {
    return {'high': 32, 'medium': 48, 'low': 20};
  }

  List<Map<String, dynamic>> _resolutionSpeed() {
    return [
      {'timeRange': 'Same Day', 'percentage': '45%'},
      {'timeRange': '1-2 Days', 'percentage': '35%'},
      {'timeRange': '3-5 Days', 'percentage': '15%'},
      {'timeRange': '> 5 Days', 'percentage': '5%'},
    ];
  }

  List<Map<String, dynamic>> _goals() {
    return [
      {
        'title': 'Ticket Efficiency',
        'progress': 0.87,
        'target': '> 85%',
        'current': '87% current',
      },
      {
        'title': 'Resolution Rate',
        'progress': 0.94,
        'target': '> 90%',
        'current': '94% current',
      },
      {
        'title': 'Customer Satisfaction',
        'progress': 0.96,
        'target': '> 4.5/5',
        'current': '4.8/5 current',
      },
      {
        'title': 'Daily Tickets',
        'progress': 0.75,
        'target': '20 tickets',
        'current': '15 completed today',
      },
    ];
  }
}
