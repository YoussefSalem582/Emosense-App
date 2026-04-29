import 'package:flutter/material.dart';

import 'package:emosense_mobile/core/widgets/backend_connection_test.dart';

/// Developer-style API checks (named route [AppRouter.testBackend]).
class TestBackendScreen extends StatelessWidget {
  const TestBackendScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Test backend')),
      body: const SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: BackendConnectionTest(),
        ),
      ),
    );
  }
}
