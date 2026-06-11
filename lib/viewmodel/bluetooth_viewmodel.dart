import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

import '../routes/app_routes.dart';
import 'carrier_dashboard_viewmodel.dart';

const String targetDeviceName = "T🌡️track";

class BluetoothViewModel extends GetxController {

  // final dashboard = Get.put(CarrierDashboardViewModel());
  final CarrierDashboardViewModel dashboard =
  Get.find<CarrierDashboardViewModel>();

  var isScanning = false.obs;

  var isConnecting = false.obs;

  var connectingDeviceName = "".obs;

  var isConnected = false.obs;

  var devices = <ScanResult>[].obs;

  BluetoothDevice? connectedDevice;

  StreamSubscription? scanSubscription;

  bool connectionSuccess = false;

  bool _disconnectHandled = false;

  var hasLastDevice = false.obs;

  final box = GetStorage();

  @override
  void onInit() {
    startScan();
    // checkLastDevice();
    // autoReconnect();
    super.onInit();
  }

  void checkLastDevice() {
    final deviceId = box.read("lastDeviceId");

    if (deviceId != null) {
      hasLastDevice.value = true;
    } else {
      hasLastDevice.value = false;
    }
  }

  Future<void> requestPermissions() async {
    await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();
  }

  /// Start Scan
  Future<void> startScan() async {

    await requestPermissions();

    final isOn = await FlutterBluePlus.adapterState.first;

    if (isOn != BluetoothAdapterState.on) {
      Get.snackbar(
        "Bluetooth Off",
        "Please turn on Bluetooth first",
      );
      return;
    }

    devices.clear();
    isScanning.value = true;

    scanSubscription?.cancel();

    scanSubscription =
        FlutterBluePlus.scanResults.listen((results) {

          devices.value = results.where((result) {

            return result.device.platformName == targetDeviceName;

          }).toList();

        });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 5),
    );

    Future.delayed(const Duration(seconds: 5), () {
      isScanning.value = false;
    });
  }

  /// Connect Device
  /*Future<void> connectToDevice(BluetoothDevice device) async {
    try {

      await FlutterBluePlus.stopScan();

      isConnecting.value = true;
      connectingDeviceName.value = device.platformName;

      await device.connect(
        timeout: const Duration(seconds: 10),
        license: License.commercial,
      );

      connectedDevice = device;

      /// Wait until connected properly
      await device.connectionState
          .where((state) =>
      state == BluetoothConnectionState.connected)
          .first;

      /// Listen disconnect
      device.connectionState.listen((state) {

        if (state ==
            BluetoothConnectionState.disconnected) {

          if (!_disconnectHandled) {

            _disconnectHandled = true;

            isConnected.value = false;

            Get.snackbar(
              "Disconnected",
              "Device disconnected",
            );
          }

        } else if (state ==
            BluetoothConnectionState.connected) {

          _disconnectHandled = false;

        }

      });

      /// Discover services
      List<BluetoothService> services =
      await device.discoverServices();

      for (var service in services) {

        for (var characteristic
        in service.characteristics) {

          if (characteristic.uuid
              .toString()
              .toLowerCase() ==
              "19b10001-e8f2-537e-4f6c-d104768a1214") {

            await characteristic.setNotifyValue(true);

            characteristic.lastValueStream
                .listen((value) {

              final data =
              String.fromCharCodes(value);

              print("Sensor Data: $data");

            });

          }

        }

      }

      isConnecting.value = false;
      isConnected.value = true;

      Get.back();

    } catch (e) {

      isConnecting.value = false;

      Get.showSnackbar(
        GetSnackBar(
          title: "Error",
          message: "$e",
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }*/
  Future<void> connectToDevice(BluetoothDevice device) async {
    try {
      await FlutterBluePlus.stopScan();

      // listenConnection(device); // ✅ only once

      isConnecting.value = true;
      connectingDeviceName.value = device.platformName;

      device.connectionState.listen((state) async {
        if (state == BluetoothConnectionState.connected) {
          print("Connected SUCCESS ✅");

          connectedDevice = device; // ✅ IMPORTANT
          isConnected.value = true;
          connectionSuccess = true;

          /*box.write("lastDeviceId", device.remoteId.toString());
          box.write("lastDeviceName", device.platformName);*/

          // await Future.delayed(const Duration(milliseconds: 500));

          // MTU (non-fatal)
          try {
            await device.requestMtu(247);
            print("MTU set OK");
          } catch (e) {
            print("MTU ignored: $e");
          }

          // await Future.delayed(const Duration(milliseconds: 500));

          await _discoverServices(device);

          // ✅ ONLY NOW close UI
          if (connectionSuccess) {
            isConnecting.value = false;
            isConnected.value = true;

            if (Get.isBottomSheetOpen ?? false) {
              Get.back();
            }// close bottom sheet safely here
          }
        }
        else if (state ==
            BluetoothConnectionState.disconnected) {

          if (!_disconnectHandled) {

            _disconnectHandled = true;
            dashboard.updateConnection(false);
            isConnected.value = false;

            Get.snackbar(
              "Disconnected",
              "Device disconnected",
            );
          }

        }
      });

      await device.connect(
        timeout: const Duration(seconds: 5),
        license: License.commercial,
      );

      /// Listen disconnect
      device.connectionState.listen((state) {

        if (state ==
            BluetoothConnectionState.disconnected) {

          if (!_disconnectHandled) {

            _disconnectHandled = true;
            dashboard.updateConnection(false);
            isConnected.value = false;

            Get.snackbar(
              "Disconnected",
              "Device disconnected",
            );
          }

        } else if (state ==
            BluetoothConnectionState.connected) {

          _disconnectHandled = false;

        }

      });

    } catch (e) {
      isConnecting.value = false;

      print("CONNECT ERROR: $e");

      // ❌ Only show error if real connect failure
      if (!connectionSuccess) {
        Get.snackbar("Error", "$e");
      }
    }
  }

  void listenConnection(BluetoothDevice device) {
    device.connectionState.listen((state) async {

      if (state == BluetoothConnectionState.connected) {

        print("Connected SUCCESS ✅✅✅");

        isConnected.value = true;

        await _discoverServices(device);

      }

      if (state == BluetoothConnectionState.disconnected) {

        if (!_disconnectHandled) {
          _disconnectHandled = true;

          isConnected.value = false;

          Get.snackbar("Disconnected", "Device disconnected");
        }

      } else {
        _disconnectHandled = false;
      }
    });
  }


  Future<void> _discoverServices(BluetoothDevice device) async {
    isConnected.value = true;

    dashboard.startUploadTimer();

    final services = await device.discoverServices();
    print("Services found: ${services.length}");

    BluetoothCharacteristic? sensorChar;
    BluetoothCharacteristic? batteryChar;

    for (final service in services) {
      print("Service: ${service.uuid}");

      for (final characteristic in service.characteristics) {
        final uuid = characteristic.uuid.toString().toLowerCase();
        print("Characteristic: ${characteristic.uuid}");


        /// This is for the Nano 33 ble
        /*if (uuid == "19b10001-e8f2-537e-4f6c-d104768a1214") {
          sensorChar = characteristic;
        }*/

        /// This is for the ESP32 S3
        if (uuid == "abcdefab-1234-5678-1234-abcdefabcdef") {
          sensorChar = characteristic;
        }

        if (uuid.contains("2a19")) {
          batteryChar = characteristic;
        }

        /*if (uuid == "00002a19-0000-1000-8000-00805f9b34fb") {
          batteryChar = characteristic;
        }*/
      }
    }

    if (sensorChar != null) {
      await sensorChar!.setNotifyValue(true);
      sensorChar!.lastValueStream.listen((value) {
        final data = String.fromCharCodes(value);
        print("Sensor Data: $data");
        dashboard.updateSensorData(data);
      });
    }

    if (batteryChar != null) {
      print("Battery characteristic found");

      try {
        final value = await batteryChar!.read();
        print("Battery raw: $value");
        if (value.isNotEmpty) {
          final batteryPercent = value[0];
          print("Battery: $batteryPercent%");
          dashboard.updateBatteryLevel(batteryPercent);
        }
      } catch (e) {
        print("Battery read error: $e");
      }

      await batteryChar!.setNotifyValue(true);
      batteryChar!.lastValueStream.listen((value) {
        if (value.isNotEmpty) {
          final batteryPercent = value[0];
          print("Battery Updated: $batteryPercent%");
          dashboard.updateBatteryLevel(batteryPercent);
        }
      });
    } else {
      print("Battery characteristic not found");
    }

    dashboard.updateConnection(true);
    dashboard.deviceName.value = device.platformName;
    isConnecting.value = false;

    // Get.back();
  }

  /// Work run Fine
  /*Future<void> _discoverServices(BluetoothDevice device
      ) async {
    isConnected.value = true;


    List<BluetoothService> services =
    await device.discoverServices();

    print("Services found: ${services.length}");

    for (var service in services) {
      for (var characteristic in service.characteristics) {

        print("Characteristic: ${characteristic.uuid}");

        if (characteristic.uuid
            .toString()
            .toLowerCase() ==
            "19b10001-e8f2-537e-4f6c-d104768a1214") {

          await characteristic.setNotifyValue(true);

          characteristic.lastValueStream.listen((value) {

            final data = String.fromCharCodes(value);

            print("Sensor Data: $data");
            dashboard.updateSensorData(data);

          });

        }
      }
    }
    dashboard.updateConnection(true);
    dashboard.deviceName.value = device.platformName;

    isConnecting.value = false;


    Get.back();
  }*/


  Future<void> autoReconnect() async {
    final deviceId = box.read("lastDeviceId");

    if (deviceId == null) return;

    final device = BluetoothDevice.fromId(deviceId);

    try {

      print("Auto reconnecting...");

      isConnecting.value = true;
      connectingDeviceName.value =
          box.read("lastDeviceName") ?? "Device";

      /// Listen connection first
      device.connectionState.listen((state) async {

        if (state == BluetoothConnectionState.connected) {

          print("Auto Reconnected ✅");

          await _discoverServices(device);

          isConnecting.value = false;
          isConnected.value = true;
        }

        if (state == BluetoothConnectionState.disconnected) {

          print("Auto reconnect lost");

          isConnected.value = false;
          dashboard.pauseUploadTimer();
        }

      });
      listenConnection(device); // ✅ same listener
      /// Auto connect
      await device.connect(
        autoConnect: true,
        license: License.commercial,
      );

    } catch (e) {
      print("Auto reconnect failed: $e");
    }
  }


  /// Disconnect
  Future<void> disconnect() async {
    try {
      if (connectedDevice != null) {

        await connectedDevice!.disconnect();

        connectedDevice = null; // ✅ reset
        dashboard.updateConnection(false);
        isConnected.value = false;
        dashboard.pauseUploadTimer();

        print("Disconnected manually ❌");

      } else {
        print("No device connected");
      }
    } catch (e) {
      print("Disconnect error: $e");
    }
  }

  /// Stop Scan
  Future<void> stopScan() async {

    isScanning.value = false;

    await FlutterBluePlus.stopScan();

  }

  @override
  void onClose() {

    scanSubscription?.cancel();

    super.onClose();

  }
  void goToHomeScreen() {
    Get.offAllNamed(AppRoutes.home);
    dashboard.stopUploadTimer();
  }
}

