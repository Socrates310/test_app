import 'package:flutter/material.dart';
import 'package:test_app/models/device_data.dart';

class NearbyDevicesList extends StatelessWidget {
  final List<Device> devices;
  final VoidCallback onRescanPressed;

  const NearbyDevicesList({
    super.key,
    required this.devices,
    required this.onRescanPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Nearby Devices',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...devices.map((device) {
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.details),
          );
        }),
        SizedBox(height: 16),
        // Rescan button at the bottom right
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            onPressed: onRescanPressed, // Trigger rescan when pressed
            child: Icon(Icons.refresh), // Icon to indicate refresh
          ),
        ),
      ],
    );
  }
}

class SavedChatsList extends StatelessWidget {
  final List<Device> devices;

  const SavedChatsList({super.key, required this.devices});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Saved Chats',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        ...devices.map((device) {
          return ListTile(
            title: Text(device.name),
            subtitle: Text(device.details),
          );
        }),
      ],
    );
  }
}
