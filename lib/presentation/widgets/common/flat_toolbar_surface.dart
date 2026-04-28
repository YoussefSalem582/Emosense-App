import 'package:flutter/material.dart';

import 'surface_section_card.dart';

/// Full-width white strip with a light bottom shadow, used under app bars on
/// analytics dashboards (replaces duplicate [Container] + [BoxDecoration]).
class FlatToolbarSurface extends StatelessWidget {
  const FlatToolbarSurface({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
  });

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return SurfaceSectionCard(
      margin: EdgeInsets.zero,
      padding: padding,
      borderRadiusOverride: 0,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
      child: child,
    );
  }
}
