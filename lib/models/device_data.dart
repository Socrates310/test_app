// device_data.dart

class Device {
  final String name;
  final String details;

  Device({required this.name, required this.details});
}

class DeviceData {
  static List<Device> getNearbyDevices() {
    // In a real-world scenario, you would fetch this data from an API or local database
    return [
      Device(name: 'Device 1', details: 'Device 1 details'),
      Device(name: 'Device 2', details: 'Device 2 details'),
    ];
  }

  static List<Device> getSavedChats() {
    // Simulating saved chats from stored data (you could fetch this from SharedPreferences or an API)
    return List.generate(
      20,
          (index) => Device(
        name: 'Chat ${index + 1}',
        details: 'Last message from Device ${index + 1}',
      ),
    );
  }
}
