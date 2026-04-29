import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/widgets/common/surface_section_card.dart';

/// Widget for action buttons
class VoiceAnalysisActionButtons extends StatelessWidget {
  final bool isAnalyzing;
  final VoidCallback onAnalyze;
  final VoidCallback onClear;
  final bool hasContent;

  const VoiceAnalysisActionButtons({
    super.key,
    required this.isAnalyzing,
    required this.onAnalyze,
    required this.onClear,
    required this.hasContent,
  });

  @override
  Widget build(BuildContext context) {
    return SurfaceSectionCard(
      elevation: SurfaceElevation.softFlat,
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: hasContent && !isAnalyzing ? onAnalyze : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryLight,
                foregroundColor: AppColors.white,
                disabledBackgroundColor: AppColors.border,
                disabledForegroundColor: AppColors.textTertiary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isAnalyzing) ...[
                    const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Analyzing Audio...',
                      style: AppFonts.button(color: AppColors.white),
                    ),
                  ] else ...[
                    const Icon(Icons.analytics, size: 20),
                    const SizedBox(width: 12),
                    Text(
                      'Analyze Voice',
                      style: AppFonts.button(color: AppColors.white),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          OutlinedButton(
            onPressed: hasContent && !isAnalyzing ? onClear : null,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.textTertiary,
              side: const BorderSide(color: AppColors.border),
              disabledForegroundColor: AppColors.border,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.clear, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Clear',
                  style: AppFonts.labelLarge(color: AppColors.textTertiary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
