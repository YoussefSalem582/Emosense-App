import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data/models/analytics_summary.dart';
import '../../../../data/models/demo_result.dart';
import '../../../../data/models/emotion_result.dart';
import '../../../../data/models/system_metrics.dart';
import '../../../../data/services/emotion_api_service.dart';

part 'emotion_event.dart';
part 'emotion_state.dart';

class EmotionBloc extends Bloc<EmotionEvent, EmotionState> {
  final EmotionApiService _apiService;
  Timer? _metricsTimer;

  EmotionBloc(this._apiService) : super(const EmotionInitial()) {
    on<EmotionStarted>(_onStarted);
    on<EmotionConnectionCheckRequested>(_onConnectionCheck);
    on<EmotionAnalyzeTextRequested>(_onAnalyzeText);
    on<EmotionLoadDemoRequested>(_onLoadDemo);
    on<EmotionLoadSystemMetricsRequested>(_onLoadSystemMetrics);
    on<EmotionLoadAnalyticsRequested>(_onLoadAnalytics);
    on<EmotionLoadCacheStatsRequested>(_onLoadCacheStats);
    on<EmotionLoadModelInfoRequested>(_onLoadModelInfo);
    on<EmotionClearCacheRequested>(_onClearCache);
    on<EmotionToggleAutoRefreshMetrics>(_onToggleAutoRefresh);
    on<EmotionResultCleared>(_onResultCleared);
    on<EmotionErrorCleared>(_onErrorCleared);

    add(const EmotionStarted());
  }

  @override
  Future<void> close() {
    _metricsTimer?.cancel();
    return super.close();
  }

  Future<void> _onStarted(
    EmotionStarted event,
    Emitter<EmotionState> emit,
  ) async {
    try {
      await Future.wait([
        _loadDemo(emit),
        _loadSystemMetricsSilent(emit),
        _loadAnalyticsSilent(emit),
        _loadCacheStatsSilent(emit),
        _loadModelInfoSilent(emit),
      ]);
    } catch (_) {
      emit(const EmotionInitial());
    }
  }

  Future<void> _onConnectionCheck(
    EmotionConnectionCheckRequested event,
    Emitter<EmotionState> emit,
  ) async {
    emit(const EmotionConnectionChecking());

    try {
      final connectionDetails = await _apiService.checkConnectionDetailed();
      final isConnected = connectionDetails.isNotEmpty;

      Map<String, bool> endpointStatus = {};
      if (isConnected) {
        endpointStatus = await _apiService.testAllEndpoints();
      }

      emit(
        EmotionConnectionResult(
          isConnected: isConnected,
          connectionDetails: connectionDetails,
          endpointStatus: endpointStatus,
        ),
      );
    } catch (e) {
      emit(EmotionError('Connection check failed: ${e.toString()}'));
    }
  }

  Future<void> _onAnalyzeText(
    EmotionAnalyzeTextRequested event,
    Emitter<EmotionState> emit,
  ) async {
    final text = event.text;
    if (text.trim().isEmpty) {
      emit(const EmotionError('Text cannot be empty'));
      return;
    }

    emit(const EmotionLoading());

    try {
      final result = await _apiService.analyzeEmotion(text);
      emit(EmotionSuccess(result));
    } catch (e) {
      emit(EmotionError(_getErrorMessage(e)));
    }
  }

  Future<void> _onLoadDemo(
    EmotionLoadDemoRequested event,
    Emitter<EmotionState> emit,
  ) async {
    await _loadDemo(emit);
  }

  Future<void> _loadDemo(Emitter<EmotionState> emit) async {
    try {
      final demoResult = await _apiService.getDemoResults();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(demoResult: demoResult));
      } else {
        emit(EmotionDemo(demoResult));
      }
    } catch (_) {}
  }

  Future<void> _onLoadSystemMetrics(
    EmotionLoadSystemMetricsRequested event,
    Emitter<EmotionState> emit,
  ) async {
    await _loadSystemMetricsSilent(emit);
  }

  Future<void> _loadSystemMetricsSilent(Emitter<EmotionState> emit) async {
    try {
      final metrics = await _apiService.getSystemMetrics();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(systemMetrics: metrics));
      }
    } catch (_) {}
  }

  Future<void> _onLoadAnalytics(
    EmotionLoadAnalyticsRequested event,
    Emitter<EmotionState> emit,
  ) async {
    await _loadAnalyticsSilent(emit);
  }

  Future<void> _loadAnalyticsSilent(Emitter<EmotionState> emit) async {
    try {
      final analytics = await _apiService.getAnalyticsSummary();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(analyticsSummary: analytics));
      }
    } catch (_) {}
  }

  Future<void> _onLoadCacheStats(
    EmotionLoadCacheStatsRequested event,
    Emitter<EmotionState> emit,
  ) async {
    await _loadCacheStatsSilent(emit);
  }

  Future<void> _loadCacheStatsSilent(Emitter<EmotionState> emit) async {
    try {
      final cacheStats = await _apiService.getCacheStats();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(cacheStats: cacheStats));
      }
    } catch (_) {}
  }

  Future<void> _onLoadModelInfo(
    EmotionLoadModelInfoRequested event,
    Emitter<EmotionState> emit,
  ) async {
    await _loadModelInfoSilent(emit);
  }

  Future<void> _loadModelInfoSilent(Emitter<EmotionState> emit) async {
    try {
      final modelInfo = await _apiService.getModelInfo();
      if (state is EmotionSuccess) {
        final currentState = state as EmotionSuccess;
        emit(currentState.copyWith(modelInfo: modelInfo));
      }
    } catch (_) {}
  }

  Future<void> _onClearCache(
    EmotionClearCacheRequested event,
    Emitter<EmotionState> emit,
  ) async {
    try {
      final success = await _apiService.clearCache();
      if (success) {
        add(const EmotionLoadCacheStatsRequested());
      }
    } catch (e) {
      emit(const EmotionError('Failed to clear cache'));
    }
  }

  void _onToggleAutoRefresh(
    EmotionToggleAutoRefreshMetrics event,
    Emitter<EmotionState> emit,
  ) {
    if (_metricsTimer?.isActive ?? false) {
      _metricsTimer?.cancel();
    } else {
      _metricsTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        add(const EmotionLoadSystemMetricsRequested());
      });
    }
  }

  void _onResultCleared(
    EmotionResultCleared event,
    Emitter<EmotionState> emit,
  ) {
    emit(const EmotionInitial());
  }

  void _onErrorCleared(
    EmotionErrorCleared event,
    Emitter<EmotionState> emit,
  ) {
    if (state is EmotionError) {
      emit(const EmotionInitial());
    }
  }

  String _getErrorMessage(dynamic error) {
    if (error.toString().contains('timeout')) {
      return 'Request timeout - please try again';
    } else if (error.toString().contains('Connection')) {
      return 'Unable to connect to the server';
    } else if (error.toString().contains('404')) {
      return 'Service endpoint not found';
    } else if (error.toString().contains('500')) {
      return 'Server error - please try again later';
    } else {
      return 'Analysis failed: ${error.toString()}';
    }
  }
}
