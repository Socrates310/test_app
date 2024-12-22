import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'first_time_login.dart';
import 'home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  // Check if the app is launched for the first time
  final bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(const MyApp(isFirstTime: true));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ConnectX',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          elevation: 0,
        ),
        useMaterial3: true,
        textTheme: const TextTheme(
          bodyMedium: TextStyle(fontSize: 16, fontFamily: 'Roboto'),
        ),
      ),
      // Navigate to the appropriate page based on the first-time flag
      home: isFirstTime ? const FirstTimeLoginPage() : const MyHomePage(title: 'ConnectX'),
    );
  }
}
