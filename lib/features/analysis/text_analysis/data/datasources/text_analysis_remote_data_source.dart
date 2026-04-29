import 'package:emosense_mobile/core/services/models/emotion_result.dart';

/// Remote / API layer for emotion prediction backing text analysis.
abstract class TextAnalysisRemoteDataSource {
  Future<EmotionResult> predictEmotion(String text);
}
