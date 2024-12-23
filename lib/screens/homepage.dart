import 'package:flutter/material.dart';
import 'package:test_app/widgets/drawer.dart'; // Import custom drawer

class MyHomePage extends StatelessWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child: const Text('Welcome!')), // Simplified welcome text
      drawer: const CustomDrawer(), // CustomDrawer handles the username change
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.3, // Set swipe range to 30% of the screen width
    );
  }
}



