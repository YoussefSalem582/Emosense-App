import 'package:emosense_mobile/features/employee/performance/data/datasources/employee_performance_local_data_source.dart';
import 'package:emosense_mobile/features/employee/performance/domain/entities/employee_performance_data.dart';
import 'package:emosense_mobile/features/employee/performance/domain/repositories/employee_performance_repository.dart';

class EmployeePerformanceRepositoryImpl
    implements EmployeePerformanceRepository {
  EmployeePerformanceRepositoryImpl(this._local);

  final EmployeePerformanceLocalDataSource _local;

  @override
  Future<EmployeePerformanceData> fetchOverview() => _local.fetchOverview();
}
