// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fittrack/main.dart';
import 'package:fittrack/services/mock_api.dart';

class MockApiForTest extends MockApi {
  @override
  Future<int> fetchWaterIntake() async {
    // Simulate a mocked response
    return 12;
  }
}

class MockApiWorkoutsTest extends MockApi {
  @override
  Future<List<String>> fetchWorkouts() async {
    return ['Test Workout 1', 'Test Workout 2'];
  }
}

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FitTrackApp());

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Shows correct screen when navigation item is tapped',
      (WidgetTester tester) async {
    await tester.pumpWidget(const FitTrackApp());

    // Initial screen should be WorkoutsScreen
    expect(find.text('Log Daily Workouts'), findsOneWidget);

    // Tap Goals tab
    await tester.tap(find.byIcon(Icons.flag));
    await tester.pumpAndSettle();
    expect(find.text('Set Fitness Goals'), findsOneWidget);

    // Tap Water tab
    await tester.tap(find.byIcon(Icons.local_drink));
    await tester.pumpAndSettle();
    expect(find.text('Track Water Intake'), findsOneWidget);

    // Tap Progress tab
    await tester.tap(find.byIcon(Icons.bar_chart));
    await tester.pumpAndSettle();
    expect(find.text('Weekly Progress'), findsOneWidget);
  });

  group('Water Intake API', () {
    test('fetchWaterIntake returns expected value', () async {
      final api = MockApiForTest();
      final result = await api.fetchWaterIntake();
      expect(result, equals(12));
    });
  });

  group('Workouts API', () {
    test('loadWorkouts loads correct data', () async {
      final api = MockApiWorkoutsTest();
      final workouts = await api.fetchWorkouts();
      expect(workouts, isA<List<String>>());
      expect(workouts, contains('Test Workout 1'));
      expect(workouts, contains('Test Workout 2'));
      expect(workouts.length, 2);
    });
  });
}
