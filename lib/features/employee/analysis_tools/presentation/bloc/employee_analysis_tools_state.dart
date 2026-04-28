part of 'employee_analysis_tools_bloc.dart';

abstract class EmployeeAnalysisToolsState extends Equatable {
  const EmployeeAnalysisToolsState();

  @override
  List<Object?> get props => [];
}

class EmployeeAnalysisToolsInitial extends EmployeeAnalysisToolsState {
  const EmployeeAnalysisToolsInitial();
}

class EmployeeAnalysisToolsLoading extends EmployeeAnalysisToolsState {
  const EmployeeAnalysisToolsLoading();
}

class EmployeeAnalysisToolsSuccess extends EmployeeAnalysisToolsState {
  const EmployeeAnalysisToolsSuccess(this.data);

  final EmployeeAnalysisToolsData data;

  @override
  List<Object?> get props => [data];
}

class EmployeeAnalysisToolsError extends EmployeeAnalysisToolsState {
  const EmployeeAnalysisToolsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class EmployeeAnalysisToolsData extends Equatable {
  const EmployeeAnalysisToolsData({
    required this.toolCount,
    required this.subtitle,
  });

  final int toolCount;
  final String subtitle;

  @override
  List<Object?> get props => [toolCount, subtitle];
}
