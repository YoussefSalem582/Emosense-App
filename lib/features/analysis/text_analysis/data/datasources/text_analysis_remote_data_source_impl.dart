import 'package:emosense_mobile/core/services/emotion_api_service.dart';
import 'package:emosense_mobile/core/services/models/emotion_result.dart';

import 'text_analysis_remote_data_source.dart';

class TextAnalysisRemoteDataSourceImpl implements TextAnalysisRemoteDataSource {
  TextAnalysisRemoteDataSourceImpl(this._emotionApiService);

  final EmotionApiService _emotionApiService;

  @override
  Future<EmotionResult> predictEmotion(String text) =>
      _emotionApiService.predictEmotion(text);
}
