import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/first_time_login.dart';
import 'screens/homepage.dart'; // Correct import

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isFirstTime = prefs.getBool('isFirstTime') ?? true;
  String userName = prefs.getString('userName') ?? 'User';

  runApp(MyApp(isFirstTime: isFirstTime, userName: userName));
}

class MyApp extends StatelessWidget {
  final bool isFirstTime;
  final String userName;

  const MyApp({super.key, required this.isFirstTime, required this.userName});

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
      home: isFirstTime
          ? const FirstTimeLoginPage()
          : MyHomePage(title: 'ConnectX', userName: userName), // Pass userName
    );
  }
}
