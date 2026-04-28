import 'dart:io';

import '../entities/video_analysis_response.dart';

abstract class VideoAnalysisRepository {
  Future<VideoAnalysisResponse> analyzeVideo({
    required String videoUrl,
    int frameInterval = 30,
    int maxFrames = 5,
  });

  Future<VideoAnalysisResponse> analyzeVideoFile({
    required File videoFile,
    int frameInterval = 30,
    int maxFrames = 5,
  });

  Future<bool> checkConnection();

  Future<Map<String, dynamic>> getConnectionDetails();
}
