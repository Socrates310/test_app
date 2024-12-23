import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final String userName; // Add userName as a parameter

  const MyHomePage({super.key, required this.title, required this.userName}); // Accept userName

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: Text('Welcome, ${widget.userName}!')), // Display the userName
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(widget.userName),
              accountEmail: null, // Removed email display for simplicity
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Text(widget.userName[0].toUpperCase(), style: TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {
                // Implement navigation to settings page
                Navigator.pop(context); // Close the drawer
              },
            ),
          ],
        ),
      ),
    );
  }
}
