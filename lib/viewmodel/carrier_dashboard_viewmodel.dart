import 'dart:async';

import 'package:get/get.dart';

import '../data/repositories/sensor_repository.dart';

class CarrierDashboardViewModel extends GetxController {

  final SensorRepository repository =
  SensorRepository();

  /// Device Info
  var deviceName = "NanoSensor".obs;
  var isConnected = false.obs;

  /// Battery
  var batteryLevel = 0.obs;

  /// Sensor Data
  var temperature = 0.0.obs;
  var humidity = 0.0.obs;
  var pressure = 0.0.obs;


  Timer? uploadTimer;

  /// Graph data (last 20 values)
  var tempHistory = <double>[].obs;


  /*@override
  void onInit() {

    super.onInit();

    uploadTimer =
        Timer.periodic(
          const Duration(minutes: 1),
              (_) {

            repository.saveData(
              temperature: temperature.value,
              humidity: humidity.value,
              battery: batteryLevel.value,
            );
          },
        );
  }*/


  void startUploadTimer() {

    uploadTimer?.cancel();


    uploadTimer =
        Timer.periodic(
          const Duration(minutes: 1),
              (_) {

            if (!isConnected.value) {
              return;
            }

            repository.saveData(
              status: isConnected.value,
              temperature: temperature.value,
              humidity: humidity.value,
              battery: batteryLevel.value,
            );
          },
        );

  }

  void pauseUploadTimer() {
    uploadTimer?.cancel();

    uploadTimer = Timer.periodic(
      const Duration(minutes: 1),
          (_) {
            if (isConnected.value) {
              return;
            }
        repository.saveData(
          status: isConnected.value,
          temperature: 0.0,
          humidity: 0.0,
          battery: 0,
        );
      },
    );
  }

  void stopUploadTimer() {
    uploadTimer?.cancel();
  }

  /// Update from BLE
  void updateConnection(bool value) {
    isConnected.value = value;
  }

  void updateBatteryLevel(int value) {
    batteryLevel.value = value;
  }


  void updateSensorData(String rawData) async {

    try {

      final parts = rawData.split(',');

      for (var part in parts) {

        if (part.startsWith("T:")) {
          temperature.value =
              double.parse(part.substring(2));
        }

        if (part.startsWith("H:")) {
          humidity.value =
              double.parse(part.substring(2));
        }
      }

      tempHistory.add(temperature.value);

      if (tempHistory.length > 20) {
        tempHistory.removeAt(0);
      }

     /* await repository.saveData(
        temperature: temperature.value,
        humidity: humidity.value,
        battery: batteryLevel.value,
      );*/

    } catch (e) {

      print("Parse Error: $e");
    }
  }

  /*void updateSensorData(String rawData) {
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
  }*/
  /*@override
  void onClose() {

    uploadTimer?.cancel();

    super.onClose();
  }*/
}