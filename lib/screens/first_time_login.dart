import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart'; // Correct import

class FirstTimeLoginPage extends StatefulWidget {
  const FirstTimeLoginPage({super.key});

  @override
  State<FirstTimeLoginPage> createState() => _FirstTimeLoginPageState();
}

class _FirstTimeLoginPageState extends State<FirstTimeLoginPage> {
  final TextEditingController _nameController = TextEditingController();

  void _saveUserName() async {
    final String userName = _nameController.text;
    if (userName.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userName', userName);
      await prefs.setBool('isFirstTime', false);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MyHomePage(title: 'ConnectX', userName: userName), // Pass userName to MyHomePage
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('First Time Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              'Please enter your name:',
              style: TextStyle(fontSize: 18),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Your Name'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserName,
              child: const Text('Save and Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
