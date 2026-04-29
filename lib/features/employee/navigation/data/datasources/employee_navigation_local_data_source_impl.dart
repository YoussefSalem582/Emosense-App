import 'package:emosense_mobile/features/employee/navigation/data/datasources/employee_navigation_local_data_source.dart';

class EmployeeNavigationLocalDataSourceImpl
    implements EmployeeNavigationLocalDataSource {
  int? _lastTabIndex;

  @override
  Future<int?> readLastSelectedTab() async => _lastTabIndex;

  @override
  Future<void> persistSelectedTab(int index) async {
    _lastTabIndex = index;
  }
}
