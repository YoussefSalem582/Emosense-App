import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'employee_analysis_tools_event.dart';
part 'employee_analysis_tools_state.dart';

/// Presentation state for the employee Analysis Tools tab (routes + counts until wired to backend).
class EmployeeAnalysisToolsBloc
    extends Bloc<EmployeeAnalysisToolsEvent, EmployeeAnalysisToolsState> {
  EmployeeAnalysisToolsBloc() : super(const EmployeeAnalysisToolsInitial()) {
    on<EmployeeAnalysisToolsLoadRequested>(_onLoad);
    on<EmployeeAnalysisToolsRefreshRequested>(_onRefresh);
  }

  Future<void> _onLoad(
    EmployeeAnalysisToolsLoadRequested event,
    Emitter<EmployeeAnalysisToolsState> emit,
  ) async {
    emit(const EmployeeAnalysisToolsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 350));
      emit(
        const EmployeeAnalysisToolsSuccess(
          EmployeeAnalysisToolsData(
            toolCount: 3,
            subtitle: 'AI-powered customer insights and analytics',
          ),
        ),
      );
    } catch (e) {
      emit(EmployeeAnalysisToolsError(e.toString()));
    }
  }

  Future<void> _onRefresh(
    EmployeeAnalysisToolsRefreshRequested event,
    Emitter<EmployeeAnalysisToolsState> emit,
  ) async {
    emit(const EmployeeAnalysisToolsLoading());
    try {
      await Future.delayed(const Duration(milliseconds: 250));
      emit(
        const EmployeeAnalysisToolsSuccess(
          EmployeeAnalysisToolsData(
            toolCount: 3,
            subtitle: 'AI-powered customer insights and analytics',
          ),
        ),
      );
    } catch (e) {
      emit(EmployeeAnalysisToolsError(e.toString()));
    }
  }
}
