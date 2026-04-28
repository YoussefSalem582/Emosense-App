import 'package:emosense_mobile/features/employee/shared/data/datasources/employee_analytics_local_data_source.dart';
import 'package:emosense_mobile/features/employee/shared/domain/entities/employee_analytics_data.dart';
import 'package:emosense_mobile/features/employee/shared/domain/repositories/employee_analytics_repository.dart';

class EmployeeAnalyticsRepositoryImpl implements EmployeeAnalyticsRepository {
  EmployeeAnalyticsRepositoryImpl(this._local);

  final EmployeeAnalyticsLocalDataSource _local;

  @override
  Future<EmployeeAnalyticsData> fetchOverview({required String timeRange}) =>
      _local.fetchOverview(timeRange: timeRange);
}
