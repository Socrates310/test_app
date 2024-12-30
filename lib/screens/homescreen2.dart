import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'wifi_page.dart'; // Import the Wi-Fi Page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  @override
  void dispose() {
    _streamPeers?.cancel();
    super.dispose();
  }

  void _initialize() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      setState(() {
        peers = event;
      });
    });
    // Start discovering peers when the page loads
    _flutterP2pConnectionPlugin.discover();
  }

  void _connectToPeer(DiscoveredPeers peer) async {
    bool? connected =
    await _flutterP2pConnectionPlugin.connect(peer.deviceAddress);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(connected == true
            ? 'Connected to ${peer.deviceName}'
            : 'Failed to connect to ${peer.deviceName}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Devices'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _flutterP2pConnectionPlugin.discover();
            },
          ),
          IconButton(
            icon: const Icon(Icons.wifi),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const WifiPage()),
              );
            },
          ),
        ],
      ),
      body: peers.isEmpty
          ? const Center(
        child: Text('No devices found. Searching...'),
      )
          : ListView.builder(
        itemCount: peers.length,
        itemBuilder: (context, index) {
          final peer = peers[index];
          return ListTile(
            title: Text(peer.deviceName ?? 'Unknown Device'),
            subtitle: Text(peer.deviceAddress),
            trailing: ElevatedButton(
              onPressed: () => _connectToPeer(peer),
              child: const Text('Connect'),
            ),
          );
        },
      ),
    );
  }
}
