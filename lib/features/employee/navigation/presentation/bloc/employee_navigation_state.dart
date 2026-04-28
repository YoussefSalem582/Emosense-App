part of 'employee_navigation_bloc.dart';

abstract class EmployeeNavigationState extends Equatable {
  const EmployeeNavigationState();

  @override
  List<Object?> get props => [];
}

class EmployeeNavigationReady extends EmployeeNavigationState {
  const EmployeeNavigationReady({required this.selectedIndex});

  final int selectedIndex;

  @override
  List<Object?> get props => [selectedIndex];
}
