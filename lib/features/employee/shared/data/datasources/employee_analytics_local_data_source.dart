import 'package:emosense_mobile/features/employee/shared/domain/entities/employee_analytics_data.dart';

abstract class EmployeeAnalyticsLocalDataSource {
  Future<EmployeeAnalyticsData> fetchOverview({required String timeRange});
}
