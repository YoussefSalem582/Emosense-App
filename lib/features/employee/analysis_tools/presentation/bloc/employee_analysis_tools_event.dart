part of 'employee_analysis_tools_bloc.dart';

abstract class EmployeeAnalysisToolsEvent extends Equatable {
  const EmployeeAnalysisToolsEvent();

  @override
  List<Object?> get props => [];
}

class EmployeeAnalysisToolsLoadRequested extends EmployeeAnalysisToolsEvent {
  const EmployeeAnalysisToolsLoadRequested();
}

class EmployeeAnalysisToolsRefreshRequested extends EmployeeAnalysisToolsEvent {
  const EmployeeAnalysisToolsRefreshRequested();
}
