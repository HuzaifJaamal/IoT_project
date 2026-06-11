import 'package:get/get.dart';

import '../routes/app_routes.dart';



class HomeViewModel extends GetxController {

  void gotoObserverDashboard() {

    Get.toNamed(AppRoutes.observerDashboard);

  }

  void gotoCarrierDashboard() {
    // Get.offAllNamed(AppRoutes.carrierDashboard);
    Get.toNamed(AppRoutes.carrierDashboard);

  }
}