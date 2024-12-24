import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider with ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  // Constructor to load theme from SharedPreferences
  ThemeProvider() {
    _loadThemePreference();
  }

  // Load the saved theme preference
  Future<void> _loadThemePreference() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  // Toggle theme and save the preference
  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode); // Save the theme preference
    notifyListeners();
  }
}
