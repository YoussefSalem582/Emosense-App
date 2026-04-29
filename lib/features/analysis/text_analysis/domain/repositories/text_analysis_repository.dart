import '../entities/text_analysis_result.dart';

/// Text analysis persistence / API abstraction.
abstract class TextAnalysisRepository {
  Future<TextAnalysisResult> analyzeText({
    required String text,
    required String analysisType,
  });

  TextAnalysisResult buildDemoResult(String analysisType);
}
