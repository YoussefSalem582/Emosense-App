// Basic smoke test: DI + root app render on the splash route.

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:emosense_mobile/app.dart';
import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/core/network/connection_manager.dart';

void main() {
  setUp(() async {
    await ConnectionManager.resetForTesting();
    await GetIt.instance.reset();
    await di.initDependencies();
  });

  tearDown(() async {
    await GetIt.instance.reset();
    await ConnectionManager.resetForTesting();
  });

  testWidgets('Emosense app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const EmosenseApp());
    await tester.pump();

    // Splash uses chained [Future.delayed] calls; drain them so no timers
    // outlive the test. Then onboarding is shown.
    await tester.pump(const Duration(seconds: 4));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Welcome to EmoSense'), findsOneWidget);
  });
}
