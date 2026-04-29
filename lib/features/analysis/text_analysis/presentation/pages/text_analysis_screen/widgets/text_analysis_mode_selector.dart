import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

/// Widget for selecting the source type (Direct Text, YouTube Comments, etc.)
class TextAnalysisModeSelector extends StatelessWidget {
  final List<String> sourceTypes;
  final String selectedSourceType;
  final Function(String) onSourceTypeChanged;

  const TextAnalysisModeSelector({
    super.key,
    required this.sourceTypes,
    required this.selectedSourceType,
    required this.onSourceTypeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children:
            sourceTypes.map((type) {
              final isSelected = selectedSourceType == type;
              return Expanded(
                child: GestureDetector(
                  onTap: () => onSourceTypeChanged(type),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? AppColors.surface : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow:
                          isSelected
                              ? [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 4,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                              : null,
                    ),
                    child: Text(
                      type,
                      textAlign: TextAlign.center,
                      style: AppFonts.copyWith(
                        AppFonts.caption(
                          color: isSelected
                              ? AppColors.darkSurface
                              : AppColors.textTertiary,
                        ),
                        fontWeight: isSelected
                            ? AppFonts.semiBold
                            : AppFonts.medium,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
      ),
    );
  }
}
