import 'package:flutter/material.dart';
import 'package:emosense_mobile/core/core.dart';

import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/features/employee/analysis_tools/domain/entities/employee_analysis_tools_overview.dart';
import 'package:emosense_mobile/features/employee/analysis_tools/domain/repositories/employee_analysis_tools_repository.dart';

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

  EmployeeAnalysisToolsOverview? _overview;
  bool _loadingOverview = true;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    _backgroundController.repeat();
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadOverview());
  }

  Future<void> _loadOverview() async {
    setState(() => _loadingOverview = true);
    try {
      final o = await di.sl<EmployeeAnalysisToolsRepository>().fetchOverview();
      if (mounted) {
        setState(() {
          _overview = o;
          _loadingOverview = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _overview = null;
          _loadingOverview = false;
        });
      }
    }
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
          // Animated Background with gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF6366F1), // Primary purple
                  Color(0xFF8B5CF6), // Secondary purple
                  Color(0xFF06B6D4), // Cyan at bottom
                ],
              ),
            ),
          ),

          // Main Content
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child:
                      _loadingOverview
                          ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.white,
                            ),
                          )
                          : _overview == null
                          ? Center(
                            child: Padding(
                              padding: EdgeInsets.all(customSpacing.lg),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.error_outline,
                                    color: Colors.white.withValues(alpha: 0.9),
                                    size: 48,
                                  ),
                                  SizedBox(height: customSpacing.md),
                                  Text(
                                    'Could not load analysis tools',
                                    style: AppFonts.bodyMedium(
                                      color: AppColors.white,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  SizedBox(height: customSpacing.md),
                                  ElevatedButton(
                                    onPressed: _loadOverview,
                                    child: const Text('Retry'),
                                  ),
                                ],
                              ),
                            ),
                          )
                          : SingleChildScrollView(
                            padding: EdgeInsets.all(customSpacing.md),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: customSpacing.md),

                                // Header Card
                                _buildHeaderCard(customSpacing, _overview!),

                                SizedBox(height: customSpacing.xl),

                                // Section Title
                                Text(
                                  'Analysis Tools',
                                  style: AppFonts.copyWith(
                                    AppFonts.h5(color: AppColors.white),
                                    fontWeight: AppFonts.bold,
                                  ),
                                ),

                                SizedBox(height: customSpacing.md),

                                // Analysis Tools Cards
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderCard(
    CustomSpacing spacing,
    EmployeeAnalysisToolsOverview overview,
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
          // Icon container
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
            child: Icon(Icons.analytics, color: AppColors.white, size: 32),
          ),

          SizedBox(width: spacing.md),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Analysis Tools',
                  style: AppFonts.copyWith(
                    AppFonts.h6(color: AppColors.white),
                    fontWeight: AppFonts.bold,
                  ),
                ),
                SizedBox(height: spacing.xs),
                Text(
                  overview.subtitle,
                  style: AppFonts.copyWith(
                    AppFonts.bodySmall(
                      color: AppColors.white.withValues(alpha: 0.7),
                    ),
                    height: AppFonts.lineHeightNormal,
                  ),
                ),
                SizedBox(height: spacing.sm),
                // Status indicator
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: spacing.xs),
                    Text(
                      '${overview.toolCount} tools available',
                      style: AppFonts.copyWith(
                        AppFonts.caption(color: AppColors.success),
                        fontWeight: AppFonts.medium,
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
            // Icon container
            Container(
              padding: EdgeInsets.all(spacing.md),
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: AppColors.white, size: 24),
            ),

            SizedBox(width: spacing.md),

            // Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppFonts.copyWith(
                      AppFonts.button(color: AppColors.textPrimary),
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    description,
                    style: AppFonts.copyWith(
                      AppFonts.bodySmall(color: AppColors.textSecondary),
                      height: AppFonts.lineHeightNormal,
                    ),
                  ),
                ],
              ),
            ),

            // Arrow icon
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
      case 0: // Text Analysis
        AppRouter.toTextAnalysis(context);
        break;
      case 1: // Voice Analysis
        AppRouter.toVoiceAnalysis(context);
        break;
      case 2: // Video Analysis
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
