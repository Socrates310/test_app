import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'namechange.dart'; // Correct import path to match actual location

class MyHomePage extends StatefulWidget {
  final String title;
  final String userName;

  const MyHomePage({super.key, required this.title, required this.userName});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late String _userName;

  @override
  void initState() {
    super.initState();
    _userName = widget.userName;
  }

  void _changeUserName() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return NameChangeDialog(currentUserName: _userName); // Using NameChangeDialog here
      },
    ).then((_) {
      _loadUserName();
    });
  }

  Future<void> _loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(child: Text('Welcome, $_userName!')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              accountName: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_userName),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: _changeUserName,
                  ),
                ],
              ),
              accountEmail: null,
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.purple,
                child: Text(_userName[0].toUpperCase(), style: const TextStyle(color: Colors.white)),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
