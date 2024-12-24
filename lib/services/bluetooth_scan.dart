import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart'; // Import flutter_blue instead of flutter_blue_plus
import 'package:test_app/models/device_data.dart';
import 'package:test_app/widgets/device_list.dart'; // Import the device list widget

class BluetoothScanPage extends StatefulWidget {
  @override
  BluetoothScanPageState createState() => BluetoothScanPageState();
}

class BluetoothScanPageState extends State<BluetoothScanPage> {
  bool isScanning = false; // Track scanning state

  @override
  void initState() {
    super.initState();
  }

  // Start scanning for Bluetooth devices
  void _startScanning() {
    if (!isScanning) {
      // Start scanning with a timeout
      FlutterBlue.instance.startScan(timeout: Duration(seconds: 4));

      setState(() {
        isScanning = true;
      });

      // Listen to scan results
      FlutterBlue.instance.scanResults.listen((results) {
        // Map the Bluetooth scan results to a list of Device objects
        List<Device> devices = results.map((result) {
          return Device(
            name: result.device.name.isNotEmpty ? result.device.name : 'Unknown Device',
            details: result.device.id.toString(), // Use device ID as details
          );
        }).toList();

        // Update the nearby devices list in DeviceData
        DeviceData.updateNearbyDevices(devices);
      });

      // Stop scanning after the timeout
      Future.delayed(Duration(seconds: 4), () {
        if (isScanning) {
          FlutterBlue.instance.stopScan(); // Stop scanning
          setState(() {
            isScanning = false;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    if (isScanning) {
      FlutterBlue.instance.stopScan(); // Stop scanning when disposed
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Devices'),
        actions: [
          IconButton(
            icon: Icon(isScanning ? Icons.stop : Icons.search),
            onPressed: _startScanning, // Start scanning when the button is pressed
          ),
        ],
      ),
      body: Column(
        children: [
          if (isScanning)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Expanded(
            child: NearbyDevicesList(
              devices: DeviceData.getNearbyDevices(),
              onRescanPressed: _startScanning, // Pass the rescan callback
            ),
          ),
        ],
      ),
    );
  }
}
