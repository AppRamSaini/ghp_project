import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/app_theme.dart';

showLoadingDialog(BuildContext context, Function setDialogueContext) {
  showDialog(
    barrierDismissible: false,
    context: context,
    builder: (ctx) {
      setDialogueContext(ctx);
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator.adaptive(
                  backgroundColor: AppTheme.primaryColor),
              const SizedBox(width: 18),
              const Text('Loading...'),
            ],
          ),
        ),
      );
    },
  );
}
