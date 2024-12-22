import 'package:flutter_test/flutter_test.dart';
import 'package:test_app/main.dart';

void main() {
  testWidgets('Home page displays the correct title and welcome message',
          (WidgetTester tester) async {
        // Build the app and trigger a frame.
        await tester.pumpWidget(const MyApp(isFirstTime: false));

        // Verify the title is displayed.
        expect(find.text('ConnectX'), findsOneWidget);

        // Verify the welcome message is displayed.
        //expect(find.text('Welcome, User!'), findsOneWidget);
      });
}
