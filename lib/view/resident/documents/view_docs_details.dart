import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import '../../../model/outgoing_document_model.dart';

class ViewDocsDetails extends StatefulWidget {
  final List<FileElement> fileUrls;

  const ViewDocsDetails({required this.fileUrls});

  @override
  State<ViewDocsDetails> createState() => _ViewDocsDetailsState();
}

class _ViewDocsDetailsState extends State<ViewDocsDetails> {
  bool isLoading = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'View Documents'),
      body: Stack(
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
    );
  }
}
