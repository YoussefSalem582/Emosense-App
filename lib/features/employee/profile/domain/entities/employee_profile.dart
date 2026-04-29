import 'package:equatable/equatable.dart';

/// Employee profile row model for the profile tab (mock/API-backed).
class EmployeeProfile extends Equatable {
  const EmployeeProfile({
    required this.name,
    required this.position,
    required this.status,
    required this.email,
    required this.phone,
    required this.department,
    required this.employeeId,
    required this.startDate,
    required this.location,
    required this.manager,
    required this.team,
    required this.notificationsEnabled,
    required this.emailAlerts,
    required this.selectedLanguage,
  });

  final String name;
  final String position;
  final String status;
  final String email;
  final String phone;
  final String department;
  final String employeeId;
  final String startDate;
  final String location;
  final String manager;
  final String team;
  final bool notificationsEnabled;
  final bool emailAlerts;
  final String selectedLanguage;

  EmployeeProfile copyWith({
    String? name,
    String? position,
    String? status,
    String? email,
    String? phone,
    String? department,
    String? employeeId,
    String? startDate,
    String? location,
    String? manager,
    String? team,
    bool? notificationsEnabled,
    bool? emailAlerts,
    String? selectedLanguage,
  }) {
    return EmployeeProfile(
      name: name ?? this.name,
      position: position ?? this.position,
      status: status ?? this.status,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      department: department ?? this.department,
      employeeId: employeeId ?? this.employeeId,
      startDate: startDate ?? this.startDate,
      location: location ?? this.location,
      manager: manager ?? this.manager,
      team: team ?? this.team,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      emailAlerts: emailAlerts ?? this.emailAlerts,
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
    );
  }

  @override
  List<Object?> get props => [
    name,
    position,
    status,
    email,
    phone,
    department,
    employeeId,
    startDate,
    location,
    manager,
    team,
    notificationsEnabled,
    emailAlerts,
    selectedLanguage,
  ];
}
