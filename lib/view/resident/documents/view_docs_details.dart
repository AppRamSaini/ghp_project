import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../../../model/outgoing_document_model.dart';

class ViewDocsDetails extends StatefulWidget {
  final List<FileElement> fileUrls;
  const ViewDocsDetails({required this.fileUrls});

  @override
  State<ViewDocsDetails> createState() => _ViewDocsDetailsState();
}

class _ViewDocsDetailsState extends State<ViewDocsDetails> {
  bool isLoading = true; // Initially, set loading to true

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child:
                        const Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        "Documents View",
                        style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: PageView(
                          pageSnapping: true,
                          children: widget.fileUrls.map((fileUrl) {
                            return SfPdfViewer.network(
                              fileUrl.path.toString(),
                              onDocumentLoaded: (details) {
                                setState(() {
                                  isLoading = false;
                                });
                              },
                              onDocumentLoadFailed: (details) {
                                setState(() {
                                  isLoading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Failed to load PDF")),
                                );
                              },
                            );

                            //   WebView(
                            //   initialUrl: fileUrl.path,
                            //   onPageStarted: (value) {
                            //     setState(() {
                            //       isLoading = true;
                            //     });
                            //   },
                            //   onPageFinished: (value) {
                            //     setState(() {
                            //       isLoading = false;
                            //     });
                            //   },
                            // );
                          }).toList(),
                        ),
                      ),
                    ),
                  ),

                  // Loader Overlay
                  if (isLoading)
                    Positioned.fill(
                      child: Container(
                        color: Colors.white, // Background overlay
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}