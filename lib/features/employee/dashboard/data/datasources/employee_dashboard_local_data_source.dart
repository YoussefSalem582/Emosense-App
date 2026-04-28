import 'package:emosense_mobile/features/employee/dashboard/domain/entities/employee_dashboard_data.dart';

abstract class EmployeeDashboardLocalDataSource {
  Future<EmployeeDashboardData> fetchOverview();
}
