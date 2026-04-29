import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

class EmployeeFilterChips extends StatelessWidget {
  final List<String> labels;
  final List<int> counts;
  final int selectedIndex;
  final ValueChanged<int> onSelectionChanged;

  const EmployeeFilterChips({
    super.key,
    required this.labels,
    required this.counts,
    required this.selectedIndex,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Container(
            margin: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text('${labels[index]} (${counts[index]})'),
              selected: isSelected,
              onSelected: (selected) => onSelectionChanged(index),
              selectedColor: AppColors.primary.withValues(alpha: 0.1),
              backgroundColor: AppColors.surfaceContainer,
              checkmarkColor: AppColors.primary,
              side: BorderSide(
                color: isSelected ? AppColors.primary : AppColors.border,
                width: 1,
              ),
              labelStyle: AppFonts.copyWith(
                AppFonts.bodySmall(
                  color: isSelected ? AppColors.primary : AppColors.textSecondary,
                ),
                fontWeight: isSelected ? AppFonts.semiBold : AppFonts.medium,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          );
        },
      ),
    );
  }
}
