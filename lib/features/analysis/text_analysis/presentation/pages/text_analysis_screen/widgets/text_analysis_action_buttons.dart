import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

/// Widget for action buttons (analyze, clear, etc.)
class TextAnalysisActionButtons extends StatelessWidget {
  final bool isAnalyzing;
  final bool hasText;
  final VoidCallback onAnalyze;
  final VoidCallback onClear;
  final VoidCallback? onImportFromUrl;
  final String selectedSourceType;

  const TextAnalysisActionButtons({
    super.key,
    required this.isAnalyzing,
    required this.hasText,
    required this.onAnalyze,
    required this.onClear,
    this.onImportFromUrl,
    required this.selectedSourceType,
  });

  @override
  Widget build(BuildContext context) {
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
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: hasText && !isAnalyzing ? onAnalyze : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryLight,
                      foregroundColor: AppColors.white,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child:
                        isAnalyzing
                            ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                      AppColors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'Analyzing...',
                                  style: AppFonts.button(color: AppColors.white),
                                ),
                              ],
                            )
                            : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.analytics, size: 20, color: AppColors.white),
                                const SizedBox(width: 8),
                                Text(
                                  'Analyze Text',
                                  style: AppFonts.button(color: AppColors.white),
                                ),
                              ],
                            ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: hasText && !isAnalyzing ? onClear : null,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(
                        color: AppColors.error,
                        width: 1.5,
                      ),
                      foregroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.clear, size: 18),
                        const SizedBox(width: 6),
                        Text(
                          'Clear',
                          style: AppFonts.copyWith(
                            AppFonts.button(color: AppColors.error),
                            fontSize: AppFonts.sizeM,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (onImportFromUrl != null) ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: !isAnalyzing ? onImportFromUrl : null,
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(
                      color: AppColors.success,
                      width: 1.5,
                    ),
                    foregroundColor: AppColors.success,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.download, size: 18),
                      const SizedBox(width: 8),
                      Text(
                        _getImportButtonText(),
                        style: AppFonts.copyWith(
                          AppFonts.button(color: AppColors.success),
                          fontSize: AppFonts.sizeM,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryLight.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    color: AppColors.primaryLight,
                    size: 16,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      hasText
                          ? 'Ready to analyze your ${selectedSourceType.toLowerCase()}'
                          : 'Enter text or import from URL to begin analysis',
                      style: AppFonts.caption(color: AppColors.primaryLight),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getImportButtonText() {
    switch (selectedSourceType) {
      case 'YouTube Comments':
        return 'Import YouTube Comments';
      case 'Amazon Reviews':
        return 'Import Amazon Reviews';
      default:
        return 'Import from URL';
    }
  }
}
