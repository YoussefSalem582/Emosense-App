import 'package:flutter/material.dart';

class BackendConnectionWidget extends StatelessWidget {
  final Widget child;

  const BackendConnectionWidget({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return child; // Simply return the child widget for now
    // You can add connection monitoring logic here if needed
  }
}
