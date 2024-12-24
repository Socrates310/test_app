import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'namechange.dart'; // Import the NameChangeDialog
import 'package:provider/provider.dart'; // Import provider package
import 'package:test_app/utils/theme_provider.dart'; // Import the ThemeProvider

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  CustomDrawerState createState() => CustomDrawerState();
}

class CustomDrawerState extends State<CustomDrawer> {
  String userName = "User"; // Initial default name

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  // Function to load username from SharedPreferences
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? 'User';
    });
  }

  // Function to show the NameChangeDialog
  Future<void> _changeUserName() async {
    showDialog(
      context: context,
      builder: (context) {
        return NameChangeDialog(
          currentUserName: userName,
          onNameChanged: (newUserName) {
            setState(() {
              userName = newUserName; // Update username in the drawer
            });
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Access the ThemeProvider to toggle the theme
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(userName), // Display current username
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: _changeUserName, // Open the dialog to change name
                ),
              ],
            ),
            accountEmail: null,
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.purple,
              child: Text(userName[0].toUpperCase(),
                  style: const TextStyle(color: Colors.white)),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context); // Handle settings navigation if needed
            },
          ),
          // Theme toggle button
          ListTile(
            leading: Icon(themeProvider.isDarkMode
                ? Icons.dark_mode
                : Icons.light_mode),
            title: Text(themeProvider.isDarkMode
                ? 'Switch to Light Mode'
                : 'Switch to Dark Mode'),
            onTap: () {
              // Toggle the theme mode using the ThemeProvider
              themeProvider.toggleTheme();
            },
          ),
        ],
      ),
    );
  }
}
