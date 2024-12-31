import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'wifi_page.dart';  // Import WifiPage
import '../widgets/drawer.dart';  // Import CustomDrawer
import '../services/wifi_managerold.dart';  // Import WiFiManager for managing peers

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  // List of discovered peers
  List<DiscoveredPeers> _discoveredPeers = [];

  // WiFiManager instance
  final WiFiManager _wifiManager = WiFiManager();

  // StreamSubscription to manage the peers stream
  StreamSubscription<List<DiscoveredPeers>>? _peerStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeWifiManager();
  }

  // Initialize the WiFiManager and start discovering peers
  Future<void> _initializeWifiManager() async {
    await _wifiManager.initialize();

    // Listen to the discovered peers stream
    _peerStreamSubscription = _wifiManager.streamPeers.listen((peers) {
      setState(() {
        _discoveredPeers = peers;
      });
    });

    // Start discovering peers
    await _wifiManager.startDiscovery();
  }

  @override
  void dispose() {
    // Cancel the stream subscription when the widget is disposed
    _peerStreamSubscription?.cancel();
    _wifiManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi),
            onPressed: () async {
              // Navigate to WifiPage (optional functionality)
              final List<DiscoveredPeers> peers = await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WifiPage()),
              );
              setState(() {
                _discoveredPeers = peers;
              });
            },
          ),
        ],
      ),
      body: _discoveredPeers.isEmpty
          ? const Center(child: CircularProgressIndicator())  // Show loading spinner if no peers found
          : ListView.builder(
        itemCount: _discoveredPeers.length,
        itemBuilder: (context, index) {
          final peer = _discoveredPeers[index];
          return ListTile(
            title: Text(peer.deviceName),
            subtitle: Text(peer.deviceAddress),
            onTap: () {
              // Handle peer selection if needed
            },
          );
        },
      ),
      drawer: const CustomDrawer(),  // Include CustomDrawer
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.35,
    );
  }
}