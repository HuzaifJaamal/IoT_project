import 'package:flutter/material.dart';

class BluetoothDeviceTile extends StatelessWidget {
  final String name;
  final String mac;
  final VoidCallback onTap;

  const BluetoothDeviceTile({
    super.key,
    required this.name,
    required this.mac,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(
        Icons.watch,
        color: Color(0xff2CA294),
      ),
      title: Text(name),
      subtitle: Text(mac),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}