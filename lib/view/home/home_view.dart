import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sense_links/viewmodel/home_viewmodel.dart';

import '../../core/constants/app_assets.dart';
import '../../core/constants/app_color.dart';
import '../../core/widgets/svg_icon.dart';



class HomeView
    extends GetView<HomeViewModel> {

  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: AppColors.white,

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment:
            MainAxisAlignment.center,
            children: [

              /// LOGO
              /*SvgIcon(
                AppAssets.logo,
                size: 28,
                color: AppColors.primary,
              ),*/
              Image.asset(
                AppAssets.appLogo,
                height: 140,
              ),

              const SizedBox(height: 40),

              /// TITLE
              const Text(
                "Select User Type",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 40),

              /// OBSERVER BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                  controller.gotoObserverDashboard,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.lightSecondary,
                  ),

                  child: const Text(
                    "Observer",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              /// DEVICE CARRIER BUTTON
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed:
                  controller.gotoCarrierDashboard,

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors.secondary,
                  ),

                  child: const Text(
                    "Device Carrier",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}