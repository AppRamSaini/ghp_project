import 'dart:async';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';

void sessionExpiredDialog(BuildContext context) {
  // Show the dialog
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      return Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: AppTheme.primaryColor),
              const SizedBox(height: 20),
              const Text('Your session has been expired.',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
    },
  );

  // Start the timer for 3 minutes
  Timer(const Duration(seconds: 3), () {
    // Close the dialog
    Navigator.of(context, rootNavigator: true).pop();

    // Clear local storage
    LocalStorage.localStorage.clear();

    // Navigate to the SelectSocietyScreen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const SelectSocietyScreen()),
      (route) => false,
    );
  });
}
