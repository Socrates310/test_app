import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'wifi_page.dart';
import 'chat_page.dart'; // Import ChatPage
import '../widgets/drawer.dart';
import '../services/wifi_manager.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<DiscoveredPeers> _discoveredPeers = [];
  final WiFiManager _wifiManager = WiFiManager();
  StreamSubscription<List<DiscoveredPeers>>? _peerStreamSubscription;

  @override
  void initState() {
    super.initState();
    _initializeWifiManager();
  }

  Future<void> _initializeWifiManager() async {
    await _wifiManager.initialize();
    _peerStreamSubscription = _wifiManager.streamPeers.listen((peers) {
      setState(() {
        _discoveredPeers = peers;
      });
    });
    await _wifiManager.startDiscovery();
  }

  @override
  void dispose() {
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
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _discoveredPeers.length,
              itemBuilder: (context, index) {
                final peer = _discoveredPeers[index];
                return ListTile(
                  title: Text(peer.deviceName),
                  subtitle: Text(peer.deviceAddress),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          deviceName: _discoveredPeers[index].deviceName ?? 'Unknown Device',
                          deviceAddress: _discoveredPeers[index].deviceAddress,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
      drawer: const CustomDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.35,
    );
  }
}
