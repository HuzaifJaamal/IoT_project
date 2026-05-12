import 'package:get/get.dart';
import '../viewmodel/bluetooth_viewmodel.dart';
import '../viewmodel/carrier_dashboard_viewmodel.dart';
import '../viewmodel/home_viewmodel.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BluetoothViewModel());
    Get.lazyPut(() => CarrierDashboardViewModel());
    Get.lazyPut(() => HomeViewModel());
  }
}