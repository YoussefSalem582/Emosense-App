import 'package:emosense_mobile/features/employee/analysis_tools/data/datasources/employee_analysis_tools_local_data_source.dart';
import 'package:emosense_mobile/features/employee/analysis_tools/domain/entities/employee_analysis_tools_overview.dart';
import 'package:emosense_mobile/features/employee/analysis_tools/domain/repositories/employee_analysis_tools_repository.dart';

class EmployeeAnalysisToolsRepositoryImpl
    implements EmployeeAnalysisToolsRepository {
  EmployeeAnalysisToolsRepositoryImpl(this._local);

  final EmployeeAnalysisToolsLocalDataSource _local;

  @override
  Future<EmployeeAnalysisToolsOverview> fetchOverview() =>
      _local.fetchOverview();
}
