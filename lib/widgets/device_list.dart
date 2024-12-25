import 'package:flutter/material.dart';
import '../models/device_data.dart';

class NearbyDevicesList extends StatefulWidget {
  final List<Device> devices;

  const NearbyDevicesList({super.key, required this.devices});

  @override
  NearbyDevicesListState createState() => NearbyDevicesListState();
}

class NearbyDevicesListState extends State<NearbyDevicesList> {
  // This stateful widget will use widget.devices, and rebuild when devices change

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
        // Use ListView.builder to dynamically handle the list length
        Expanded(
          child: ListView.builder(
            itemCount: widget.devices.length,
            itemBuilder: (context, index) {
              final device = widget.devices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.details),
              );
            },
          ),
        ),
      ],
    );
  }
}

class SavedChatsList extends StatefulWidget {
  final List<Device> devices;

  const SavedChatsList({super.key, required this.devices});

  @override
  SavedChatsListState createState() => SavedChatsListState();
}

class SavedChatsListState extends State<SavedChatsList> {
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
        // Use ListView.builder for dynamic list handling
        Expanded(
          child: ListView.builder(
            itemCount: widget.devices.length,
            itemBuilder: (context, index) {
              final device = widget.devices[index];
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.details),
              );
            },
          ),
        ),
      ],
    );
  }
}
