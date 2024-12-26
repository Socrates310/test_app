import 'package:flutter/material.dart';
import '../widgets/drawer.dart';
import 'wifi_page.dart'; // Import WifiPage

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi),
            onPressed: () {
              // Navigate to WifiPage
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WifiPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Welcome to ${widget.title}!',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.35,
    );
  }
}
