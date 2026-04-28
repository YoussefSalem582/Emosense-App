import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/text_analysis_result.dart';
import '../../domain/repositories/text_analysis_repository.dart';

part 'text_analysis_event.dart';
part 'text_analysis_state.dart';

class TextAnalysisBloc extends Bloc<TextAnalysisEvent, TextAnalysisState> {
  final TextAnalysisRepository _repository;

  TextAnalysisBloc(this._repository) : super(const TextAnalysisInitial()) {
    on<TextAnalysisAnalyzeRequested>(_onAnalyze);
    on<TextAnalysisDemoRequested>(_onDemo);
    on<TextAnalysisReset>(_onReset);
  }

  Future<void> _onAnalyze(
    TextAnalysisAnalyzeRequested event,
    Emitter<TextAnalysisState> emit,
  ) async {
    final text = event.text;
    final analysisType = event.analysisType;

    if (text.trim().isEmpty) {
      emit(const TextAnalysisError('Text cannot be empty'));
      return;
    }

    if (text.trim().length < 5) {
      emit(const TextAnalysisError('Text must be at least 5 characters long'));
      return;
    }

    emit(const TextAnalysisLoading());

    try {
      final result = await _repository.analyzeText(
        text: text,
        analysisType: analysisType,
      );
      emit(TextAnalysisSuccess(result));
    } catch (e) {
      emit(TextAnalysisError('Analysis failed: ${e.toString()}'));
    }
  }

  void _onDemo(
    TextAnalysisDemoRequested event,
    Emitter<TextAnalysisState> emit,
  ) {
    emit(TextAnalysisDemo(_repository.buildDemoResult(event.analysisType)));
  }

  void _onReset(TextAnalysisReset event, Emitter<TextAnalysisState> emit) {
    emit(const TextAnalysisInitial());
  }
}
