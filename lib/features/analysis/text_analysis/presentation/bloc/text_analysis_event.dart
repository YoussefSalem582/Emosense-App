part of 'text_analysis_bloc.dart';

abstract class TextAnalysisEvent extends Equatable {
  const TextAnalysisEvent();

  @override
  List<Object?> get props => [];
}

class TextAnalysisAnalyzeRequested extends TextAnalysisEvent {
  final String text;
  final String analysisType;

  const TextAnalysisAnalyzeRequested({
    required this.text,
    required this.analysisType,
  });

  @override
  List<Object?> get props => [text, analysisType];
}

class TextAnalysisDemoRequested extends TextAnalysisEvent {
  final String analysisType;

  const TextAnalysisDemoRequested(this.analysisType);

  @override
  List<Object?> get props => [analysisType];
}

class TextAnalysisReset extends TextAnalysisEvent {
  const TextAnalysisReset();
}
