import 'package:flutter/material.dart';
import 'package:test_app/models/device_data.dart';

class DeviceSearchDelegate extends SearchDelegate {
  final List<Device> devices;

  DeviceSearchDelegate({required this.devices});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final filteredDevices = devices.where((device) {
      return device.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    if (filteredDevices.isEmpty) {
      return const Center(child: Text('No devices found'));
    }

    return ListView.builder(
      itemCount: filteredDevices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredDevices[index].name),
          subtitle: Text(filteredDevices[index].details),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final filteredDevices = devices.where((device) {
      return device.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredDevices.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(filteredDevices[index].name),
          subtitle: Text(filteredDevices[index].details),
        );
      },
    );
  }
}
