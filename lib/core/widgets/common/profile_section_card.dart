import 'package:flutter/material.dart';

import 'surface_section_card.dart';

/// Frosted profile panel — replaces `Card` + inner [BoxDecoration] used across
/// employee profile sections.
class ProfileSectionCard extends StatelessWidget {
  const ProfileSectionCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SurfaceSectionCard(
      padding: const EdgeInsets.all(20),
      elevation: SurfaceElevation.soft,
      color: Colors.white.withValues(alpha: 0.9),
      border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1),
      child: child,
    );
  }
}
