import 'package:flutter/material.dart';
import '../models/chat_message.dart';
import '../services/chat_storage.dart';
import '../services/wifi_p2p_manager.dart';

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

  @override
  void initState() {
    super.initState();
    _loadMessages();
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
