import 'dart:io';

import '../../domain/entities/video_analysis_response.dart';

/// Remote HTTP access for video analysis (parity with attendance remote datasource).
abstract class VideoAnalysisRemoteDataSource {
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
