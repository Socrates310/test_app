import 'package:flutter/material.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'wifi_page.dart';  // Import WifiPage
import '../widgets/drawer.dart';  // Import CustomDrawer

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late List<DiscoveredPeers> _discoveredPeers = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.wifi),
            onPressed: () async {
              // Navigate to WifiPage and await result (discovered peers)
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
          ? const Center(child: Text('No devices found.'))
          : ListView.builder(
        itemCount: _discoveredPeers.length,
        itemBuilder: (context, index) {
          final peer = _discoveredPeers[index];
          return ListTile(
            title: Text(peer.deviceName),
            subtitle: Text(peer.deviceAddress),
          );
        },
      ),
      drawer: const CustomDrawer(),  // Include CustomDrawer
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.35,
    );
  }
}
