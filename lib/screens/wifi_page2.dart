import 'dart:io';

import 'package:flutter/material.dart';
//import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
//import 'dart:io';
import '../services/wifi_p2p_manager.dart';
import 'dart:async';// Import the WifiP2PManager singleton
import 'package:filesystem_picker/filesystem_picker.dart';

class WifiPage2 extends StatefulWidget {
  const WifiPage2({super.key});

  @override
  State<WifiPage2> createState() => _WifiPage2State();
}

class _WifiPage2State extends State<WifiPage2> {
  final TextEditingController msgText = TextEditingController();
  //final WifiP2PManager _wifiP2PManager = WifiP2PManager();
  WifiP2PInfo? wifiP2PInfo;
  List<DiscoveredPeers> peers = [];
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  @override
  void initState() {
    super.initState();
   // WifiP2PManager.instance.initialize();
    _init();
  }

  void _init() async {
    // Initialize the WifiP2PManager instance
    //await WifiP2PManager.instance.initialize();
    //await WifiP2PManager.instance.register();

    // Listen to WifiP2PInfo stream
    _streamWifiInfo = WifiP2PManager.instance.streamWifiP2PInfo().listen((event) {
      setState(() {
        wifiP2PInfo = event; // Assuming wifiP2PInfo is a member variable
      });
    });

    // Listen to discovered peers stream
    _streamPeers = WifiP2PManager.instance.streamPeers().listen((event) {
      setState(() {
        peers = event;
      });
    });
  }


  @override
  void dispose() {
    //WifiP2PManager.instance.closeSocketConnection();
    super.dispose();
  }

  Future startSocket() async {
    if (wifiP2PInfo != null) {
      bool started = await WifiP2PManager.instance.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {
          snack("$name connected to socket with address: $address");
        },
        transferUpdate: (transfer) {
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          snack(req);
        },
      );
      snack("open socket: $started");
    }
  }

  Future connectToSocket() async {
    if (wifiP2PInfo != null) {
      await WifiP2PManager.instance.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {
          snack("connected to socket: $address");
        },
        transferUpdate: (transfer) {
          // if (transfer.count == 0) transfer.cancelToken?.cancel();
          if (transfer.completed) {
            snack(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          snack(req);
        },
      );
    }
  }

  Future closeSocketConnection() async {
    bool closed = WifiP2PManager.instance.closeSocket();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "closed: $closed",
        ),
      ),
    );
  }

  Future sendMessage() async {
    WifiP2PManager.instance.sendStringToSocket(msgText.text);
  }

  Future sendFile(bool phone) async {
    String? filePath = await FilesystemPicker.open(
      context: context,
      rootDirectory: Directory(phone ? "/storage/emulated/0/" : "/storage/"),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      showGoUp: true,
      folderIconColor: Colors.blue,
    );
    if (filePath == null) return;
    List<TransferUpdate>? updates =
    await WifiP2PManager.instance.sendFiletoSocket(
      [
        filePath,
        // "/storage/emulated/0/Download/Likee_7100105253123033459.mp4",
        // "/storage/0E64-4628/Download/Adele-Set-Fire-To-The-Rain-via-Naijafinix.com_.mp3",
        // "/storage/0E64-4628/Flutter SDK/p2p_plugin.apk",
        // "/storage/emulated/0/Download/03 Omah Lay - Godly (NetNaija.com).mp3",
        // "/storage/0E64-4628/Download/Adele-Set-Fire-To-The-Rain-via-Naijafinix.com_.mp3",
      ],
    );
    print(updates);
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
                                  bool? bo = await WifiP2PManager.instance
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
                bool? isLocationEnabled = await WifiP2PManager.instance.checkLocationEnabled();
                snack(isLocationEnabled == true ? "Location is enabled" : "Location is disabled");
              },
              child: const Text("Check Location Enabled"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? isWifiEnabled = await WifiP2PManager.instance.checkWifiEnabled();
                snack(isWifiEnabled == true ? "Wi-Fi is enabled" : "Wi-Fi is disabled");
              },
              child: const Text("Check Wi-Fi Enabled"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool permissionGranted = await WifiP2PManager.instance.askLocationPermission();
                snack(permissionGranted ? "Location permission granted" : "Location permission denied");
              },
              child: const Text("Ask Location Permission"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool permissionGranted = await WifiP2PManager.instance.askStoragePermission();
                snack(permissionGranted ? "Storage permission granted" : "Storage permission denied");
              },
              child: const Text("Ask Storage Permission"),
            ),

            ElevatedButton(
              onPressed: () async {
                bool locationEnabled = await WifiP2PManager.instance.enableLocationServices();
                snack(locationEnabled ? "Location enabled" : "Failed to enable location");
              },
              child: const Text("Enable Location"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool wifiEnabled = await WifiP2PManager.instance.enableWifiServices();
                snack(wifiEnabled ? "Wi-Fi enabled" : "Failed to enable Wi-Fi");
              },
              child: const Text("Enable Wi-Fi"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? created = await WifiP2PManager.instance.createGroup();
                snack(created != null && created ? "Group created" : "Failed to create group");
              },
              child: const Text("Create Group"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? removed = await WifiP2PManager.instance.removeGroup();
                snack(removed != null && removed ? "Group removed/disconnected" : "Failed to remove group");
              },
              child: const Text("Remove Group/Disconnect"),
            ),
            ElevatedButton(
              onPressed: () async {
                var info = await WifiP2PManager.instance.groupInfo();
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
                String? ip = await WifiP2PManager.instance.getIPAddress();
                snack(ip != null ? 'IP: $ip' : 'Failed to get IP');
              },
              child: const Text("Get IP"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? discovering = await WifiP2PManager.instance.discover();
                snack(discovering != null && discovering ? 'Discovery started' : 'Discovery failed');
              },
              child: const Text("Discover"),
            ),
            ElevatedButton(
              onPressed: () async {
                bool? stopped = await WifiP2PManager.instance.stopDiscovery();
                snack(stopped != null && stopped ? 'Stopped discovery' : 'Failed to stop discovery');
              },
              child: const Text("Stop Discovery"),
            ),
            ElevatedButton(
              onPressed: () async {
                await startSocket();
              },
              child: const Text("Open a Socket"),
            ),
            ElevatedButton(
              onPressed: () async {
                await connectToSocket();
              },
              child: const Text("Connect to Socket"),
            ),
            ElevatedButton(
              onPressed: () async {
                await closeSocketConnection();
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
                sendMessage();
              },
              child: const Text("Send Message"),
            ),
            ElevatedButton(
              onPressed: () async {
                await sendFile(true);
              },
              child: const Text("Send File"),
            ),
            ElevatedButton(
              onPressed: () async {
                await sendFile(false);
              },
              child: const Text("send File"),
            ),
          ],
        ),
      ),
    );
  }
}
