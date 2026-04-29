import 'dart:io';

import '../../domain/entities/video_analysis_response.dart';
import '../../domain/repositories/video_analysis_repository.dart';
import '../datasources/video_analysis_remote_data_source.dart';

class VideoAnalysisRepositoryImpl implements VideoAnalysisRepository {
  VideoAnalysisRepositoryImpl(this._remoteDataSource);

  final VideoAnalysisRemoteDataSource _remoteDataSource;

  @override
  Future<VideoAnalysisResponse> analyzeVideo({
    required String videoUrl,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    try {
      return await _remoteDataSource.analyzeVideo(
        videoUrl: videoUrl,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );
    } catch (e) {
      throw Exception('Failed to analyze video: ${e.toString()}');
    }
  }

  @override
  Future<VideoAnalysisResponse> analyzeVideoFile({
    required File videoFile,
    int frameInterval = 30,
    int maxFrames = 5,
  }) async {
    try {
      return await _remoteDataSource.analyzeVideoFile(
        videoFile: videoFile,
        frameInterval: frameInterval,
        maxFrames: maxFrames,
      );
    } catch (e) {
      throw Exception('Failed to analyze video file: ${e.toString()}');
    }
  }

  @override
  Future<bool> checkConnection() => _remoteDataSource.checkConnection();

  @override
  Future<Map<String, dynamic>> getConnectionDetails() =>
      _remoteDataSource.getConnectionDetails();
}
