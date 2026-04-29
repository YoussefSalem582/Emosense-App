part of 'voice_analysis_bloc.dart';

abstract class VoiceAnalysisEvent extends Equatable {
  const VoiceAnalysisEvent();

  @override
  List<Object?> get props => [];
}

class VoiceAnalysisAnalyzeRequested extends VoiceAnalysisEvent {
  final String filePath;
  final String analysisType;

  const VoiceAnalysisAnalyzeRequested({
    required this.filePath,
    required this.analysisType,
  });

  @override
  List<Object?> get props => [filePath, analysisType];
}

class VoiceAnalysisDemoRequested extends VoiceAnalysisEvent {
  final String analysisType;

  const VoiceAnalysisDemoRequested(this.analysisType);

  @override
  List<Object?> get props => [analysisType];
}

class VoiceAnalysisReset extends VoiceAnalysisEvent {
  const VoiceAnalysisReset();
}
