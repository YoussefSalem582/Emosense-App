import 'package:emosense_mobile/features/employee/analysis_tools/data/datasources/employee_analysis_tools_local_data_source.dart';
import 'package:emosense_mobile/features/employee/analysis_tools/domain/entities/employee_analysis_tools_overview.dart';

class EmployeeAnalysisToolsLocalDataSourceImpl
    implements EmployeeAnalysisToolsLocalDataSource {
  @override
  Future<EmployeeAnalysisToolsOverview> fetchOverview() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const EmployeeAnalysisToolsOverview(
      subtitle: 'AI-powered customer insights and analytics',
      toolCount: 3,
    );
  }
}
