import 'package:get/get.dart';
import '../viewmodel/bluetooth_viewmodel.dart';


class BluetoothBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BluetoothViewModel());


  }
}