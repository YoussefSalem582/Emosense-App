import '../entities/voice_analysis_result.dart';

abstract class VoiceAnalysisRepository {
  Future<VoiceAnalysisResult> analyzeVoice({
    required String filePath,
    required String analysisType,
  });

  Future<VoiceAnalysisResult> analyzeVoiceDemo({
    required String analysisType,
  });
}
