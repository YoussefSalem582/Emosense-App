part of 'text_analysis_bloc.dart';

abstract class TextAnalysisState extends Equatable {
  const TextAnalysisState();

  @override
  List<Object?> get props => [];
}

class TextAnalysisInitial extends TextAnalysisState {
  const TextAnalysisInitial();
}

class TextAnalysisLoading extends TextAnalysisState {
  const TextAnalysisLoading();
}

class TextAnalysisSuccess extends TextAnalysisState {
  final TextAnalysisResult result;

  const TextAnalysisSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class TextAnalysisError extends TextAnalysisState {
  final String message;

  const TextAnalysisError(this.message);

  @override
  List<Object?> get props => [message];
}

class TextAnalysisDemo extends TextAnalysisState {
  final TextAnalysisResult demoResult;

  const TextAnalysisDemo(this.demoResult);

  @override
  List<Object?> get props => [demoResult];
}
