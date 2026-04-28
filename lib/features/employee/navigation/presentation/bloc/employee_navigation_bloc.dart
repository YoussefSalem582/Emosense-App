import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_navigation_event.dart';
part 'employee_navigation_state.dart';

/// Shell tab index state for the employee [IndexedStack] (0–8).
class EmployeeNavigationBloc
    extends Bloc<EmployeeNavigationEvent, EmployeeNavigationState> {
  EmployeeNavigationBloc()
    : super(const EmployeeNavigationReady(selectedIndex: 0)) {
    on<EmployeeNavigationTabSelected>(_onTabSelected);
  }

  void _onTabSelected(
    EmployeeNavigationTabSelected event,
    Emitter<EmployeeNavigationState> emit,
  ) {
    if (event.index < 0 || event.index > 8) return;
    emit(EmployeeNavigationReady(selectedIndex: event.index));
  }
}
