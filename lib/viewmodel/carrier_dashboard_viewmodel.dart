import 'package:get/get.dart';

class CarrierDashboardViewModel extends GetxController {

  /// Device Info
  var deviceName = "NanoSensor".obs;
  var isConnected = false.obs;

  /// Battery
  var batteryLevel = 0.obs;

  /// Sensor Data
  var temperature = 0.0.obs;
  var humidity = 0.0.obs;
  var pressure = 0.0.obs;

  /// Graph data (last 20 values)
  var tempHistory = <double>[].obs;

  /// Update from BLE
  void updateConnection(bool value) {
    isConnected.value = value;
  }

  void updateBattery(int value) {
    batteryLevel.value = value;
  }

  void updateBatteryLevel(int value) {
    batteryLevel.value = value;
  }

  void updateSensorData(String rawData) {
    try {
      // Example: T:27.9,H:46.4
      final parts = rawData.split(',');

      for (var part in parts) {
        if (part.startsWith("T:")) {
          temperature.value = double.parse(part.substring(2));
        }
        if (part.startsWith("H:")) {
          humidity.value = double.parse(part.substring(2));
        }
      }

      /// Update graph
      tempHistory.add(temperature.value);

      if (tempHistory.length > 20) {
        tempHistory.removeAt(0);
      }

    } catch (e) {
      print("Parse error: $e");
    }
  }
}