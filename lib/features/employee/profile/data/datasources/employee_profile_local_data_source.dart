import 'package:emosense_mobile/features/employee/profile/domain/entities/employee_profile.dart';

abstract class EmployeeProfileLocalDataSource {
  Future<EmployeeProfile> loadProfile();

  Future<EmployeeProfile> saveProfile(EmployeeProfile profile);
}
