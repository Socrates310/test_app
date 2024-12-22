import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

var logger = Logger();

class WifiDirectFileTransfer {
  static const MethodChannel _channel = MethodChannel('com.example.connectx/wifiDirect');

  // Method to start Wi-Fi Direct file transfer
  static Future<void> startFileTransfer(String filePath) async {
    try {
      await _channel.invokeMethod('startFileTransfer', {"filePath": filePath});
    } on PlatformException catch (e) {
      logger.e("Error: ${e.message}");  // Use logger instead of print
    }
  }
}

