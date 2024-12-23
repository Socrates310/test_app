import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart'; // Correct import
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io'; // Import dart:io to check platform

class FirstTimeLoginPage extends StatefulWidget {
  const FirstTimeLoginPage({super.key});

  @override
  State<FirstTimeLoginPage> createState() => _FirstTimeLoginPageState();
}

class _FirstTimeLoginPageState extends State<FirstTimeLoginPage> {
  final TextEditingController _nameController = TextEditingController();
  final deviceInfoPlugin = DeviceInfoPlugin();

  @override
  void initState() {
    super.initState();
    _getDeviceName();
  }

  // Fetch the device name and set it in the text field
  void _getDeviceName() async {
    String deviceName = 'User'; // Default value if device name is not available

    // Check if the platform is Android or iOS and fetch device info accordingly
    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceName = androidInfo.model;  // Default to 'User' if model is null
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceName = iosInfo.name;  // Default to 'User' if name is null
    }

    if (mounted) {
      _nameController.text = deviceName; // Set the fetched device name
    }
  }

  // Save the username and navigate to the home page
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
            builder: (context) => MyHomePage(title: 'ConnectX', userName: userName),
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
