import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:emosense_mobile/core/core.dart';

import 'package:emosense_mobile/features/employee/performance/presentation/bloc/employee_performance_bloc.dart';

/// Employee performance tab: loads [EmployeePerformanceBloc] data and shows summary metrics.
class EmployeePerformanceScreen extends StatefulWidget {
  const EmployeePerformanceScreen({super.key});

  @override
  State<EmployeePerformanceScreen> createState() =>
      _EmployeePerformanceScreenState();
}

class _EmployeePerformanceScreenState extends State<EmployeePerformanceScreen> {
  @override
  void initState() {
    super.initState();
    context.read<EmployeePerformanceBloc>().add(
      const EmployeePerformanceLoadRequested(),
    );
  }

  Future<void> _onRefresh() async {
    context.read<EmployeePerformanceBloc>().add(
      const EmployeePerformanceRefreshRequested(),
    );
    await context.read<EmployeePerformanceBloc>().stream.firstWhere(
      (s) => s is EmployeePerformanceSuccess || s is EmployeePerformanceError,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Performance'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _onRefresh,
            tooltip: 'Refresh',
          ),
        ],
      ),
      body: BlocBuilder<EmployeePerformanceBloc, EmployeePerformanceState>(
        builder: (context, state) {
          if (state is EmployeePerformanceInitial ||
              state is EmployeePerformanceLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EmployeePerformanceError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed:
                          () => context.read<EmployeePerformanceBloc>().add(
                            const EmployeePerformanceLoadRequested(),
                          ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          if (state is EmployeePerformanceSuccess) {
            final d = state.data;
            return RefreshIndicator(
              onRefresh: _onRefresh,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  _SummaryCard(data: d),
                  const SizedBox(height: 16),
                  _GoalsSection(goals: d.goals),
                  const SizedBox(height: 16),
                  _MetricsSection(metrics: d.keyMetrics),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.data});

  final EmployeePerformanceData data;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Overall score',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(color: AppColors.textSecondary),
            ),
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  '${data.overallScore}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  '/ 100',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              'Rank #${data.ranking} of ${data.totalEmployees}',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: data.monthlyProgress.clamp(0.0, 1.0),
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 8),
            Text(
              'Monthly progress ${(data.monthlyProgress * 100).round()}%',
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalsSection extends StatelessWidget {
  const _GoalsSection({required this.goals});

  final List<Map<String, dynamic>> goals;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Goals',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            ...goals.map(
              (g) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            g['title'] as String? ?? '',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ),
                        Text(
                          '${g['current']}/${g['target']} ${g['unit']}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: ((g['progress'] as num?)?.toDouble() ?? 0).clamp(
                        0.0,
                        1.0,
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricsSection extends StatelessWidget {
  const _MetricsSection({required this.metrics});

  final List<Map<String, dynamic>> metrics;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Key metrics',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            ...metrics
                .take(6)
                .map(
                  (m) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(m['title'] as String? ?? ''),
                    subtitle: Text(m['trend'] as String? ?? ''),
                    trailing: Text(
                      '${m['value']} ${m['unit']}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
