import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

Future<void> captureAndSharePng(
    ScreenshotController screenshotController) async {
  try {
    // Capture the screenshot of the entire screen
    screenshotController.capture().then((Uint8List? capturedImage) async {
      if (capturedImage != null) {
        // Get temporary directory
        final directory = await getTemporaryDirectory();
        final file = await File('${directory.path}/gate pass_qr.png').create();
        await file.writeAsBytes(capturedImage);
        // Share the captured image
        final xFile = XFile(file.path);
        await Share.shareXFiles([xFile],
            text: 'Here is the gate paa for the visitor.');
      }
    });
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

// New method to capture and download the QR code image
Future<bool> captureAndDownloadPng(
    ScreenshotController screenshotController) async {
  bool allDownloadsSuccessful = true;
  try {
    // Capture the screenshot image as bytes.
    Uint8List? capturedImage = await screenshotController.capture();
    if (capturedImage != null) {
      // Get a persistent directory.
      final directory = await getApplicationDocumentsDirectory();
      final filePath =
          '${directory.path}/visitor_qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);

      // Write the captured image to the file.
      await file.writeAsBytes(capturedImage);

      // Launch the file save dialog.
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      // If the finalPath is null, the save was cancelled or failed.
      if (finalPath == null) {
        allDownloadsSuccessful = false;
      }
    } else {
      allDownloadsSuccessful = false;
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error capturing and downloading PNG: $e");
    }
    allDownloadsSuccessful = false;
  }
  return allDownloadsSuccessful;
}
