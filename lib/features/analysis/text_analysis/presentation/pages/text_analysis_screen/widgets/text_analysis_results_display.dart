import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

/// Widget for displaying analysis results
class TextAnalysisResultsDisplay extends StatelessWidget {
  final bool hasResults;
  final Map<String, dynamic>? analysisResults;
  final String selectedAnalysisType;

  const TextAnalysisResultsDisplay({
    super.key,
    required this.hasResults,
    this.analysisResults,
    required this.selectedAnalysisType,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasResults || analysisResults == null) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.analytics,
                    color: AppColors.success,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Analysis Results',
                  style: AppFonts.copyWith(
                    AppFonts.bodyLarge(color: AppColors.darkSurface),
                    fontWeight: AppFonts.semiBold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    selectedAnalysisType,
                    style: AppFonts.labelMedium(color: AppColors.primaryLight),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                _buildOverallScore(),
                const SizedBox(height: 20),
                _buildDetailedResults(),
                const SizedBox(height: 20),
                _buildInsights(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverallScore() {
    final sentiment = analysisResults!['sentiment'] ?? 'neutral';
    final confidence = analysisResults!['confidence'] ?? 0.75;

    Color sentimentColor;
    IconData sentimentIcon;

    switch (sentiment.toLowerCase()) {
      case 'positive':
        sentimentColor = AppColors.success;
        sentimentIcon = Icons.sentiment_very_satisfied;
        break;
      case 'negative':
        sentimentColor = AppColors.error;
        sentimentIcon = Icons.sentiment_very_dissatisfied;
        break;
      default:
        sentimentColor = AppColors.warning;
        sentimentIcon = Icons.sentiment_neutral;
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            sentimentColor.withValues(alpha: 0.1),
            sentimentColor.withValues(alpha: 0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: sentimentColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: sentimentColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(sentimentIcon, color: sentimentColor, size: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Sentiment',
                  style: AppFonts.labelLarge(color: sentimentColor),
                ),
                const SizedBox(height: 4),
                Text(
                  sentiment.toUpperCase(),
                  style: AppFonts.copyWith(
                    AppFonts.h5(color: sentimentColor),
                    fontWeight: AppFonts.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                  style: AppFonts.caption(color: sentimentColor),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailedResults() {
    final emotions =
        analysisResults!['emotions'] as Map<String, dynamic>? ?? {};
    final topics = analysisResults!['topics'] as List<dynamic>? ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (emotions.isNotEmpty) ...[
          Text(
            'Emotion Breakdown',
            style: AppFonts.button(color: AppColors.darkSurface),
          ),
          const SizedBox(height: 12),
          ...emotions.entries.map(
            (entry) =>
                _buildEmotionBar(entry.key, (entry.value as num).toDouble()),
          ),
          const SizedBox(height: 20),
        ],
        if (topics.isNotEmpty) ...[
          Text(
            'Key Topics',
            style: AppFonts.button(color: AppColors.darkSurface),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children:
                topics
                    .map((topic) => _buildTopicChip(topic.toString()))
                    .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildEmotionBar(String emotion, double value) {
    final colors = {
      'joy': AppColors.success,
      'anger': AppColors.error,
      'sadness': AppColors.primaryLight,
      'fear': AppColors.accent,
      'surprise': AppColors.warning,
      'disgust': AppColors.textSecondary,
    };

    final color = colors[emotion.toLowerCase()] ?? AppColors.textTertiary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                emotion.capitalize(),
                style: AppFonts.labelLarge(color: AppColors.darkSurface),
              ),
              Text(
                '${(value * 100).toStringAsFixed(1)}%',
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: color),
                  fontWeight: AppFonts.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: value,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ],
      ),
    );
  }

  Widget _buildTopicChip(String topic) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primaryLight.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        topic,
        style: AppFonts.labelMedium(color: AppColors.primaryLight),
      ),
    );
  }

  Widget _buildInsights() {
    final insights =
        analysisResults!['insights'] as List<dynamic>? ??
        [
          'Text analysis completed successfully',
          'Results are based on advanced NLP algorithms',
          'Consider the context when interpreting results',
        ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Key Insights',
          style: AppFonts.button(color: AppColors.darkSurface),
        ),
        const SizedBox(height: 12),
        ...insights.map(
          (insight) => Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surfaceVariant,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primaryLight,
                  size: 16,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    insight.toString(),
                    style: AppFonts.copyWith(
                      AppFonts.bodySmall(color: AppColors.textSecondary),
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
