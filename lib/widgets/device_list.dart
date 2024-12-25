import 'package:flutter/material.dart';
import '../models/device_data.dart';

class NearbyDevicesList extends StatelessWidget {
  final List<Device> devices;

  const NearbyDevicesList({super.key, required this.devices});

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
