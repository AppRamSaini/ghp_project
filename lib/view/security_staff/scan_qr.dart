import 'dart:async';
import 'dart:convert';

import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_profile.dart';
import 'package:ghp_society_management/view/security_staff/daliy_help/daily_help_details.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_details_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QrCodeScanner extends StatefulWidget {
  final bool fromResidentSide;
  final String? visitorId;

  const QrCodeScanner(
      {super.key, this.visitorId, this.fromResidentSide = false});

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner>
    with SingleTickerProviderStateMixin {
  final MobileScannerController controller = MobileScannerController();
  late BuildContext dialogueContext;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(seconds: 2))
          ..repeat(reverse: false);
    _animation =
        Tween<double>(begin: 0, end: 200).animate(_animationController);
  }

  @override
  void dispose() {
    controller.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    var status = await Permission.camera.status;

    if (status.isDenied || status.isPermanentlyDenied) {
      await Permission.camera.request();
      setState(() {});
    }

    if (await Permission.camera.isGranted) {
      setState(() {});
    }
  }

  /// Helper Method for Navigation
  void _navigateToVisitorDetails(String visitorId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VisitorsDetailsPage2(
          visitorsId: {'visitor_id': visitorId},
          isTypesScan: true,
        ),
      ),
    );
  }

  void _handleDetection(BarcodeCapture capture) async {
    for (var barcode in capture.barcodes) {
      if (barcode.rawValue == null) continue;

      // // Show loading dialog
      // showLoadingDialog(context, (ctx) => dialogueContext = ctx);

      try {
        final qrData = barcode.rawValue!;
        Map<String, dynamic>? parsedData;
        try {
          parsedData = jsonDecode(qrData);
        } catch (_) {
          throw Exception("Invalid QR format. Not a valid JSON.");
        }

        await controller.stop();
        //
        // // ✅ Safe pop check
        // if (mounted && Navigator.canPop(dialogueContext)) {
        //   Navigator.pop(dialogueContext);
        // }

        if (parsedData!.containsKey('visitor_id')) {
          final scannedVisitorId = parsedData['visitor_id'];

          if (widget.visitorId == null) {
            _navigateToVisitorDetails(scannedVisitorId);
          } else if (widget.visitorId != scannedVisitorId) {
            if (mounted && Navigator.canPop(context)) {
              Navigator.of(context, rootNavigator: true).pop();
            }
            snackBar(
                context,
                "Scanned visitor QR is different. Please scan the correct visitor QR code.",
                Icons.warning,
                AppTheme.redColor);
          } else {
            _navigateToVisitorDetails(scannedVisitorId);
          }
        } else if (parsedData.containsKey('resident_id')) {
          if (widget.visitorId == null) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => ResidentProfileDetails(
                  residentId: {'resident_id': parsedData!['resident_id']},
                  forQRPage: true,
                  forResident: widget.fromResidentSide,
                ),
              ),
            );
          } else {
            final scannedVisitorId = parsedData['visitor_id'];
            if (widget.visitorId != scannedVisitorId) {
              if (mounted && Navigator.canPop(context)) {
                Navigator.of(context, rootNavigator: true).pop();
              }
              snackBar(
                context,
                "Scanned visitor ID is different. Please scan the correct visitor QR code.",
                Icons.warning,
                AppTheme.redColor,
              );
            }
          }
        } else if (parsedData.containsKey('daily_help_id')) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => DailyHelpProfileDetails(
                dailyHelpId: {'daily_help_id': parsedData!['daily_help_id']},
                forQRPage: true,
                forDetailsPage: false,
                fromResidentPage: widget.fromResidentSide,
              ),
            ),
          );
        } else {
          throw Exception("Unsupported QR type. Key not found.");
        }
      } catch (e) {
        // // ✅ Safe pop check
        // if (mounted && Navigator.canPop(context)) {
        //   Navigator.of(context, rootNavigator: true).pop();
        // }
        snackBar(context, e.toString(), Icons.warning, AppTheme.redColor);
      }

      break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(controller: controller, onDetect: _handleDetection),

          // Overlay + Scanner box
          Center(child: _buildScannerOverlay()),

          // Red animation line
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animation,
              builder: (_, __) {
                return Center(
                  child: Container(
                    margin: EdgeInsets.only(top: _animation.value),
                    height: 2,
                    width: 220,
                    color: Colors.redAccent,
                  ),
                );
              },
            ),
          ),

          // Close button (top left)
          // Positioned(
          //   top: MediaQuery.of(context).padding.top + 16,
          //   left: 16,
          //   child: CircleAvatar(
          //     backgroundColor: Colors.black54,
          //     child: IconButton(
          //         icon: const Icon(Icons.arrow_back, color: Colors.white),
          //         onPressed: () => Navigator.pushAndRemoveUntil(
          //             context,
          //             MaterialPageRoute(builder: (_) => Dashboard()),
          //             (newRoute) => true)),
          //   ),
          // ),

          // Flash toggle (bottom center)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: CircleAvatar(
                backgroundColor: Colors.black54,
                child: IconButton(
                  icon: ValueListenableBuilder(
                    valueListenable: controller,
                    builder: (context, state, child) {
                      if (state == TorchState.off) {
                        return const Icon(Icons.flash_off, color: Colors.white);
                      } else {
                        return const Icon(Icons.flash_on, color: Colors.yellow);
                      }
                    },
                  ),
                  onPressed: () => controller.toggleTorch(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Dark transparent background with clear cutout center
        ColorFiltered(
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(0.6),
            BlendMode.srcOut,
          ),
          child: Stack(
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  height: 220,
                  width: 220,
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Border around scanner
        Container(
          height: 220,
          width: 220,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurpleAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ],
    );
  }
}
