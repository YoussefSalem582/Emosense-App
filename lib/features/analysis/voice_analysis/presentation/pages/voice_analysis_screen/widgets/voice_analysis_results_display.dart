import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/animated_loading_indicator.dart';

/// Widget for displaying analysis results
class VoiceAnalysisResultsDisplay extends StatelessWidget {
  final Map<String, dynamic>? analysisResults;
  final bool isLoading;

  const VoiceAnalysisResultsDisplay({
    super.key,
    this.analysisResults,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return _buildLoadingState();
    }

    if (analysisResults == null || analysisResults!.isEmpty) {
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
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              children: [
                _buildOverallScore(),
                const SizedBox(height: 20),
                _buildEmotionBreakdown(),
                const SizedBox(height: 20),
                _buildDetailedMetrics(),
                const SizedBox(height: 20),
                _buildTranscriptionSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
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
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          children: [
            EmoLoader.analysis(),
            const SizedBox(height: 16),
            Text(
              'Analyzing voice patterns...',
              style: AppFonts.button(color: AppColors.darkSurface),
            ),
            const SizedBox(height: 8),
            Text(
              'Processing emotional cues and speech patterns',
              style: AppFonts.bodySmall(color: AppColors.textTertiary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverallScore() {
    final score = analysisResults?['overall_score'] ?? 0.0;
    final emotion = analysisResults?['dominant_emotion'] ?? 'Neutral';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryLight.withValues(alpha: 0.1),
            AppColors.success.withValues(alpha: 0.1),
          ],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overall Analysis',
                  style: AppFonts.button(color: AppColors.darkSurface),
                ),
                const SizedBox(height: 8),
                Text(
                  'Dominant Emotion: $emotion',
                  style: AppFonts.bodySmall(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Text(
                '${(score * 100).toInt()}%',
                style: AppFonts.h3(color: AppColors.success),
              ),
              Text(
                'Confidence',
                style: AppFonts.caption(color: AppColors.textTertiary),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionBreakdown() {
    final emotions =
        analysisResults?['emotions'] as Map<String, dynamic>? ?? {};

    if (emotions.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Emotion Breakdown',
          style: AppFonts.button(color: AppColors.darkSurface),
        ),
        const SizedBox(height: 12),
        ...emotions.entries.map((entry) {
          final emotion = entry.key;
          final value = (entry.value as num).toDouble();
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      emotion.toUpperCase(),
                      style: AppFonts.labelMedium(color: AppColors.textTertiary),
                    ),
                    Text(
                      '${(value * 100).toInt()}%',
                      style: AppFonts.copyWith(
                        AppFonts.caption(color: AppColors.darkSurface),
                        fontWeight: AppFonts.semiBold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: value,
                  backgroundColor: AppColors.border,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    _getEmotionColor(emotion),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDetailedMetrics() {
    final metrics = analysisResults?['metrics'] as Map<String, dynamic>? ?? {};

    if (metrics.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Metrics',
          style: AppFonts.button(color: AppColors.darkSurface),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 2.5,
          ),
          itemCount: metrics.length,
          itemBuilder: (context, index) {
            final entry = metrics.entries.elementAt(index);
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.key.replaceAll('_', ' ').toUpperCase(),
                    style: AppFonts.labelSmall(color: AppColors.textTertiary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.value.toString(),
                    style: AppFonts.button(color: AppColors.darkSurface),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildTranscriptionSection() {
    final transcription = analysisResults?['transcription'] as String?;

    if (transcription == null || transcription.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Transcription',
          style: AppFonts.button(color: AppColors.darkSurface),
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Text(
            transcription,
            style: AppFonts.copyWith(
              AppFonts.bodySmall(color: AppColors.textSecondary),
              height: AppFonts.lineHeightRelaxed,
            ),
          ),
        ),
      ],
    );
  }

  Color _getEmotionColor(String emotion) {
    switch (emotion.toLowerCase()) {
      case 'happy':
      case 'joy':
        return AppColors.success;
      case 'sad':
      case 'sadness':
        return AppColors.primaryLight;
      case 'angry':
      case 'anger':
        return AppColors.error;
      case 'fear':
        return AppColors.accent;
      case 'surprise':
        return AppColors.warning;
      case 'disgust':
        return AppColors.textSecondary;
      default:
        return AppColors.textTertiary;
    }
  }
}
