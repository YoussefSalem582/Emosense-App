import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

/// Widget for direct text input
class TextAnalysisInputSection extends StatelessWidget {
  final TextEditingController textController;
  final FocusNode textFocusNode;
  final String selectedSourceType;

  const TextAnalysisInputSection({
    super.key,
    required this.textController,
    required this.textFocusNode,
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
                    color: AppColors.primaryLight.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.edit_note,
                    color: AppColors.primaryLight,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'Text Input',
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
            child: TextField(
              controller: textController,
              focusNode: textFocusNode,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: _getHintText(),
                hintStyle: AppFonts.bodySmall(color: AppColors.textLight),
                filled: true,
                fillColor: AppColors.surfaceVariant,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(
                    color: AppColors.primaryLight,
                    width: 2,
                  ),
                ),
              ),
              style: AppFonts.bodySmall(color: AppColors.darkSurface),
            ),
          ),
        ],
      ),
    );
  }

  String _getHintText() {
    switch (selectedSourceType) {
      case 'YouTube Comments':
        return 'Paste YouTube comments here...\n\nExample:\nUser1: Great video!\nUser2: Thanks for the explanation\nUser3: This helped a lot';
      case 'Amazon Reviews':
        return 'Paste Amazon product reviews here...\n\nExample:\n⭐⭐⭐⭐⭐ Great product!\nThe quality exceeded my expectations...';
      default:
        return 'Enter your text here for analysis...';
    }
  }
}
