import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/screens/homepage.dart'; // Correct the import to homepage.dart

void main() {
  testWidgets('Home page displays the correct title and welcome message', (WidgetTester tester) async {
    // Set up the MyHomePage widget with a sample userName and title
    await tester.pumpWidget(
      MaterialApp(
        home: MyHomePage(title: 'ConnectX', userName: 'Test User'), // Pass both title and userName
      ),
    );

    // Verify if the title and welcome message are displayed correctly
    expect(find.text('ConnectX'), findsOneWidget);
    expect(find.text('Welcome, Test User!'), findsOneWidget); // Check for the welcome message with the provided userName
  });
}
