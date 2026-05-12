import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BleService {
  Future<void> startScan() async {
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 5));
  }

  Stream<List<ScanResult>> get scanResults =>
      FlutterBluePlus.scanResults;

  Future<void> stopScan() async {
    await FlutterBluePlus.stopScan();
  }
}