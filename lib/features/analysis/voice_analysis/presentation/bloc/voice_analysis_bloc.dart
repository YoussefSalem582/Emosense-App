import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/voice_analysis_result.dart';
import '../../domain/repositories/voice_analysis_repository.dart';

part 'voice_analysis_event.dart';
part 'voice_analysis_state.dart';

class VoiceAnalysisBloc extends Bloc<VoiceAnalysisEvent, VoiceAnalysisState> {
  VoiceAnalysisBloc(this._repository) : super(const VoiceAnalysisInitial()) {
    on<VoiceAnalysisAnalyzeRequested>(_onAnalyze);
    on<VoiceAnalysisDemoRequested>(_onDemo);
    on<VoiceAnalysisReset>(_onReset);
  }

  final VoiceAnalysisRepository _repository;

  Future<void> _onAnalyze(
    VoiceAnalysisAnalyzeRequested event,
    Emitter<VoiceAnalysisState> emit,
  ) async {
    final filePath = event.filePath;
    final analysisType = event.analysisType;

    if (filePath.trim().isEmpty) {
      emit(const VoiceAnalysisError('Audio file path cannot be empty'));
      return;
    }

    if (!_isValidAudioFile(filePath)) {
      emit(
        const VoiceAnalysisError(
          'Invalid audio file format. Please use MP3, WAV, or M4A',
        ),
      );
      return;
    }

    emit(const VoiceAnalysisLoading());

    try {
      final result = await _repository.analyzeVoice(
        filePath: filePath,
        analysisType: analysisType,
      );
      emit(VoiceAnalysisSuccess(result));
    } catch (e) {
      emit(VoiceAnalysisError('Analysis failed: ${e.toString()}'));
    }
  }

  Future<void> _onDemo(
    VoiceAnalysisDemoRequested event,
    Emitter<VoiceAnalysisState> emit,
  ) async {
    emit(const VoiceAnalysisLoading());

    try {
      final demoResult = await _repository.analyzeVoiceDemo(
        analysisType: event.analysisType,
      );
      emit(VoiceAnalysisDemo(demoResult));
    } catch (e) {
      emit(VoiceAnalysisError('Demo analysis failed: ${e.toString()}'));
    }
  }

  void _onReset(VoiceAnalysisReset event, Emitter<VoiceAnalysisState> emit) {
    emit(const VoiceAnalysisInitial());
  }

  bool _isValidAudioFile(String path) {
    final validExtensions = ['.mp3', '.wav', '.m4a'];
    return validExtensions.any((ext) => path.toLowerCase().endsWith(ext)) ||
        path.startsWith('/audio/');
  }
}
