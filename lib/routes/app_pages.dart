import 'package:get/get.dart';
import '../bindings/app_binding.dart';
import '../view/dashboard/carrier_dashboard_view.dart';
import '../view/dashboard/observer_dashboard_view.dart';
import '../view/home/home_view.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
      // binding: AppBinding(),
    ),
    GetPage(
      name: AppRoutes.observerDashboard,
      page: () => ObserverDashboardView(),
      // binding: AppBinding(),
    ),
    GetPage(
      name: AppRoutes.carrierDashboard,
      page: () => CarrierDashboardView(),
      binding: AppBinding(),
    ),
  ];
}