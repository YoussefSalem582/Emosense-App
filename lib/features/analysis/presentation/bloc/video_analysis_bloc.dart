import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/video_analysis_response.dart';
import '../../domain/repositories/video_analysis_repository.dart';

part 'video_analysis_event.dart';
part 'video_analysis_state.dart';

class VideoAnalysisBloc extends Bloc<VideoAnalysisEvent, VideoAnalysisState> {
  final VideoAnalysisRepository _repository;

  VideoAnalysisBloc(this._repository) : super(const VideoAnalysisInitial()) {
    on<VideoAnalysisFromUrlSubmitted>(_onFromUrl);
    on<VideoAnalysisFromFileSubmitted>(_onFromFile);
    on<VideoAnalysisDemoRequested>(_onDemo);
    on<VideoAnalysisReset>(_onReset);
  }

  Future<void> _onFromUrl(
    VideoAnalysisFromUrlSubmitted event,
    Emitter<VideoAnalysisState> emit,
  ) async {
    if (event.videoUrl.trim().isEmpty) {
      emit(const VideoAnalysisError('Video URL cannot be empty'));
      return;
    }

    emit(const VideoAnalysisLoading());

    try {
      await Future.delayed(const Duration(seconds: 10));

      final result = await _repository.analyzeVideo(
        videoUrl: event.videoUrl,
        frameInterval: event.frameInterval,
        maxFrames: event.maxFrames,
      );

      emit(VideoAnalysisSuccess(result));
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      emit(VideoAnalysisDemo(_createDemoResult(event.videoUrl)));
    }
  }

  Future<void> _onFromFile(
    VideoAnalysisFromFileSubmitted event,
    Emitter<VideoAnalysisState> emit,
  ) async {
    emit(const VideoAnalysisLoading());

    try {
      await Future.delayed(const Duration(seconds: 12));

      final result = await _repository.analyzeVideoFile(
        videoFile: event.videoFile,
        frameInterval: event.frameInterval,
        maxFrames: event.maxFrames,
      );

      emit(VideoAnalysisSuccess(result));
    } catch (e) {
      await Future.delayed(const Duration(seconds: 1));
      emit(VideoAnalysisDemo(_createDemoResult(event.videoFile.path)));
    }
  }

  Future<void> _onDemo(
    VideoAnalysisDemoRequested event,
    Emitter<VideoAnalysisState> emit,
  ) async {
    emit(const VideoAnalysisLoading());
    await Future.delayed(const Duration(seconds: 3));
    emit(VideoAnalysisDemo(_createDemoResult(event.videoUrl)));
  }

  void _onReset(
    VideoAnalysisReset event,
    Emitter<VideoAnalysisState> emit,
  ) {
    emit(const VideoAnalysisInitial());
  }

  VideoAnalysisResponse _createDemoResult([String? videoUrl]) {
    final demoResults = _createMultipleDemoResults();

    if (videoUrl != null) {
      if (videoUrl.contains('happy') ||
          videoUrl.contains('positive') ||
          videoUrl.contains('review1')) {
        return demoResults[0];
      } else if (videoUrl.contains('neutral') ||
          videoUrl.contains('mixed') ||
          videoUrl.contains('review2')) {
        return demoResults[1];
      }
    }

    final now = DateTime.now();
    final selectedIndex = now.second % 2;
    return demoResults[selectedIndex];
  }

  List<VideoAnalysisResponse> _createMultipleDemoResults() {
    return [
      VideoAnalysisResponse(
        framesAnalyzed: 8,
        dominantEmotion: 'Happy',
        averageConfidence: 0.92,
        summarySnapshot: SummarySnapshot(
          emotion: 'Happy',
          sentiment: 'positive',
          confidence: 0.92,
          subtitle:
              'Linus tests an all‑Logitech gaming desk and ends up impressed but not blown away: the G715 wireless TKL keyboard feels premium and feature‑rich, yet its high price and ABS keycaps keep it shy of “must‑buy” status, while the ultra‑light G Pro X Superlight mouse paired with the PowerPlay charging mat remains one of his favorite peripherals—flawless in performance, if you can stomach the cost and outdated micro‑USB port.',
          frameImageBase64: '',
          assetImagePath: 'assets/images/product_review_1.png',
          totalFramesAnalyzed: 8,
          emotionDistribution: {
            'Happy': 5,
            'Excited': 2,
            'Confident': 1,
            'Neutral': 0,
          },
        ),
      ),
      VideoAnalysisResponse(
        framesAnalyzed: 6,
        dominantEmotion: 'Neutral',
        averageConfidence: 0.84,
        summarySnapshot: SummarySnapshot(
          emotion: 'Neutral',
          sentiment: 'neutral',
          confidence: 0.84,
          subtitle:
              'Customer provides balanced feedback about the product. Shows some concerns but also highlights positive aspects. Thoughtful and analytical review approach.',
          frameImageBase64: '',
          assetImagePath: 'assets/images/product_review_2.png',
          totalFramesAnalyzed: 6,
          emotionDistribution: {
            'Neutral': 3,
            'Serious': 2,
            'Happy': 1,
            'Concerned': 0,
          },
        ),
      ),
    ];
  }
}
