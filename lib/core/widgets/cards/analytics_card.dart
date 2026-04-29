import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/services/models/analytics_summary.dart';
import 'package:emosense_mobile/core/core.dart';

class AnalyticsCard extends StatelessWidget {
  final AnalyticsSummary? analytics;
  final VoidCallback? onRefresh;

  const AnalyticsCard({super.key, this.analytics, this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.accent.withValues(alpha: 0.1),
              AppColors.primary.withValues(alpha: 0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.analytics, color: AppColors.accent, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Analytics Summary',
                  style: AppFonts.h6(color: AppColors.textPrimary),
                ),
                const Spacer(),
                if (onRefresh != null)
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh, color: AppColors.accent),
                    tooltip: 'Refresh analytics',
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (analytics == null)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(color: AppColors.accent),
                    const SizedBox(height: 16),
                    Text(
                      'Loading analytics...',
                      style:
                          AppFonts.bodyMedium(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _buildOverviewStats(),
                  const SizedBox(height: 20),
                  _buildEmotionBreakdown(),
                  const SizedBox(height: 20),
                  _buildSentimentBreakdown(),
                  const SizedBox(height: 20),
                  _buildPerformanceStats(),
                  if (analytics!.popularTexts.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _buildPopularTexts(),
                  ],
                  const SizedBox(height: 12),
                  _buildFooter(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewStats() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            'Total Analyses',
            analytics!.totalAnalyses.toString(),
            Icons.analytics,
            AppColors.accent,
          ),
          _buildStatColumn(
            'Avg Confidence',
            analytics!.averageConfidenceFormatted,
            Icons.verified,
            AppColors.success,
          ),
          _buildStatColumn(
            'Top Emotion',
            analytics!.topEmotion,
            Icons.emoji_emotions,
            EmotionUtils.getEmotionColor(analytics!.topEmotion),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_emotions, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Emotion Breakdown',
                style: AppFonts.copyWith(
                  AppFonts.bodyMedium(color: AppColors.textPrimary),
                  fontWeight: AppFonts.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...analytics!.emotionCounts.entries.map((entry) {
            final percentage =
                analytics!.totalAnalyses > 0
                    ? (entry.value / analytics!.totalAnalyses) * 100
                    : 0.0;
            return _buildProgressItem(
              entry.key,
              entry.value,
              percentage,
              EmotionUtils.getEmotionColor(entry.key),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildSentimentBreakdown() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.accent.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.accent.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.sentiment_satisfied,
                color: AppColors.accent,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Sentiment Breakdown',
                style: AppFonts.copyWith(
                  AppFonts.bodyMedium(color: AppColors.textPrimary),
                  fontWeight: AppFonts.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...analytics!.sentimentCounts.entries.map((entry) {
            final percentage =
                analytics!.totalAnalyses > 0
                    ? (entry.value / analytics!.totalAnalyses) * 100
                    : 0.0;
            return _buildProgressItem(
              entry.key,
              entry.value,
              percentage,
              _getSentimentColor(entry.key),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildPerformanceStats() {
    final perf = analytics!.performanceStats;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.speed, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                'Performance Statistics',
                style: AppFonts.copyWith(
                  AppFonts.bodyMedium(color: AppColors.textPrimary),
                  fontWeight: AppFonts.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatColumn(
                'Avg Time',
                perf.averageProcessingTimeFormatted,
                Icons.timer,
                AppColors.success,
              ),
              _buildStatColumn(
                'Success Rate',
                perf.successRateFormatted,
                Icons.check_circle,
                AppColors.success,
              ),
              _buildStatColumn(
                'Total Requests',
                perf.totalRequests.toString(),
                Icons.api,
                AppColors.primary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularTexts() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: AppColors.warning, size: 20),
              const SizedBox(width: 8),
              Text(
                'Popular Texts',
                style: AppFonts.copyWith(
                  AppFonts.bodyMedium(color: AppColors.textPrimary),
                  fontWeight: AppFonts.semiBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...analytics!.popularTexts.take(3).map((popularText) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '"${popularText.text}"',
                    style: AppFonts.bodySmall(color: AppColors.textPrimary)
                        .copyWith(fontStyle: FontStyle.italic),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: EmotionUtils.getEmotionColor(
                            popularText.emotion,
                          ).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          popularText.emotion,
                          style: AppFonts.labelMedium(
                            color: EmotionUtils.getEmotionColor(
                              popularText.emotion,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        '${popularText.confidenceFormatted} • ${popularText.count}x',
                        style:
                            AppFonts.caption(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProgressItem(
    String label,
    int count,
    double percentage,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: AppFonts.labelLarge(color: AppColors.textPrimary),
              ),
              Text(
                '$count (${percentage.toStringAsFixed(1)}%)',
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: color),
                  fontWeight: AppFonts.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
        ],
      ),
    );
  }

  Widget _buildStatColumn(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Column(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppFonts.copyWith(
            AppFonts.bodyMedium(color: color),
            fontWeight: AppFonts.bold,
          ),
        ),
        Text(
          label,
          style: AppFonts.caption(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        Icon(Icons.access_time, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 4),
        Text(
          'Time Range: ${analytics!.timeRange.duration}',
          style: AppFonts.caption(color: AppColors.textSecondary),
        ),
        const Spacer(),
        Text(
          'Updated: ${_formatTimestamp()}',
          style: AppFonts.caption(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Color _getSentimentColor(String sentiment) {
    switch (sentiment.toLowerCase()) {
      case 'positive':
        return AppColors.success;
      case 'negative':
        return AppColors.error;
      case 'neutral':
        return AppColors.textSecondary;
      default:
        return AppColors.primary;
    }
  }

  String _formatTimestamp() {
    if (analytics?.lastUpdated == null) return 'Never';
    try {
      final time = DateTime.parse(analytics!.lastUpdated);
      final now = DateTime.now();
      final diff = now.difference(time);

      if (diff.inSeconds < 60) return '${diff.inSeconds}s ago';
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return 'Invalid';
    }
  }
}
