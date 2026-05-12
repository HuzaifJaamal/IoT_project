import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sense_links/routes/app_pages.dart';
import 'package:sense_links/routes/app_routes.dart';

import 'bindings/app_binding.dart' show AppBinding;


void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Inject ViewModel globally (MVVM)
  // Get.put(BluetoothViewModel());

  // runApp(const SenseLinksApp());
  // await GetStorage.init();
  // runApp(MyApp());
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SenseLinks',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      initialRoute: AppRoutes.home,
      getPages: AppPages.pages,
      initialBinding: AppBinding(),
    );
  }
}


/*
class SenseLinksApp extends StatelessWidget {
  const SenseLinksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,

      title: 'SenseLinks',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
        ),
      ),
      initialBinding: BluetoothBinding(),
      home: BluetoothView(),
    );
  }
}*/
