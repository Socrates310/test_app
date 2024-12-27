import 'package:flutter/material.dart';
import '../services/wifi_manager.dart';

class WifiPage extends StatefulWidget {
  const WifiPage({super.key});

  @override
  State<WifiPage> createState() => _WifiPageState();
}

class _WifiPageState extends State<WifiPage> {
  final WiFiManager _wifiManager = WiFiManager();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WiFi Page")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await _wifiManager.startDiscovery();
            },
            child: const Text("Start Discovery"),
          ),
          ElevatedButton(
            onPressed: () async {
              await _wifiManager.stopDiscovery();
            },
            child: const Text("Stop Discovery"),
          ),
          Text(
            "Group Owner Address: ${_wifiManager.wifiP2PInfo?.groupOwnerAddress ?? 'N/A'}",
          ),
          Text("Discovered Peers: ${_wifiManager.peers.length}"),
        ],
      ),
    );
  }
}
