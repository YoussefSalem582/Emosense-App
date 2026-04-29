import 'package:flutter/material.dart';
import '../../../core/core.dart';

class EmotionInputField extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSubmitted;

  const EmotionInputField({
    super.key,
    required this.controller,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: 4,
        style: AppFonts.bodyMedium(color: AppColors.textPrimary),
        onSubmitted: (_) => onSubmitted?.call(),
        decoration: InputDecoration(
          labelText: AppStrings.inputLabel,
          labelStyle: AppFonts.labelMedium(color: AppColors.primary),
          hintText: AppStrings.inputHint,
          hintStyle: AppFonts.bodySmall(color: AppColors.textLight),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: AppColors.surface,
          contentPadding: const EdgeInsets.all(20),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.edit_note, color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}
