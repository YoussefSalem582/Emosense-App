import 'package:flutter/material.dart';

/// Named shadow/radius combinations used by analysis and settings sections.
enum SurfaceElevation {
  /// Subtle card (quick actions, history, [AnalysisInputWidget]).
  soft,
  /// Text analysis settings chip card.
  settings,
  /// Result summary panels with 16px corners.
  result,
  /// Text/video/templates panels with 20px corners and deeper shadow.
  textPanel,
}

/// White elevated surface shared across section cards to avoid duplicated
/// [BoxDecoration]s.
class SurfaceSectionCard extends StatelessWidget {
  const SurfaceSectionCard({
    super.key,
    required this.child,
    this.margin,
    this.padding,
    this.elevation = SurfaceElevation.soft,
    this.borderRadiusOverride,
    this.color,
  });

  final Widget child;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final SurfaceElevation elevation;
  final double? borderRadiusOverride;
  final Color? color;

  double _radius() {
    if (borderRadiusOverride != null) return borderRadiusOverride!;
    switch (elevation) {
      case SurfaceElevation.textPanel:
        return 20;
      case SurfaceElevation.soft:
      case SurfaceElevation.settings:
      case SurfaceElevation.result:
        return 16;
    }
  }

  List<BoxShadow> _shadows() {
    switch (elevation) {
      case SurfaceElevation.soft:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ];
      case SurfaceElevation.settings:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ];
      case SurfaceElevation.result:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ];
      case SurfaceElevation.textPanel:
        return [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(_radius()),
        boxShadow: _shadows(),
      ),
      child: child,
    );
  }
}
