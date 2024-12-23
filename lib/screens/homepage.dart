import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/widgets/namechange.dart'; // Correct import path to match actual location
import 'drawer.dart'; // Import the custom drawer

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
      drawer: CustomDrawer(
        userName: _userName,
        onChangeUserName: _changeUserName, // Passing the function to handle name change
      ),
    );
  }
}
