import 'package:flutter/material.dart';

class BackendConnectionWidget extends StatelessWidget {
  final Widget child;
  
  const BackendConnectionWidget({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return child; // Simply return the child widget for now
    // You can add connection monitoring logic here if needed
  }

}
