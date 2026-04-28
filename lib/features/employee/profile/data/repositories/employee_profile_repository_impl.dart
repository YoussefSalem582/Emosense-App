import 'package:emosense_mobile/features/employee/profile/data/datasources/employee_profile_local_data_source.dart';
import 'package:emosense_mobile/features/employee/profile/domain/entities/employee_profile.dart';
import 'package:emosense_mobile/features/employee/profile/domain/repositories/employee_profile_repository.dart';

class EmployeeProfileRepositoryImpl implements EmployeeProfileRepository {
  EmployeeProfileRepositoryImpl(this._local);

  final EmployeeProfileLocalDataSource _local;

  @override
  Future<EmployeeProfile> fetchProfile() => _local.loadProfile();

  @override
  Future<EmployeeProfile> updatePreferences({
    bool? notificationsEnabled,
    bool? emailAlerts,
    String? selectedLanguage,
  }) async {
    final current = await _local.loadProfile();
    final updated = current.copyWith(
      notificationsEnabled: notificationsEnabled,
      emailAlerts: emailAlerts,
      selectedLanguage: selectedLanguage,
    );
    return _local.saveProfile(updated);
  }
}
