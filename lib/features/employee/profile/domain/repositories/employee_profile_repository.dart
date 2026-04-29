import 'package:emosense_mobile/features/employee/profile/domain/entities/employee_profile.dart';

abstract class EmployeeProfileRepository {
  Future<EmployeeProfile> fetchProfile();

  Future<EmployeeProfile> updatePreferences({
    bool? notificationsEnabled,
    bool? emailAlerts,
    String? selectedLanguage,
  });
}
