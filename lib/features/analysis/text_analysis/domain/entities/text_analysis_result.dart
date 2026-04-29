import 'package:equatable/equatable.dart';

/// Domain model for a completed text analysis (UI + persistence shape).
class TextAnalysisResult extends Equatable {
  final String id;
  final String text;
  final String analysisType;
  final double confidence;
  final DateTime timestamp;
  final String summary;
  final List<String> details;
  final Map<String, double> sentiments;
  final List<String> keywords;
  final Map<String, dynamic> metrics;

  const TextAnalysisResult({
    required this.id,
    required this.text,
    required this.analysisType,
    required this.confidence,
    required this.timestamp,
    required this.summary,
    required this.details,
    required this.sentiments,
    required this.keywords,
    required this.metrics,
  });

  @override
  List<Object?> get props => [
    id,
    text,
    analysisType,
    confidence,
    timestamp,
    summary,
    details,
    sentiments,
    keywords,
    metrics,
  ];

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'type': 'text',
      'title': 'Text Analysis Results',
      'confidence': confidence,
      'timestamp': timestamp.toIso8601String(),
      'summary': summary,
      'details': details,
      'sentiments': sentiments,
      'keywords': keywords,
      'metrics': metrics,
      'analysisType': analysisType,
      'originalText': text,
    };
  }
}
