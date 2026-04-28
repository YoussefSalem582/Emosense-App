part of 'employee_profile_bloc.dart';

abstract class EmployeeProfileEvent extends Equatable {
  const EmployeeProfileEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeProfileLoadRequested extends EmployeeProfileEvent {
  const EmployeeProfileLoadRequested();
}

class EmployeeProfileRefreshRequested extends EmployeeProfileEvent {
  const EmployeeProfileRefreshRequested();
}

class EmployeeProfileNotificationsChanged extends EmployeeProfileEvent {
  const EmployeeProfileNotificationsChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class EmployeeProfileEmailAlertsChanged extends EmployeeProfileEvent {
  const EmployeeProfileEmailAlertsChanged(this.value);

  final bool value;

  @override
  List<Object?> get props => [value];
}

class EmployeeProfileLanguageChanged extends EmployeeProfileEvent {
  const EmployeeProfileLanguageChanged(this.language);

  final String language;

  @override
  List<Object?> get props => [language];
}
