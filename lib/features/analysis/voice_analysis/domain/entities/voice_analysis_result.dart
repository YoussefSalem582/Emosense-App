import 'package:equatable/equatable.dart';

/// Domain model for a completed voice/audio analysis.
class VoiceAnalysisResult extends Equatable {
  final String id;
  final String filePath;
  final String analysisType;
  final double confidence;
  final DateTime timestamp;
  final String summary;
  final List<String> details;
  final Map<String, double> emotions;
  final Map<String, dynamic> metrics;

  const VoiceAnalysisResult({
    required this.id,
    required this.filePath,
    required this.analysisType,
    required this.confidence,
    required this.timestamp,
    required this.summary,
    required this.details,
    required this.emotions,
    required this.metrics,
  });

  @override
  List<Object?> get props => [
    id,
    filePath,
    analysisType,
    confidence,
    timestamp,
    summary,
    details,
    emotions,
    metrics,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'voice',
      'title': 'Audio Analysis Results',
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'summary': summary,
      'details': details,
      'emotions': emotions,
      'metrics': metrics,
      'analysisType': analysisType,
      'filePath': filePath,
    };
  }
}
