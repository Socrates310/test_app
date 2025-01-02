import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:filesystem_picker/filesystem_picker.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection_platform_interface.dart';

class WifiP2PManager {
  // Singleton instance
  WifiP2PManager._privateConstructor();

  // The single instance of WifiP2PManager
  static final WifiP2PManager _instance = WifiP2PManager._privateConstructor();

  // Instance of the flutter_p2p_connection plugin
  final FlutterP2pConnection _flutterP2pConnectionPlugin = FlutterP2pConnection();

  // Public getter to access the singleton instance
  static WifiP2PManager get instance => _instance;
  WifiP2PInfo? wifiP2PInfo;


  List<DiscoveredPeers> peers = [];
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  // Initialize the Wi-Fi P2P manager
  Future<void> initialize() async {
    await _flutterP2pConnectionPlugin.initialize();
    await _flutterP2pConnectionPlugin.register();
    _streamWifiInfo = _flutterP2pConnectionPlugin.streamWifiP2PInfo().listen((event) {
      wifiP2PInfo = event;
    });
    _streamPeers = _flutterP2pConnectionPlugin.streamPeers().listen((event) {
      peers = event;
    });
  }

  // Start a socket connection
  Future<void> startSocket() async {
    if (wifiP2PInfo != null) {
      bool started = await _flutterP2pConnectionPlugin.startSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 2,
        deleteOnError: true,
        onConnect: (name, address) {
          print("$name connected to socket with address: $address");
        },
        transferUpdate: (transfer) {
          if (transfer.completed) {
            print(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
          print(
              "ID: ${transfer.id}, FILENAME: ${transfer.filename}, PATH: ${transfer.path}, COUNT: ${transfer.count}, TOTAL: ${transfer.total}, COMPLETED: ${transfer.completed}, FAILED: ${transfer.failed}, RECEIVING: ${transfer.receiving}");
        },
        receiveString: (req) async {
          print(req);
        },
      );
      print("Socket started: $started");
    }
  }

  // Connect to a socket
  Future<void> connectToSocket() async {
    if (wifiP2PInfo != null) {
      await _flutterP2pConnectionPlugin.connectToSocket(
        groupOwnerAddress: wifiP2PInfo!.groupOwnerAddress,
        downloadPath: "/storage/emulated/0/Download/",
        maxConcurrentDownloads: 3,
        deleteOnError: true,
        onConnect: (address) {
          print("Connected to socket: $address");
        },
        transferUpdate: (transfer) {
          if (transfer.completed) {
            print(
                "${transfer.failed ? "failed to ${transfer.receiving ? "receive" : "send"}" : transfer.receiving ? "received" : "sent"}: ${transfer.filename}");
          }
        },
        receiveString: (req) async {
          print(req);
        },
      );
    }
  }

  // Close the socket connection
  Future<void> closeSocketConnection() async {
    bool closed = _flutterP2pConnectionPlugin.closeSocket();
    print("Socket closed: $closed");
  }

  // Send a message
  Future<void> sendMessage(String message) async {
    _flutterP2pConnectionPlugin.sendStringToSocket(message);
  }

  // Send a file
  Future<void> sendFile(bool phone, BuildContext context) async {
    String? filePath = await FilesystemPicker.open(
      context: context,  // Pass the BuildContext here
      rootDirectory: Directory(phone ? "/storage/emulated/0/" : "/storage/"),
      fsType: FilesystemType.file,
      fileTileSelectMode: FileTileSelectMode.wholeTile,
      showGoUp: true,
      folderIconColor: Colors.blue,
    );
    if (filePath == null) return;
    List<TransferUpdate>? updates =
    await _flutterP2pConnectionPlugin.sendFiletoSocket([filePath]);
    print(updates);
  }


  // Show a snack bar message
  void snack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        content: Text(msg),
      ),
    );
  }

  void register() => _flutterP2pConnectionPlugin.register();

  void unregister() => _flutterP2pConnectionPlugin.unregister();

  Future<bool?> createGroup() => _flutterP2pConnectionPlugin.createGroup();

  Future<bool?> removeGroup() => _flutterP2pConnectionPlugin.removeGroup();

  Future<String?> getIPAddress() => _flutterP2pConnectionPlugin.getIPAddress();

  Future<bool?> discover() => _flutterP2pConnectionPlugin.discover();

  Future<bool?> stopDiscovery() => _flutterP2pConnectionPlugin.stopDiscovery();

  Future<WifiP2PGroupInfo?> groupInfo() => _flutterP2pConnectionPlugin.groupInfo();

  Stream<List<DiscoveredPeers>> get peersStream => _flutterP2pConnectionPlugin.streamPeers();

  Stream<WifiP2PInfo> get wifiInfoStream => _flutterP2pConnectionPlugin.streamWifiP2PInfo();

  Future<bool?> checkWifiEnabled() => _flutterP2pConnectionPlugin.checkWifiEnabled();

  Future<bool?> checkLocationEnabled() => _flutterP2pConnectionPlugin.checkLocationEnabled();

  Future<bool> askLocationPermission() => _flutterP2pConnectionPlugin.askLocationPermission();

  Future<bool> askStoragePermission() async => await _flutterP2pConnectionPlugin.askStoragePermission();

  Future<bool> enableLocationServices() async => await _flutterP2pConnectionPlugin.enableLocationServices();

  Future<bool> enableWifiServices() async => await _flutterP2pConnectionPlugin.enableWifiServices();

  Future<bool> connect(String address) async => await FlutterP2pConnectionPlatform.instance.connect(address) == true;

}

