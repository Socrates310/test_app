// device_data.dart

class Device {
  final String name;
  final String details;

  Device({required this.name, required this.details});
}

class DeviceData {
  static List<Device> nearbyDevices = []; // This list will store the discovered Bluetooth devices

  // Method to return the list of nearby devices
  static List<Device> getNearbyDevices() {
    return nearbyDevices; // Return the list of nearby devices
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

  // Method to update the nearby devices list
  static void updateNearbyDevices(List<Device> newDevices) {
    nearbyDevices = newDevices; // Update the list of nearby devices
  }
}
