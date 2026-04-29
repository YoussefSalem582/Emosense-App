import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/services/models/demo_result.dart';
import 'package:emosense_mobile/core/core.dart';

class DemoExamplesCard extends StatelessWidget {
  final DemoResult? demoResult;
  final VoidCallback? onRefresh;
  final Function(String)? onAnalyzeExample;

  const DemoExamplesCard({
    super.key,
    this.demoResult,
    this.onRefresh,
    this.onAnalyzeExample,
  });

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
              AppColors.primaryDark.withValues(alpha: 0.1),
              AppColors.info.withValues(alpha: 0.1),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: AppColors.primaryDark,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Demo Examples',
                  style: AppFonts.h6(color: AppColors.textPrimary),
                ),
                const Spacer(),
                if (onRefresh != null)
                  IconButton(
                    onPressed: onRefresh,
                    icon: const Icon(Icons.refresh, color: AppColors.primaryDark),
                    tooltip: 'Refresh examples',
                  ),
              ],
            ),
            const SizedBox(height: 20),
            if (demoResult == null)
              Center(
                child: Column(
                  children: [
                    const CircularProgressIndicator(
                      color: AppColors.primaryDark,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Loading demo examples...',
                      style:
                          AppFonts.bodyMedium(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              )
            else
              Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildExamplesList(),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryDark.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryDark.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatColumn(
            'Total Examples',
            demoResult!.totalExamples.toString(),
            Icons.list_alt,
            AppColors.primaryDark,
          ),
          _buildStatColumn(
            'High Confidence',
            demoResult!.highConfidenceExamples.length.toString(),
            Icons.verified,
            AppColors.success,
          ),
          _buildStatColumn(
            'Categories',
            demoResult!.examplesByEmotion.length.toString(),
            Icons.category,
            AppColors.info,
          ),
        ],
      ),
    );
  }

  Widget _buildExamplesList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Try these examples:',
          style: AppFonts.copyWith(
            AppFonts.bodyMedium(color: AppColors.textPrimary),
            fontWeight: AppFonts.semiBold,
          ),
        ),
        const SizedBox(height: 12),
        ...demoResult!.examples.take(6).map((example) {
          return _buildExampleItem(example);
        }),
        if (demoResult!.examples.length > 6)
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              '... and ${demoResult!.examples.length - 6} more examples',
              style: AppFonts.caption(color: AppColors.textSecondary)
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }

  Widget _buildExampleItem(DemoExample example) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: EmotionUtils.getEmotionColor(
            example.emotion,
          ).withValues(alpha: 0.3),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap:
              onAnalyzeExample != null
                  ? () => onAnalyzeExample!(example.text)
                  : null,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        example.text,
                        style: AppFonts.copyWith(
                          AppFonts.bodySmall(color: AppColors.textPrimary),
                          fontWeight: AppFonts.medium,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    if (onAnalyzeExample != null)
                      Icon(
                        Icons.play_arrow,
                        color: AppColors.primary,
                        size: 20,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: EmotionUtils.getEmotionColor(
                          example.emotion,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            EmotionUtils.getEmotionIcon(example.emotion),
                            size: 14,
                            color: EmotionUtils.getEmotionColor(
                              example.emotion,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            example.emotion.toUpperCase(),
                            style: AppFonts.copyWith(
                              AppFonts.labelMedium(
                                color: EmotionUtils.getEmotionColor(
                                  example.emotion,
                                ),
                              ),
                              fontWeight: AppFonts.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: _getSentimentColor(
                          example.sentiment,
                        ).withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        example.sentiment,
                        style: AppFonts.copyWith(
                          AppFonts.caption(
                            color: _getSentimentColor(example.sentiment),
                          ),
                          fontSize: 11,
                          fontWeight: AppFonts.medium,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (example.isHighConfidence)
                          Icon(
                            Icons.verified,
                            size: 14,
                            color: AppColors.success,
                          ),
                        const SizedBox(width: 4),
                        Text(
                          example.confidenceFormatted,
                          style: AppFonts.copyWith(
                            AppFonts.caption(
                              color:
                                  example.isHighConfidence
                                      ? AppColors.success
                                      : AppColors.textSecondary,
                            ),
                            fontWeight: AppFonts.semiBold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                if (example.category != 'general')
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Category: ${example.category}',
                      style: AppFonts.caption(color: AppColors.textSecondary)
                          .copyWith(
                        fontSize: 11,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
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
}
