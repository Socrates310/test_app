import 'package:flutter/material.dart';
import 'package:test_app/widgets/drawer.dart';
import 'package:test_app/widgets/device_list.dart';
import 'package:test_app/widgets/device_search_delegate.dart';
import 'package:test_app/models/device_data.dart';

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({super.key, required this.title});

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Device> nearbyDevices = [];
  List<Device> savedChats = [];

  @override
  void initState() {
    super.initState();
    nearbyDevices = DeviceData.getNearbyDevices();
    savedChats = DeviceData.getSavedChats();
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
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NearbyDevicesList(devices: nearbyDevices),
            SavedChatsList(devices: savedChats),
          ],
        ),
      ),
      drawer: const CustomDrawer(),
      drawerEdgeDragWidth: MediaQuery.of(context).size.width * 0.3,
    );
  }
}
