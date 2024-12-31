import 'dart:async';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

class WiFiManager {
  // Singleton instance
  static final WiFiManager _instance = WiFiManager._internal();

  // Private constructor
  WiFiManager._internal();

  // Factory method for singleton
  factory WiFiManager() {
    return _instance;
  }

  // Flutter P2P Connection instance
  final FlutterP2pConnection _p2pConnection = FlutterP2pConnection();

  // WiFi P2P state variables
  WifiP2PInfo? wifiP2PInfo;
  List<DiscoveredPeers> peers = [];
  bool isDiscovering = false;

  // Stream controllers
  final StreamController<List<DiscoveredPeers>> _peersController = StreamController.broadcast();

  // Stream to provide discovered peers
  Stream<List<DiscoveredPeers>> get streamPeers => _peersController.stream;

  // Stream subscriptions
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  /// Initialize the WiFi Direct manager
  Future<void> initialize() async {
    await _p2pConnection.initialize();
    await _p2pConnection.register();

    // Listen to WiFi P2P info stream
    _streamWifiInfo = _p2pConnection.streamWifiP2PInfo().listen((info) {
      wifiP2PInfo = info;
      print("WiFiP2PInfo updated: $info");
    });

    // Listen to discovered peers stream
    _streamPeers = _p2pConnection.streamPeers().listen((discoveredPeers) {
      peers = discoveredPeers;
      _peersController.add(peers); // Emit the updated list of peers
      print("Discovered peers updated: $peers");
    });
  }

  /// Start discovery of peers
  Future<void> startDiscovery() async {
    try {
      isDiscovering = await _p2pConnection.discover();
      print("Discovery started: $isDiscovering");
    } catch (e) {
      print("Error starting discovery: $e");
    }
  }

  /// Stop discovery of peers
  Future<void> stopDiscovery() async {
    try {
      await _p2pConnection.stopDiscovery();
      isDiscovering = false;
      print("Discovery stopped");
    } catch (e) {
      print("Error stopping discovery: $e");
    }
  }

  /// Connect to a peer
  Future<void> connectToPeer(DiscoveredPeers peer) async {
    try {
      bool result = await _p2pConnection.connect(peer.deviceAddress);
      print("Connection result: $result");
    } catch (e) {
      print("Error connecting to peer: $e");
    }
  }

  /// Disconnect the current connection
  Future<void> disconnect() async {
    try {
      await _p2pConnection.removeGroup();
      print("Disconnected from group");
    } catch (e) {
      print("Error disconnecting: $e");
    }
  }

  /// Clean up resources and unregister
  void dispose() {
    _streamWifiInfo?.cancel();
    _streamPeers?.cancel();
    _p2pConnection.unregister();
    _peersController.close();  // Close the stream controller
    print("WiFiManager disposed");
  }
}
