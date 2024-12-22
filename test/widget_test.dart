import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart'; // Adjust the import if needed

void main() {
  testWidgets('Home page displays the correct title', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp(isFirstTime: false)); // Pass `isFirstTime` if required.

    // Verify that the home page title is displayed.
    expect(find.text('ConnectX'), findsOneWidget);

    // Verify that the default body text is displayed.
    expect(find.text('Home Screen'), findsOneWidget);
  });
}
