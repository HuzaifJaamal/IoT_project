import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_color.dart';
import '../../core/dialogs/custom_dialog.dart';
import '../../viewmodel/bluetooth_viewmodel.dart';
import '../bluetooth/bluetooth_scan_bottom_sheet.dart';
import '../../viewmodel/carrier_dashboard_viewmodel.dart';

class CarrierDashboardView extends GetView<BluetoothViewModel> {
  const CarrierDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          // bool confirm = false;
          final connected = controller.isConnected.value;
          if (connected) {
            await showCustomStatusDialog(
              context: context,
              icon: Icons.warning,
              iconColor: AppColors.primary,
              title: "Disconnect Device",
              message: "Are you sure you want to disconnect?",
              textAlign: TextAlign.center,
              buttonText1: "Yes",
              buttonText2: "Cancel",
              onButtonTap: () async {
                print("✅ User confirmed,Device Disconnet...");

                await controller.disconnect();   // 🔥 CALL the method
                controller.goToHomeScreen();
              },      // Main action (Yes)
              onButton2Tap: () {},     // Cancel action
            );

          } else {
            controller.goToHomeScreen();

            print("🔌 Device disconnected.");
          }

        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Dashboard"),
          actions: [
            Obx(() => Padding(
                padding: const EdgeInsets.only(right: 16),
                child:
                controller.isConnected.value
                    ? Row(
                      children: const [
                        Icon(Icons.check_circle, color: Colors.teal),
                        SizedBox(width: 4),
                        Text("Connected"),
                      ],
                    )
                    : Row(
                      children: const [
                        Icon(Icons.cancel, color: Colors.red),
                        SizedBox(width: 4),
                        Text("Disconnected",style: TextStyle(color: Colors.red),),
                      ],
                    )
            ))
          ],
        ),

        body: Obx(() {

          /// CONNECTED STATUS
          final isConnected = controller.isConnected.value;

          /// CONNECTED DASHBOARD
          final dash = Get.find<CarrierDashboardViewModel>();

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [

                /// DEVICE CARD
                Card(
                  color: isConnected
                      ? Colors.white
                      : Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(
                      Icons.bluetooth,
                      color: isConnected
                          ? Colors.green
                          : Colors.grey,
                    ),

                    title: Obx(() => Text(
                      dash.deviceName.value,
                      style: TextStyle(
                        color: isConnected
                            ? Colors.black
                            : Colors.grey,
                      ),
                    )),

                    subtitle: Obx(() => Text(
                      "Battery: ${dash.batteryLevel.value}%",
                      style: TextStyle(
                        color: isConnected
                            ? Colors.black54
                            : Colors.grey,
                      ),
                    )),

                    trailing: ElevatedButton(
                      onPressed: isConnected
                          ? controller.disconnect
                          : null,
                      child: const Text("Disconnect"),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                /// TEMPERATURE CARD
                Card(
                  color: isConnected
                      ? Colors.white
                      : Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(
                      Icons.thermostat,
                      color: isConnected
                          ? Colors.blue
                          : Colors.grey,
                    ),

                    title: Text(
                      "Temperature",
                      style: TextStyle(
                        color: isConnected
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),

                    subtitle: Obx(() => Text(
                      "${dash.temperature.value.toStringAsFixed(1)} °C",
                      style: TextStyle(
                        color: isConnected
                            ? Colors.black54
                            : Colors.grey,
                      ),
                    )),
                  ),
                ),

                const SizedBox(height: 16),

                /// HUMIDITY CARD
                Card(
                  color: isConnected
                      ? Colors.white
                      : Colors.grey.shade300,
                  child: ListTile(
                    leading: Icon(
                      Icons.water_drop,
                      color: isConnected
                          ? Colors.blue
                          : Colors.grey,
                    ),

                    title: Text(
                      "Humidity",
                      style: TextStyle(
                        color: isConnected
                            ? Colors.black
                            : Colors.grey,
                      ),
                    ),

                    subtitle: Obx(() => Text(
                      "${dash.humidity.value.toStringAsFixed(1)} %",
                      style: TextStyle(
                        color: isConnected
                            ? Colors.black54
                            : Colors.grey,
                      ),
                    )),
                  ),
                ),

                const SizedBox(height: 16),

                /// GRAPH CARD
                Card(
                  color: isConnected
                      ? Colors.white
                      : Colors.grey.shade300,
                  child: SizedBox(
                    height: 150,
                    child: Center(
                      child: Obx(() => Text(
                        "Graph points: ${dash.tempHistory.length}",
                        style: TextStyle(
                          color: isConnected
                              ? Colors.black
                              : Colors.grey,
                        ),
                      )),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// CONNECT / RECONNECT BUTTON
                if (!isConnected)
                  controller.hasLastDevice.value
                      ? ElevatedButton(
                        onPressed: controller.autoReconnect,
                          child: const Text("Reconnect"),
                        )
                      : ElevatedButton(
                        onPressed: () {
                          Get.bottomSheet(
                            const BluetoothScanBottomSheet(),
                            isScrollControlled: true,
                          );
                        },
                        child: const Text("Connect to Device"),
                      ),
              ],
            ),
          );

        }
        ),

      ),
    );
  }
}


