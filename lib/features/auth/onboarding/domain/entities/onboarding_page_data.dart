import 'package:flutter/material.dart';

/// Single slide content for onboarding (UI-neutral value object).
class OnboardingPageData {
  const OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final String title;
  final String description;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
}
