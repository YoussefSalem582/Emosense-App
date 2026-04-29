import 'package:emosense_mobile/features/employee/navigation/data/datasources/employee_navigation_local_data_source.dart';
import 'package:emosense_mobile/features/employee/navigation/domain/repositories/employee_navigation_repository.dart';

class EmployeeNavigationRepositoryImpl implements EmployeeNavigationRepository {
  EmployeeNavigationRepositoryImpl(this._local);

  final EmployeeNavigationLocalDataSource _local;

  @override
  Future<int?> readLastSelectedTab() => _local.readLastSelectedTab();

  @override
  Future<void> persistSelectedTab(int index) =>
      _local.persistSelectedTab(index);
}
