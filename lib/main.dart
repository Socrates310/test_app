import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/screens/homepage.dart';
import 'screens/first_time_login.dart';
import 'provider/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //await WiFiManager().initialize();
  // Load shared preferences and first-time login check
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;

  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(), // Provide ThemeProvider to the widget tree
      child: MyApp(isFirstTime: isFirstTime),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;

  const MyApp({super.key, required this.isFirstTime});

  @override
  Widget build(BuildContext context) {
    // Get the current theme state from ThemeProvider
    final themeProvider = Provider.of<ThemeProvider>(context);

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
      darkTheme: ThemeData.dark(), // Optionally define a dark theme
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Apply theme globally
      home: isFirstTime
          ? const FirstTimeLoginPage()
          //: const MyHomePage(title: 'ConnectX'),
          : HomePage(),
    );
  }
}

