/// Persists shell tab selection for the employee navigation host (local mock; swap for prefs/API).
abstract class EmployeeNavigationRepository {
  Future<int?> readLastSelectedTab();

  Future<void> persistSelectedTab(int index);
}
