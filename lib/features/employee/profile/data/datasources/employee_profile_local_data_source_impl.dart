import 'package:emosense_mobile/features/employee/profile/data/datasources/employee_profile_local_data_source.dart';
import 'package:emosense_mobile/features/employee/profile/domain/entities/employee_profile.dart';

class EmployeeProfileLocalDataSourceImpl
    implements EmployeeProfileLocalDataSource {
  EmployeeProfile _profile = _seed;

  static const EmployeeProfile _seed = EmployeeProfile(
    name: 'Youssef Hassan',
    position: 'Customer Service Representative',
    status: 'Active',
    email: 'youssef.hassan@company.com',
    phone: '+20 1026855881',
    department: 'Customer Support',
    employeeId: '211000582',
    startDate: 'January 15, 2025',
    location: 'Giza',
    manager: 'Dr Walaa',
    team: 'Customer Experience',
    notificationsEnabled: true,
    emailAlerts: false,
    selectedLanguage: 'English',
  );

  @override
  Future<EmployeeProfile> loadProfile() async {
    await Future.delayed(const Duration(milliseconds: 350));
    return _profile;
  }

  @override
  Future<EmployeeProfile> saveProfile(EmployeeProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _profile = profile;
    return _profile;
  }
}
