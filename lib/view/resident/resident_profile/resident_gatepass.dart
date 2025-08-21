import 'dart:convert';

import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/download_share_gatepass.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/download_file/download_document_cubit.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screenshot/screenshot.dart';

class ResidentGatePass extends StatefulWidget {
  final User? residentModel;

  const ResidentGatePass({super.key, required this.residentModel});

  @override
  State<ResidentGatePass> createState() => ResidentGatePassState();
}

class ResidentGatePassState extends State<ResidentGatePass> {
  final GlobalKey _globalKey = GlobalKey();
  late BuildContext dialogueContext;
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> residentDetails = {
      'resident_id': widget.residentModel!.id.toString()
    };
    String jsonDetails = jsonEncode(residentDetails);

    return MultiBlocListener(
      listeners: [
        BlocListener<DownloadDocumentCubit, DownloadDocumentState>(
          listener: (context, state) {
            if (state is QRDownloading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is QRSuccess) {
              Navigator.of(context).pop();
              snackBar(context, state.successMsg.toString(), Icons.done,
                  Colors.green);
            } else if (state is QRFailed) {
              Navigator.of(context).pop();
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  Colors.red);
            } else if (state is QRTimeout) {
              Navigator.of(context).pop();
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  Colors.red);
            } else if (state is QRInternetError) {
              Navigator.of(context).pop();
              snackBar(
                  context, state.errorMsg.toString(), Icons.wifi, Colors.red);
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: appbarWidget(title: 'Resident Gate Pass'),
        bottomNavigationBar: Padding(
          padding: globalBottomPadding(context),
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 42,
                  width: 150,
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.withOpacity(0.1))),
                  child: TextButton.icon(
                    onPressed: () async {
                      await captureAndSharePng(screenshotController);
                    },
                    icon: const Icon(Icons.share, color: Colors.white),
                    label: const Text(
                      "Share",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Container(
                  height: 42,
                  width: 150,
                  decoration: BoxDecoration(
                      color: AppTheme.primaryColor,
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: Colors.grey.withOpacity(0.1))),
                  child: TextButton.icon(
                    onPressed: () async {
                      await context
                          .read<DownloadDocumentCubit>()
                          .downloadQRCode(screenshotController);
                    },
                    icon: const Icon(Icons.download, color: Colors.white),
                    label: const Text(
                      "Download",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(top: 30, right: 12, left: 12, bottom: 10),
          child: Screenshot(
            controller: screenshotController,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black45.withOpacity(0.2), blurRadius: 10)
                  ]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 45,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: AppTheme.primaryColor.withOpacity(0.8),
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(4),
                            topLeft: Radius.circular(4))),
                    child: const Text(
                      "GATE PASS",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          widget.residentModel!.image != null
                              ? CircleAvatar(
                                  radius: 32.h,
                                  backgroundImage: NetworkImage(
                                      widget.residentModel!.image.toString()))
                              : CircleAvatar(
                                  radius: 35.h,
                                  backgroundImage: const AssetImage(
                                      'assets/images/profile_icon.png')),
                          const SizedBox(width: 10),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                    capitalizeWords(
                                        widget.residentModel!.name.toString()),
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600))),
                                Text(
                                    "+91 ${widget.residentModel!.phone.toString()}",
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600))),
                                Text(
                                    "Tower/Block: ${widget.residentModel!.property!.blockName}, Property No: ${widget.residentModel!.aprtNo.toString()}",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black, fontSize: 12))
                              ],
                            ),
                          )
                        ]),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text(
                        'Show the QR code to the security guard for scanning',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.nunitoSans(
                            textStyle: TextStyle(
                                color: Colors.deepPurpleAccent,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500))),
                  ),
                  const Spacer(),
                  RepaintBoundary(
                    key: _globalKey, // Key for capturing the QR code
                    child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.1))),
                      child: QrImageView(
                        data: jsonDetails,
                        version: QrVersions.auto,
                        size: 200.0,
                      ),
                    ),
                  ),
                  const Spacer(),
                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
