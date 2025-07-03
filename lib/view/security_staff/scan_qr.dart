import 'dart:async';
import 'dart:convert';
import 'package:ghp_society_management/view/resident/resident_profile/resident_profile.dart';
import 'package:ghp_society_management/view/security_staff/daliy_help/daily_help_details.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_details_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrCodeScanner extends StatefulWidget {
  bool fromResidentSide;
  QrCodeScanner({super.key, this.fromResidentSide = false});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final MobileScannerController controller = MobileScannerController();
  late BuildContext dialogueContext;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  /// Function to request camera permission
  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.camera.request(); // Open default permission dialog
    }

    if (await Permission.camera.isGranted) {
      setState(() {}); // If permission is granted, refresh UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: MediaQuery.sizeOf(context).height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: MobileScanner(
              controller: controller,
              onDetect: (BarcodeCapture capture) async {
                for (var barcode in capture.barcodes) {
                  if (barcode.rawValue != null) {
                    showLoadingDialog(context, (ctx) {
                      dialogueContext = ctx;
                    });
                    try {
                      // Extract and parse QR data
                      String qrData = barcode.rawValue!;
                      Map<String, dynamic> parsedData;
                      try {
                        parsedData = jsonDecode(qrData);
                      } catch (e) {
                        Navigator.of(context, rootNavigator: true).pop();
                        snackBar(context, "Invalid QR code format.",
                            Icons.warning, AppTheme.redColor);
                        return;
                      }
                      if (parsedData.containsKey('visitor_id')) {
                        String id = parsedData['visitor_id'];
                        await controller.stop();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.pop(dialogueContext);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => VisitorsDetailsPage2(
                                      visitorsId: {'visitor_id': id},
                                      isTypesScan: true)));
                        });
                      } else if (parsedData.containsKey('resident_id')) {
                        String id = parsedData['resident_id'];
                        await controller.stop();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.pop(dialogueContext);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ResidentProfileDetails(
                                      residentId: {'resident_id': id},
                                      forQRPage: true,forResident: widget.fromResidentSide)));
                        });
                      } else if (parsedData.containsKey('daily_help_id')) {
                        String id = parsedData['daily_help_id'];
                        await controller.stop();
                        Future.delayed(const Duration(milliseconds: 100), () {
                          Navigator.pop(dialogueContext);
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => DailyHelpProfileDetails(
                                      dailyHelpId: {'daily_help_id': id},
                                      forQRPage: true,
                                      forDetailsPage: false,
                                      fromResidentPage:
                                      widget.fromResidentSide)));
                        });
                      } else {
                        throw Exception("Key '-->>' not found.");
                      }
                    } catch (e) {
                      Navigator.of(context, rootNavigator: true).pop();
                      snackBar(context, "Error processing QR code.",
                          Icons.warning, AppTheme.redColor);
                    }

                    break; // Stop processing after the first valid QR code
                  }
                }
              },
            ),
          ),
        ),
        Container(
          height: 220,
          width: 220,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.deepPurpleAccent, width: 1.5)),
        )
      ],
    );
  }
}