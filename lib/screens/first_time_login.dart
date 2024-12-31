import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'homepageold.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';


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

  void _getDeviceName() async {
    String deviceName = 'User'; // Default value if device name is not available

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
            builder: (context) => const MyHomePage(title: "ConnectX"),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFEFEFEF)], // Subtle gray gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Please enter your name:',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontFamily: 'Roboto',
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Your Name',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _saveUserName,
                  child: Text(
                    'Save and Continue',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.normal,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

