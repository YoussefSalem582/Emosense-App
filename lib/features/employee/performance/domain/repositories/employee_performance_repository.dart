import 'package:emosense_mobile/features/employee/performance/domain/entities/employee_performance_data.dart';

abstract class EmployeePerformanceRepository {
  Future<EmployeePerformanceData> fetchOverview();
}
