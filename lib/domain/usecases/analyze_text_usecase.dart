import '../entities/analysis_result.dart';
import '../repositories/analysis_repository.dart';
import '../../core/errors/failures.dart';
import '../../core/usecases/usecase.dart';

/// Use case for text analysis
class AnalyzeTextUseCase implements UseCase<AnalysisResult, AnalyzeTextParams> {
  final AnalysisRepository repository;

  AnalyzeTextUseCase(this.repository);

  @override
  Future<Either<Failure, AnalysisResult>> call(AnalyzeTextParams params) async {
    try {
      if (params.content.trim().isEmpty) {
        return eitherLeft(ValidationFailure('Content cannot be empty'));
      }

      if (params.content.length > 5000) {
        return eitherLeft(
          ValidationFailure('Content is too long (max 5000 characters)'),
        );
      }

      final result = await repository.analyzeText(params.content);
      await repository.saveAnalysis(result);

      return eitherRight(result);
    } catch (e) {
      return eitherLeft(ServerFailure('Failed to analyze text: ${e.toString()}'));
    }
  }
}

class AnalyzeTextParams {
  final String content;

  AnalyzeTextParams({required this.content});
}
