import 'package:emosense_mobile/features/employee/analysis_tools/domain/entities/employee_analysis_tools_overview.dart';

abstract class EmployeeAnalysisToolsRepository {
  Future<EmployeeAnalysisToolsOverview> fetchOverview();
}
