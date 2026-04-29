import 'package:flutter/material.dart';
import '../../../../core/core.dart';

class DetailedAnalytics extends StatelessWidget {
  final CustomSpacing customSpacing;
  final Animation<double> cardAnimation;

  const DetailedAnalytics({
    super.key,
    required this.customSpacing,
    required this.cardAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Analytics',
          style: AppFonts.copyWith(
            AppFonts.bodyMedium(color: AppColors.white),
            fontWeight: AppFonts.bold,
          ),
        ),
        SizedBox(height: customSpacing.md),

        Row(
          children: [
            Expanded(child: _buildTicketTypeBreakdown()),
            SizedBox(width: customSpacing.md),
            Expanded(child: _buildPriorityDistribution()),
          ],
        ),
        SizedBox(height: customSpacing.md),

        _buildResponseTimeBreakdown(),
      ],
    );
  }

  Widget _buildTicketTypeBreakdown() {
    return Container(
      height: 220,
      padding: EdgeInsets.all(customSpacing.md),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ticket Types',
            style: AppFonts.copyWith(
              AppFonts.bodySmall(color: AppColors.textPrimary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
          SizedBox(height: customSpacing.md),
          Expanded(
            child: Column(
              children: [
                _buildTypeBar('Product Issues', 0.45, AppColors.error),
                _buildTypeBar('Shipping', 0.25, AppColors.warning),
                _buildTypeBar('Account', 0.20, AppColors.info),
                _buildTypeBar('Other', 0.10, AppColors.success),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityDistribution() {
    return Container(
      height: 220,
      padding: EdgeInsets.all(customSpacing.md),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Priority Distribution',
            style: AppFonts.copyWith(
              AppFonts.bodySmall(color: AppColors.textPrimary),
              fontWeight: AppFonts.semiBold,
            ),
          ),
          SizedBox(height: customSpacing.md),
          Expanded(
            child: Center(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: CircularProgressIndicator(
                      value: 0.32 * cardAnimation.value,
                      strokeWidth: 15,
                      backgroundColor: AppColors.surfaceContainer,
                      color: AppColors.error,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '32%',
                        style: AppFonts.copyWith(
                          AppFonts.h6(color: AppColors.textPrimary),
                          fontWeight: AppFonts.black,
                        ),
                      ),
                      Text(
                        'High Priority',
                        style: AppFonts.labelSmall(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          // Priority legend
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildPriorityLegend('High', AppColors.error, '32%'),
              _buildPriorityLegend('Medium', AppColors.warning, '48%'),
              _buildPriorityLegend('Low', AppColors.success, '20%'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriorityLegend(String label, Color color, String percentage) {
    return Column(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppFonts.labelSmall(
            color: AppColors.textPrimary,
          ).copyWith(fontWeight: AppFonts.medium),
        ),
        Text(
          percentage,
          style: AppFonts.copyWith(
            AppFonts.labelSmall(color: color),
            fontWeight: AppFonts.semiBold,
            fontSize: 9,
          ),
        ),
      ],
    );
  }

  Widget _buildResponseTimeBreakdown() {
    return Container(
      padding: EdgeInsets.all(customSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimary.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ticket Resolution Speed',
            style: AppFonts.copyWith(
              AppFonts.bodyLarge(color: AppColors.textPrimary),
              fontWeight: AppFonts.bold,
            ),
          ),
          SizedBox(height: customSpacing.lg),
          Row(
            children: [
              Expanded(
                child: _buildTimeMetric('Same Day', '45%', AppColors.success),
              ),
              Expanded(
                child: _buildTimeMetric('1-2 Days', '35%', AppColors.warning),
              ),
              Expanded(
                child: _buildTimeMetric('3-5 Days', '15%', AppColors.error),
              ),
              Expanded(
                child: _buildTimeMetric(
                  '> 5 Days',
                  '5%',
                  AppColors.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTypeBar(String label, double percentage, Color color) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: customSpacing.xs),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: AppFonts.bodySmall(
                  color: AppColors.textPrimary,
                ).copyWith(fontWeight: AppFonts.medium),
              ),
              Text(
                '${(percentage * 100).toInt()}%',
                style: AppFonts.copyWith(
                  AppFonts.bodySmall(color: color),
                  fontWeight: AppFonts.semiBold,
                ),
              ),
            ],
          ),
          SizedBox(height: customSpacing.xs),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: percentage * cardAnimation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeMetric(String timeRange, String percentage, Color color) {
    return Column(
      children: [
        Text(
          percentage,
          style: AppFonts.copyWith(
            AppFonts.h6(color: color),
            fontWeight: AppFonts.black,
          ),
        ),
        Text(
          timeRange,
          style: AppFonts.labelSmall(color: AppColors.textSecondary),
        ),
      ],
    );
  }
}
