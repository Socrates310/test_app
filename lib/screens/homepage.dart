import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'wifi_page.dart'; // Import the Wi-Fi Page
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _flutterP2pConnectionPlugin = FlutterP2pConnection();
  List<DiscoveredPeers> peers = [];
  List<DiscoveredPeers> connectedDevices = []; // List of connected devices
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
    if (connected == true) {
      setState(() {
        connectedDevices.add(peer); // Add to connected devices list
      });
    }
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
      body: Column(
        children: [
          // Displaying the list of discovered peers
          peers.isEmpty
              ? const Center(
                  child: Text('No devices found. Searching...'),
                )
              : ListView.builder(
                  shrinkWrap: true, // Makes the list take only the space it needs
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
          const SizedBox(height: 20), // Adds space between sections
          const Text(
            'Chats', // Title for the chats section
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          connectedDevices.isEmpty
              ? const Center(
                  child: Text('No connected devices.'),
                )
              : SizedBox(
                  height: 200, // Adjust the height as needed
                  width: MediaQuery.of(context).size.width, // Full width of the screen
                  child: ListView.builder(
                    itemCount: connectedDevices.length,
                    itemBuilder: (context, index) {
                      final device = connectedDevices[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.grey, // Placeholder for device avatar
                          child: Text(
                            device.deviceName?[0].toUpperCase() ?? 'U', // First letter of device name
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        title: Text(device.deviceName ?? 'Unknown Device'), // Device name
                        subtitle: Text(device.deviceAddress), // Device address
                        onTap: () {
                          // Implement navigation to the ChatPage
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                deviceName: connectedDevices[index].deviceName ?? 'Unknown Device',
                                deviceAddress: connectedDevices[index].deviceAddress,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
