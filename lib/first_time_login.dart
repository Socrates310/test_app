import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'my_home_page.dart';

class FirstTimeLoginPage extends StatefulWidget {
  const FirstTimeLoginPage({super.key});

  @override
  State<FirstTimeLoginPage> createState() => _FirstTimeLoginPageState();
}

class _FirstTimeLoginPageState extends State<FirstTimeLoginPage> {
  final TextEditingController _nameController = TextEditingController();

  Future<void> _saveUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userName', _nameController.text);
    await prefs.setBool('isFirstTime', false);

    // Navigate to home after saving
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const MyHomePage(title: 'ConnectX'),
        ),
      );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter your name for identification:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Your Name',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveUserName,
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }
}
