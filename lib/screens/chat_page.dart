import 'dart:async';
import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_storage.dart';
import '../services/wifi_p2p_manager.dart';
import 'package:flutter_p2p_connection/flutter_p2p_connection.dart';

class ChatPage extends StatefulWidget {
  final String deviceName;
  final String deviceAddress;

  const ChatPage({
    super.key,
    required this.deviceName,
    required this.deviceAddress,
  });

  @override
  ChatPageState createState() => ChatPageState();
}

class ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  List<ChatMessage> _messages = [];
  final ChatStorage _chatStorage = ChatStorage();
  WifiP2PInfo? wifiP2PInfo;
  List<DiscoveredPeers> peers = [];
  StreamSubscription<WifiP2PInfo>? _streamWifiInfo;
  StreamSubscription<List<DiscoveredPeers>>? _streamPeers;

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _checkConnectionAndSocket();
    _init();
  }

  void _init() async {
    // Listen to WifiP2PInfo stream
    _streamWifiInfo = WifiP2PManager.instance.streamWifiP2PInfo().listen((event) {
      setState(() {
        wifiP2PInfo = event; // Assuming wifiP2PInfo is a member variable
      });
    });
  }

  /*Future<bool> _getConnectionStatus() async {
    return wifiP2PInfo?.isConnected ?? false; // Use null-coalescing operator
  }

  Future<bool> _getGroupOwnerStatus() async {
    return wifiP2PInfo?.isGroupOwner ?? false; // Use null-coalescing operator
  }*/

  Future<void> _checkConnectionAndSocket() async {
    // Fetch connection and group owner status
    bool isConnected = wifiP2PInfo?.isConnected ?? false;
    bool isGroupOwner = wifiP2PInfo?.isGroupOwner ?? false;

    try {
      if (isConnected) {
        if (isGroupOwner) {
          await startSocket();
          snack('Socket created!');
        } else {
          await connectToSocket();
          snack('Connected to socket!');
        }
      } else {
        snack('Not connected to any Wi-Fi P2P network.');
      }
    } catch (e) {
      snack('Error: ${e.toString()}');
    }
  }


  // Load existing messages when the page loads
  _loadMessages() async {
    List<ChatMessage> messages = await _chatStorage.loadChat(widget.deviceAddress);
    setState(() {
      _messages = messages;
    });
  }

  // Send a message
  _sendMessage(String message) async {
    if (message.isEmpty) return;
    // Create a new message
    ChatMessage chatMessage = ChatMessage(sender: 'Me', message: message);
    // Add the message to the list
    setState(() {
      _messages.add(chatMessage);
    });
    // Save the updated list to local storage
    await _chatStorage.saveChat(widget.deviceAddress, _messages);
    // Clear the text field
    _controller.clear();
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
      appBar: AppBar(
        title: Text(widget.deviceName),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                bool isSender = message.sender == 'Me'; // This will check if the message is from the sender (you)

                return Align(
                  alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    margin: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: isSender ? Colors.blue : Colors.grey,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      message.message,
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(hintText: 'Type a message'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    _sendMessage(_controller.text);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}




