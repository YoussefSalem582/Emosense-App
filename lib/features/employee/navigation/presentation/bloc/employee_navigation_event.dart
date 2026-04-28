part of 'employee_navigation_bloc.dart';

abstract class EmployeeNavigationEvent extends Equatable {
  const EmployeeNavigationEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeNavigationTabSelected extends EmployeeNavigationEvent {
  const EmployeeNavigationTabSelected(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}
