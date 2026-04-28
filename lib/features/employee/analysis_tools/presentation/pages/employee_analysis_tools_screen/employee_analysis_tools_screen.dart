import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/features/employee/analysis_tools/presentation/bloc/employee_analysis_tools_bloc.dart';

class EmployeeAnalysisToolsScreen extends StatefulWidget {
  final Function(int)? onAnalysisToolSelected;

  const EmployeeAnalysisToolsScreen({super.key, this.onAnalysisToolSelected});

  @override
  State<EmployeeAnalysisToolsScreen> createState() =>
      _EmployeeAnalysisToolsScreenState();
}

class _EmployeeAnalysisToolsScreenState
    extends State<EmployeeAnalysisToolsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _backgroundController.repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<EmployeeAnalysisToolsBloc>().add(
        const EmployeeAnalysisToolsLoadRequested(),
      );
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final customSpacing = theme.extension<CustomSpacing>()!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6366F1),
                  Color(0xFF8B5CF6),
                  Color(0xFF06B6D4),
                ],
              ),
            ),
          ),
          SafeArea(
            child: BlocBuilder<
              EmployeeAnalysisToolsBloc,
              EmployeeAnalysisToolsState
            >(
              builder: (context, state) {
                if (state is EmployeeAnalysisToolsInitial ||
                    state is EmployeeAnalysisToolsLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  );
                }
                if (state is EmployeeAnalysisToolsError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(customSpacing.lg),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 48,
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          SizedBox(height: customSpacing.md),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.white),
                          ),
                          SizedBox(height: customSpacing.md),
                          ElevatedButton(
                            onPressed:
                                () => context
                                    .read<EmployeeAnalysisToolsBloc>()
                                    .add(
                                      const EmployeeAnalysisToolsLoadRequested(),
                                    ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (state is! EmployeeAnalysisToolsSuccess) {
                  return const SizedBox.shrink();
                }
                final data = state.data;
                return Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.all(customSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: customSpacing.md),
                            _buildHeaderCard(customSpacing, data),
                            SizedBox(height: customSpacing.xl),
                            const Text(
                              'Analysis Tools',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: customSpacing.md),
                            _buildAnalysisToolCard(
                              'Text Analysis',
                              'Messages, emails & feedback',
                              Icons.text_fields,
                              const Color(0xFF06B6D4),
                              customSpacing,
                              0,
                            ),
                            SizedBox(height: customSpacing.md),
                            _buildAnalysisToolCard(
                              'Voice Analysis',
                              'Calls, recordings & audio',
                              Icons.mic,
                              const Color(0xFF10B981),
                              customSpacing,
                              1,
                            ),
                            SizedBox(height: customSpacing.md),
                            _buildAnalysisToolCard(
                              'Video Analysis',
                              'Customer videos & interviews',
                              Icons.videocam,
                              const Color(0xFF6366F1),
                              customSpacing,
                              2,
                            ),
                            SizedBox(height: customSpacing.xl),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    CustomSpacing spacing,
    EmployeeAnalysisToolsData data,
  ) {
    return Container(
      padding: EdgeInsets.all(spacing.lg),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(spacing.md),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3B82F6).withValues(alpha: 0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: const Icon(Icons.analytics, color: Colors.white, size: 32),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Analysis Tools',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  data.subtitle,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      '${data.toolCount} tools available',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnalysisToolCard(
    String title,
    String description,
    IconData icon,
    Color color,
    CustomSpacing spacing,
    int index,
  ) {
    return GestureDetector(
      onTap: () => _handleAnalysisToolTap(index),
      child: Container(
        padding: EdgeInsets.all(spacing.lg),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.all(spacing.sm),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.arrow_forward_ios, color: color, size: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _handleAnalysisToolTap(int screenIndex) {
    switch (screenIndex) {
      case 0:
        AppRouter.toTextAnalysis(context);
        break;
      case 1:
        AppRouter.toVoiceAnalysis(context);
        break;
      case 2:
        AppRouter.toVideoAnalysis(context);
        break;
      default:
        if (widget.onAnalysisToolSelected != null) {
          widget.onAnalysisToolSelected!(screenIndex);
        } else {
          _navigateToAnalysisFallback(screenIndex);
        }
    }
  }

  void _navigateToAnalysisFallback(int index) {
    try {
      Navigator.of(context).pop();
      if (Navigator.canPop(context)) {
        Navigator.of(context).pop(index);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Unable to navigate to analysis tool'),
          action: SnackBarAction(label: 'OK', onPressed: () {}),
        ),
      );
    }
  }
}
