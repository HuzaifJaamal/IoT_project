import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../viewmodel/bluetooth_viewmodel.dart';
import 'bluetooth_device_tile.dart';

class BluetoothScanBottomSheet extends GetView<BluetoothViewModel> {
  const BluetoothScanBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    // controller.startScan();

    return Obx(() {
      return Stack(
        children: [
          /// Main Sheet
          Container(
            height: MediaQuery.of(context).size.height * 0.55,
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(24),
              ),
            ),
            child: Column(
              children: [
                const SizedBox(height: 12),

                /// Drag Handle
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),

                const SizedBox(height: 16),

                /// Title
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: const Text(
                    'Device Scanner',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                /// Bluetooth Icon
                const Icon(
                  Icons.bluetooth,
                  size: 80,
                  color: Color(0xff2CA294),
                ),

                /// Scanning Loader
                if (controller.isScanning.value)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: CircularProgressIndicator(),
                  ),

                /// No Device Found
                if (!controller.isScanning.value &&
                    controller.devices.isEmpty)
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      'No device found',
                      style: TextStyle(color: Colors.red),
                    ),
                  ),

                /// Device List
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      controller.startScan();
                    },
                    child: ListView.builder(
                      itemCount: controller.devices.length,
                      itemBuilder: (_, index) {
                        final result = controller.devices[index];
                        final device = result.device;

                        final name =
                        device.platformName.isNotEmpty
                            ? device.platformName
                            : "Unknown Device";

                        return BluetoothDeviceTile(
                          name: name,
                          mac: device.remoteId.toString(),
                          onTap: () =>
                              controller.connectToDevice(device),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// Connecting Overlay
          if (controller.isConnecting.value)
            _ConnectingOverlay(
              deviceName:
              controller.isConnected.value ?
              "Subscribe Services"
               : 'Connecting to ${controller.connectingDeviceName.value}',
            ),
        ],
      );
    });
  }
}

class _ConnectingOverlay extends StatelessWidget {
  final String deviceName;

  const _ConnectingOverlay({
    required this.deviceName,
  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).colorScheme.onBackground;

    final overlayColor = textColor.withOpacity(0.6);

    return Positioned.fill(
      child: Container(
        color: overlayColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(
                color: textColor,
              ),
              const SizedBox(height: 12),
              Text(
                ' $deviceName',
                style: TextStyle(color: textColor),
              ),
            ],
          ),
        ),
      ),
    );
  }
}