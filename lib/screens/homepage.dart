import 'package:flutter/material.dart';
import 'package:test_app/widgets/drawer.dart'; // Import custom drawer
import 'package:test_app/models/device_data.dart'; // Import the Device data file

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Device> nearbyDevices = [];
  List<Device> savedChats = [];
  List<Device> filteredDevices = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize data from DeviceData
    nearbyDevices = DeviceData.getNearbyDevices();
    savedChats = DeviceData.getSavedChats();
    filteredDevices = nearbyDevices; // Initially show all nearby devices

    // Listen to changes in search text
    _searchController.addListener(_filterDevices);
  }

  // Method to filter devices based on search query
  void _filterDevices() {
    // Delay setState to avoid calling it during the build process
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        filteredDevices = nearbyDevices.where((device) {
          return device.name.toLowerCase().contains(_searchController.text.toLowerCase());
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: DeviceSearchDelegate(devices: nearbyDevices),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView( // Make the body scrollable
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Nearby Devices heading
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Nearby Devices',
                style: Theme.of(context).textTheme.titleLarge, // Use titleLarge instead of headline6
              ),
            ),
            // List of filtered nearby devices
            ...filteredDevices.map((device) {
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.details),
              );
            }),

            // Saved Chats heading
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Saved Chats',
                style: Theme.of(context).textTheme.titleLarge, // Use titleLarge instead of headline6
              ),
            ),
            // List of saved chats
            ...savedChats.map((device) {
              return ListTile(
                title: Text(device.name),
                subtitle: Text(device.details),
              );
            }),
          ],
        ),
      ),
      drawer: const CustomDrawer(), // CustomDrawer handles the username change
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.3, // Set swipe range to 30% of the screen width
    );
  }
}

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
      return Center(child: Text('No devices found'));
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
