import 'package:flutter/material.dart';

class ObserverDashboardView extends StatelessWidget {

  const ObserverDashboardView({super.key});

  @override
  Widget build(BuildContext context) {

    return const Scaffold(
      body: Center(
        child: Text(
          "Observer Dashboard",
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}