import 'package:emosense_mobile/features/employee/dashboard/data/datasources/employee_dashboard_local_data_source.dart';
import 'package:emosense_mobile/features/employee/dashboard/domain/entities/employee_dashboard_data.dart';
import 'package:emosense_mobile/features/employee/dashboard/domain/repositories/employee_dashboard_repository.dart';

class EmployeeDashboardRepositoryImpl implements EmployeeDashboardRepository {
  EmployeeDashboardRepositoryImpl(this._local);

  final EmployeeDashboardLocalDataSource _local;

  @override
  Future<EmployeeDashboardData> fetchOverview() => _local.fetchOverview();
}
