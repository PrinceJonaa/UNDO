// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import for mocking

import 'package:undo_app/main.dart';

void main() {
  // Test group for HomeScreen related tests
  group('HomeScreen Tests', () {
    // Set up mock SharedPreferences values before each test
    setUp(() {
      // Mock SharedPreferences to simulate that the button is enabled initially
      // (i.e., no recent submission timestamp exists)
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('HomeScreen displays initial UI elements', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Allow time for SharedPreferences to load in initState
      await tester.pumpAndSettle();

      // Verify the AppBar title is displayed.
      expect(find.widgetWithText(AppBar, 'UNDO'), findsOneWidget);

      // Verify the main button text is displayed (assuming it's enabled initially).
      // Note: This might be 'Come back tomorrow' if SharedPreferences mock indicated a recent submission.
      expect(find.widgetWithText(ElevatedButton, 'Release a Moment'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Come back tomorrow'), findsNothing);


      // Verify the settings icon is present in the AppBar actions.
      expect(find.byIcon(Icons.settings), findsOneWidget);

      // Verify no counter text from the old template exists.
      expect(find.text('0'), findsNothing);
      expect(find.text('1'), findsNothing);
    });

     testWidgets('HomeScreen shows disabled button if submission was recent', (WidgetTester tester) async {
      // Mock SharedPreferences to simulate a recent submission
      final now = DateTime.now();
      final recentTimestamp = now.subtract(const Duration(hours: 1)).millisecondsSinceEpoch;
      SharedPreferences.setMockInitialValues({
        'last_submission_timestamp': recentTimestamp,
      });

      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Allow time for SharedPreferences to load in initState
      await tester.pumpAndSettle();

      // Verify the button shows the disabled text.
      expect(find.widgetWithText(ElevatedButton, 'Come back tomorrow'), findsOneWidget);
      expect(find.widgetWithText(ElevatedButton, 'Release a Moment'), findsNothing);

      // Verify the settings icon is still present.
      expect(find.byIcon(Icons.settings), findsOneWidget);
    });

    // TODO: Add more tests for navigation, settings modal, etc.
  });
}
