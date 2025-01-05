// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_bar_local_notification/services/notification_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: ElevatedButton(
          onPressed: () async {
            bool isGranted = await checkPermission(context);

            if (isGranted) {
              await displayNotification();
            }
          },
          child: const Text('show notification')),
    ));
  }

  Future<bool> checkPermission(BuildContext context) async {
    PermissionStatus status = await Permission.notification.status;

    if (status == PermissionStatus.permanentlyDenied) {
      showPermissionMessage(context);
      return false;
    }

    if (!status.isGranted) {
      status = await Permission.notification.request();
    }

    return status.isGranted;
  }

  void showPermissionMessage(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('The permission is permanently denied'),
          content: Text(
              'You can only grant permission in the phone\'s application settings.'),
        );
      },
    );
  }

  Future<void> displayNotification() async {
    for (int i = 0; i <= 100; i += 10) {
      await showNotification(i);
      await Future.delayed(const Duration(seconds: 1));
    }
  }
}
