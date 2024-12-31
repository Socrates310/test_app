import 'package:flutter/material.dart';

class ChatPage extends StatelessWidget {
  final String deviceName;
  final String deviceAddress;

  const ChatPage({
    Key? key,
    required this.deviceName,
    required this.deviceAddress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(deviceName),
      ),
      body: Center(
        child: Text('Chatting with $deviceName ($deviceAddress)'),
      ),
    );
  }
}
