import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';  // Import audioplayers package
import 'package:shared_preferences/shared_preferences.dart';  // For loading the saved name

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;  // Index for bottom navigation bar
  late AudioPlayer _audioPlayer;  // Declare AudioPlayer
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();  // Initialize the AudioPlayer here
    _loadUserName();  // Load the username from shared preferences
  }

  // Load name from SharedPreferences
  void _loadUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('userName') ?? 'User';
    });
  }

  // Handle bottom navigation item taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Play sound on tap
    _audioPlayer.play(AssetSource('assets/sounds/tap_sound.mp3'));  // Play sound from assets
  }

  // Get the body content based on selected index
  Widget _getBodyContent() {
    if (_selectedIndex == 0) {
      return Center(child: Text('Welcome, $_userName!'));  // Show the username
    } else {
      return const Center(child: Text('Under Development'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _getBodyContent(),  // Use the function to get the body content
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,  // Handle item taps
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
