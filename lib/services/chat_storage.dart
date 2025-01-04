import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/chat_message.dart';

class ChatStorage {
  // Save messages for a specific device address
  Future<void> saveChat(String deviceAddress, List<ChatMessage> messages) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> chatList = messages.map((msg) => jsonEncode(msg.toJson())).toList();
    await prefs.setStringList(deviceAddress, chatList);  // Save as a list of strings
  }

  // Retrieve messages for a specific device address
  Future<List<ChatMessage>> loadChat(String deviceAddress) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? chatList = prefs.getStringList(deviceAddress);
    if (chatList != null) {
      return chatList.map((item) {
        Map<String, dynamic> messageJson = jsonDecode(item);
        return ChatMessage.fromJson(messageJson);
      }).toList();
    }
    return [];
  }
}
