part of 'video_analysis_bloc.dart';

abstract class VideoAnalysisEvent extends Equatable {
  const VideoAnalysisEvent();

  @override
  List<Object?> get props => [];
}

class VideoAnalysisFromUrlSubmitted extends VideoAnalysisEvent {
  final String videoUrl;
  final int frameInterval;
  final int maxFrames;

  const VideoAnalysisFromUrlSubmitted({
    required this.videoUrl,
    this.frameInterval = 30,
    this.maxFrames = 5,
  });

  @override
  List<Object?> get props => [videoUrl, frameInterval, maxFrames];
}

class VideoAnalysisFromFileSubmitted extends VideoAnalysisEvent {
  final File videoFile;
  final int frameInterval;
  final int maxFrames;

  const VideoAnalysisFromFileSubmitted({
    required this.videoFile,
    this.frameInterval = 30,
    this.maxFrames = 5,
  });

  @override
  List<Object?> get props => [videoFile, frameInterval, maxFrames];
}

class VideoAnalysisDemoRequested extends VideoAnalysisEvent {
  final String? videoUrl;

  const VideoAnalysisDemoRequested([this.videoUrl]);

  @override
  List<Object?> get props => [videoUrl];
}

class VideoAnalysisReset extends VideoAnalysisEvent {
  const VideoAnalysisReset();
}
