part of 'voice_analysis_bloc.dart';

abstract class VoiceAnalysisState extends Equatable {
  const VoiceAnalysisState();

  @override
  List<Object?> get props => [];
}

class VoiceAnalysisInitial extends VoiceAnalysisState {
  const VoiceAnalysisInitial();
}

class VoiceAnalysisLoading extends VoiceAnalysisState {
  const VoiceAnalysisLoading();
}

class VoiceAnalysisSuccess extends VoiceAnalysisState {
  final VoiceAnalysisResult result;

  const VoiceAnalysisSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class VoiceAnalysisError extends VoiceAnalysisState {
  final String message;

  const VoiceAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

class VoiceAnalysisDemo extends VoiceAnalysisState {
  final VoiceAnalysisResult demoResult;

  const VoiceAnalysisDemo(this.demoResult);

  @override
  List<Object?> get props => [demoResult];
}
