import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

/// Widget for displaying sample texts
class TextAnalysisSamplesSection extends StatelessWidget {
  final String selectedSourceType;
  final Function(String) onSampleTapped;

  const TextAnalysisSamplesSection({
    super.key,
    required this.selectedSourceType,
    required this.onSampleTapped,
  });

  static const Color _sampleAccent = Color(0xFFEC4899);

  @override
  Widget build(BuildContext context) {
    final samples = _getSamplesForSourceType();

    if (samples.isEmpty) return const SizedBox.shrink();

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
                    color: _sampleAccent.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.lightbulb_outline,
                    color: _sampleAccent,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Sample Texts',
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
              children:
                  samples.map((sample) => _buildSampleCard(sample)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSampleCard(Map<String, String> sample) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: InkWell(
        onTap: () => onSampleTapped(sample['text']!),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _sampleAccent.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      sample['type']!,
                      style: AppFonts.labelMedium(color: _sampleAccent),
                    ),
                  ),
                  const Spacer(),
                  Icon(
                    Icons.touch_app,
                    color: AppColors.textTertiary,
                    size: 16,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                sample['text']!,
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: AppColors.textSecondary),
                  fontSize: 13,
                  height: AppFonts.lineHeightNormal,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, String>> _getSamplesForSourceType() {
    switch (selectedSourceType) {
      case 'YouTube Comments':
        return [
          {
            'type': 'Positive',
            'text':
                'This video is absolutely amazing! Thanks for such clear explanations. Really helped me understand the concept better. Keep up the great work! 👍',
          },
          {
            'type': 'Mixed',
            'text':
                'Good content overall but the audio quality could be better. The information is valuable though. Would love to see more videos like this.',
          },
          {
            'type': 'Negative',
            'text':
                'Disappointed with this video. The explanation was confusing and I couldn\'t follow along. Maybe add more examples next time?',
          },
        ];
      case 'Amazon Reviews':
        return [
          {
            'type': 'Positive',
            'text':
                '⭐⭐⭐⭐⭐ Excellent product! Exceeded my expectations. Fast delivery and great packaging. Highly recommend to anyone looking for quality.',
          },
          {
            'type': 'Mixed',
            'text':
                '⭐⭐⭐ Decent product for the price. Some features work well but others could be improved. Customer service was helpful when I had questions.',
          },
          {
            'type': 'Negative',
            'text':
                '⭐⭐ Not satisfied with this purchase. Product quality is poor and doesn\'t match the description. Requesting a refund.',
          },
        ];
      case 'Social Media Posts':
        return [
          {
            'type': 'Positive',
            'text':
                'Having such a wonderful day! The weather is perfect and spending time with family. Grateful for these beautiful moments. #blessed #family',
          },
          {
            'type': 'Mixed',
            'text':
                'Work has been challenging lately but learning a lot. Some days are tough but the team is supportive. Looking forward to the weekend.',
          },
          {
            'type': 'Negative',
            'text':
                'Really frustrated with the service today. Waited for hours and nothing got resolved. This is becoming a regular issue. #disappointed',
          },
        ];
      default:
        return [];
    }
  }
}
