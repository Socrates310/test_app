import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'dart:io';
import '../services/wifi_p2p_manager.dart'; // Import the WifiP2PManager singleton

class WifiPage2 extends StatefulWidget {
  const WifiPage2({super.key});

  @override
  State<WifiPage2> createState() => _WifiPage2State();
}

class _WifiPage2State extends State<WifiPage2> {
  final TextEditingController msgText = TextEditingController();
  final WifiP2PManager _wifiP2PManager = WifiP2PManager();
  WifiP2PInfo? wifiP2PInfo;
  List<DiscoveredPeers> peers = [];
  //StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  //StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  @override
  void initState() {
    super.initState();
    _wifiP2PManager.initialize();
  }

  @override
  void dispose() {
    _wifiP2PManager.closeSocketConnection();
    super.dispose();
  }

  void snack(String msg) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(
          msg,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wifi Direct Connection')),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
                "IP: ${wifiP2PInfo == null ? "null" : wifiP2PInfo?.groupOwnerAddress}"),
            wifiP2PInfo != null
                ? Text(
                "connected: ${wifiP2PInfo?.isConnected}, isGroupOwner: ${wifiP2PInfo?.isGroupOwner}, groupFormed: ${wifiP2PInfo?.groupFormed}, groupOwnerAddress: ${wifiP2PInfo?.groupOwnerAddress}, clients: ${wifiP2PInfo?.clients}")
                : const SizedBox.shrink(),
            const SizedBox(height: 10),
            const Text("PEERS:"),
            SizedBox(
              height: 100,
              width: MediaQuery.of(context).size.width,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: peers.length,
                itemBuilder: (context, index) => Center(
                  child: GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Center(
                          child: AlertDialog(
                            content: SizedBox(
                              height: 200,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("name: ${peers[index].deviceName}"),
                                  Text(
                                      "address: ${peers[index].deviceAddress}"),
                                  Text(
                                      "isGroupOwner: ${peers[index].isGroupOwner}"),
                                  Text(
                                      "isServiceDiscoveryCapable: ${peers[index].isServiceDiscoveryCapable}"),
                                  Text(
                                      "primaryDeviceType: ${peers[index].primaryDeviceType}"),
                                  Text(
                                      "secondaryDeviceType: ${peers[index].secondaryDeviceType}"),
                                  Text("status: ${peers[index].status}"),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  Navigator.of(context).pop();
                                  bool? bo = await _wifiP2PManager
                                      .connect(peers[index].deviceAddress);
                                  snack("connected: $bo");
                                },
                                child: const Text("connect"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Center(
                        child: Text(
                          peers[index]
                              .deviceName
                              .toString()
                              .characters
                              .first
                              .toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? isLocationEnabled = await _wifiP2PManager.checkLocationEnabled();
                snack(isLocationEnabled == true ? "Location is enabled" : "Location is disabled");
              },
              child: const Text("Check Location Enabled"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? isWifiEnabled = await _wifiP2PManager.checkWifiEnabled();
                snack(isWifiEnabled == true ? "Wi-Fi is enabled" : "Wi-Fi is disabled");
              },
              child: const Text("Check Wi-Fi Enabled"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool permissionGranted = await _wifiP2PManager.askLocationPermission();
                snack(permissionGranted ? "Location permission granted" : "Location permission denied");
              },
              child: const Text("Ask Location Permission"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool permissionGranted = await _wifiP2PManager.askStoragePermission();
                snack(permissionGranted ? "Storage permission granted" : "Storage permission denied");
              },
              child: const Text("Ask Storage Permission"),
            ),

            ElevatedButton(
              onPressed: () async {
                bool locationEnabled = await _wifiP2PManager.enableLocationServices();
                snack(locationEnabled ? "Location enabled" : "Failed to enable location");
              },
              child: const Text("Enable Location"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool wifiEnabled = await _wifiP2PManager.enableWifiServices();
                snack(wifiEnabled ? "Wi-Fi enabled" : "Failed to enable Wi-Fi");
              },
              child: const Text("Enable Wi-Fi"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? created = await _wifiP2PManager.createGroup();
                snack(created != null && created ? "Group created" : "Failed to create group");
              },
              child: const Text("Create Group"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? removed = await _wifiP2PManager.removeGroup();
                snack(removed != null && removed ? "Group removed/disconnected" : "Failed to remove group");
              },
              child: const Text("Remove Group/Disconnect"),
            ),
            ElevatedButton(
              onPressed: () async {
                var info = await _wifiP2PManager.groupInfo();
                showDialog(
                  context: context,
                  builder: (context) => Center(
                    child: Dialog(
                      child: SizedBox(
                        height: 200,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("groupNetworkName: ${info?.groupNetworkName}"),
                              Text("passPhrase: ${info?.passPhrase}"),
                              Text("isGroupOwner: ${info?.isGroupOwner}"),
                              Text("clients: ${info?.clients}"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              child: const Text("Get Group Info"),
            ),
            ElevatedButton(
              onPressed: () async {
                String? ip = await _wifiP2PManager.getIPAddress();
                snack(ip != null ? 'IP: $ip' : 'Failed to get IP');
              },
              child: const Text("Get IP"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? discovering = await _wifiP2PManager.discover();
                snack(discovering != null && discovering ? 'Discovery started' : 'Discovery failed');
              },
              child: const Text("Discover"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? stopped = await _wifiP2PManager.stopDiscovery();
                snack(stopped != null && stopped ? 'Stopped discovery' : 'Failed to stop discovery');
              },
              child: const Text("Stop Discovery"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _wifiP2PManager.startSocket();
              },
              child: const Text("Open a Socket"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _wifiP2PManager.connectToSocket();
              },
              child: const Text("Connect to Socket"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _wifiP2PManager.closeSocketConnection();
              },
              child: const Text("Close Socket"),
            ),
            TextField(
              controller: msgText,
              decoration: const InputDecoration(
                hintText: "message",
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                await _wifiP2PManager.sendMessage(msgText.text);
              },
              child: const Text("Send Message"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _wifiP2PManager.sendFile(true,context);
              },
              child: const Text("Send File"),
            ),
            ElevatedButton(
              onPressed: () async {
                await _wifiP2PManager.sendFile(false,context);
              },
              child: const Text("send File"),
            ),
          ],
        ),
      ),
    );
  }
}
