abstract class EmployeeNavigationLocalDataSource {
  Future<int?> readLastSelectedTab();

  Future<void> persistSelectedTab(int index);
}
