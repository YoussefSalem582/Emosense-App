part of 'emotion_bloc.dart';

abstract class EmotionEvent extends Equatable {
  const EmotionEvent();

  @override
  List<Object?> get props => [];
}

class EmotionStarted extends EmotionEvent {
  const EmotionStarted();
}

class EmotionConnectionCheckRequested extends EmotionEvent {
  const EmotionConnectionCheckRequested();
}

class EmotionAnalyzeTextRequested extends EmotionEvent {
  final String text;

  const EmotionAnalyzeTextRequested(this.text);

  @override
  List<Object?> get props => [text];
}

class EmotionLoadDemoRequested extends EmotionEvent {
  const EmotionLoadDemoRequested();
}

class EmotionLoadSystemMetricsRequested extends EmotionEvent {
  const EmotionLoadSystemMetricsRequested();
}

class EmotionLoadAnalyticsRequested extends EmotionEvent {
  const EmotionLoadAnalyticsRequested();
}

class EmotionLoadCacheStatsRequested extends EmotionEvent {
  const EmotionLoadCacheStatsRequested();
}

class EmotionLoadModelInfoRequested extends EmotionEvent {
  const EmotionLoadModelInfoRequested();
}

class EmotionClearCacheRequested extends EmotionEvent {
  const EmotionClearCacheRequested();
}

class EmotionToggleAutoRefreshMetrics extends EmotionEvent {
  const EmotionToggleAutoRefreshMetrics();
}

class EmotionResultCleared extends EmotionEvent {
  const EmotionResultCleared();
}

class EmotionErrorCleared extends EmotionEvent {
  const EmotionErrorCleared();
}
