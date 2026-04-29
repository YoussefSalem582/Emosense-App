import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emosense_mobile/features/employee/shared/presentation/bloc/employee_analytics_bloc.dart';

import '../../../../core/core.dart';
import 'package:emosense_mobile/features/employee/shared/presentation/widgets/common/widgets.dart';

class AnalyticsHeader extends StatelessWidget {
  final CustomSpacing customSpacing;

  const AnalyticsHeader({super.key, required this.customSpacing});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: EmployeeSectionHeader(title: 'Interaction Analytics')),
        BlocBuilder<EmployeeAnalyticsBloc, EmployeeAnalyticsState>(
          builder: (context, state) {
            final selectedTimeRange =
                state is EmployeeAnalyticsSuccess
                    ? state.data.timeRange
                    : 'This Week';

            return Container(
              padding: EdgeInsets.symmetric(
                horizontal: customSpacing.md,
                vertical: customSpacing.sm,
              ),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimary.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedTimeRange,
                  style: AppFonts.copyWith(
                    AppFonts.bodySmall(color: AppColors.textPrimary),
                    fontWeight: AppFonts.semiBold,
                  ),
                  items:
                      ['Today', 'This Week', 'This Month', 'Last 3 Months']
                          .map(
                            (range) => DropdownMenuItem(
                              value: range,
                              child: Text(range),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<EmployeeAnalyticsBloc>().add(
                        EmployeeAnalyticsFetched(timeRange: value),
                      );
                    }
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
