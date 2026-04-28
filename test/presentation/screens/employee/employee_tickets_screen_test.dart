import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';

import 'package:emosense_mobile/core/core.dart';
import 'package:emosense_mobile/core/di/dependency_injection.dart' as di;
import 'package:emosense_mobile/core/network/connection_manager.dart';
import 'package:emosense_mobile/features/tickets/presentation/bloc/tickets_bloc.dart';
import 'package:emosense_mobile/features/tickets/presentation/employee/employee_tickets_screen.dart';

/// Pumps the screen; avoids [pumpAndSettle] because of repeating animations.
Future<void> pumpTicketsScreen(WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(extensions: const [CustomSpacing()]),
      home: BlocProvider(
        create: (_) => di.sl<TicketsBloc>(),
        child: const EmployeeTicketsScreen(),
      ),
    ),
  );
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 500));
}

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

  group('EmployeeTicketsScreen', () {
    testWidgets('shows header, filters, and employee tickets from bloc',
        (tester) async {
      await pumpTicketsScreen(tester);

      expect(find.text('My Support Tickets'), findsOneWidget);
      expect(find.text('Total Tickets: 3'), findsOneWidget);
      expect(find.text('New Ticket'), findsOneWidget);

      expect(find.text('All (3)'), findsOneWidget);
      expect(find.text('Open (2)'), findsOneWidget);
      expect(find.text('In Progress (1)'), findsOneWidget);
      expect(find.text('Resolved (0)'), findsOneWidget);

      // Newest-first order: EMP-003, EMP-001, then EMP-002 (scroll to see).
      expect(find.text('EMP-003'), findsOneWidget);
      expect(find.text('Account Access Issue'), findsOneWidget);
      expect(find.text('EMP-001'), findsOneWidget);
      expect(find.text('Product Quality Issue'), findsOneWidget);

      await tester.drag(
        find.byWidgetPredicate(
          (w) => w is ListView && w.scrollDirection == Axis.vertical,
        ),
        const Offset(0, -400),
      );
      await tester.pump();
      expect(find.text('EMP-002'), findsOneWidget);
      expect(find.text('Shipping Delay Inquiry'), findsOneWidget);
    });

    testWidgets('filters tickets by status chips', (tester) async {
      await pumpTicketsScreen(tester);

      expect(find.text('EMP-003'), findsOneWidget);
      expect(find.text('EMP-001'), findsOneWidget);

      await tester.tap(find.text('Open (2)'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('EMP-003'), findsOneWidget);
      expect(find.text('EMP-001'), findsOneWidget);
      expect(find.text('EMP-002'), findsNothing);

      await tester.tap(find.text('In Progress (1)'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('EMP-002'), findsOneWidget);
      expect(find.text('EMP-001'), findsNothing);
      expect(find.text('EMP-003'), findsNothing);

      await tester.tap(find.text('Resolved (0)'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('EMP-001'), findsNothing);
      expect(find.text('EMP-002'), findsNothing);
      expect(find.text('EMP-003'), findsNothing);
    });

    testWidgets('opens create ticket dialog', (tester) async {
      await pumpTicketsScreen(tester);

      await tester.tap(find.text('New Ticket'));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('New Support Ticket'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Create Ticket'), findsOneWidget);
      expect(find.byType(TextFormField), findsWidgets);
    });
  });
}
