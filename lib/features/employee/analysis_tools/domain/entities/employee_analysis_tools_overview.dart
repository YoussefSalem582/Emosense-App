import 'package:equatable/equatable.dart';

/// Header metadata for the Analysis Tools tab (mock/API-backed).
class EmployeeAnalysisToolsOverview extends Equatable {
  const EmployeeAnalysisToolsOverview({
    required this.subtitle,
    required this.toolCount,
  });

  final String subtitle;
  final int toolCount;

  @override
  List<Object?> get props => [subtitle, toolCount];
}
