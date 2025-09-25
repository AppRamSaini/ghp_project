import 'package:ghp_society_management/constants/export.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

class LedgerWebViewScreen extends StatefulWidget {
  const LedgerWebViewScreen({super.key});

  @override
  State<LedgerWebViewScreen> createState() => _LedgerWebViewScreenState();
}

class _LedgerWebViewScreenState extends State<LedgerWebViewScreen> {
  bool isLoading = true;
  late final WebViewController _controller;
  String? currentHtml; // store current HTML content

  DateTime? fromDate;
  DateTime? toDate;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    _controller = WebViewController.fromPlatformCreationParams(params)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..enableZoom(true)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() => isLoading = true),
          onPageFinished: (_) => setState(() => isLoading = false),
        ),
      );

    if (_controller.platform is AndroidWebViewController) {
      AndroidWebViewController.enableDebugging(true);
      (_controller.platform as AndroidWebViewController)
          .setMediaPlaybackRequiresUserGesture(false);
    }

    fetchLedger();
  }

  /// Reset date range
  void resetDateRange() {
    setState(() {
      fromDate = null;
      toDate = null;
    });
    fetchLedger();
  }

  /// Fetch ledger from API
  Future<void> fetchLedger() async {
    final token = LocalStorage.localStorage.getString('token');
    final propertyId = LocalStorage.localStorage.getString('property_id');

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer $token'
    };

    final fromStr =
        fromDate != null ? DateFormat('yyyy-MM-dd').format(fromDate!) : null;
    final toStr =
        toDate != null ? DateFormat('yyyy-MM-dd').format(toDate!) : null;

    final queryParams = {
      if (fromStr != null) 'from_date': fromStr,
      if (toStr != null) 'to_date': toStr,
    };

    var uri = Uri.https(
      'society.ghpjaipur.com',
      '/api/user/v1/member/ledger/$propertyId',
      queryParams,
    );

    var request = http.MultipartRequest('GET', uri);
    request.headers.addAll(headers);

    try {
      http.StreamedResponse response = await request.send();

      if (response.statusCode == 200) {
        String res = await response.stream.bytesToString();
        currentHtml = res; // store HTML for PDF
        _controller.loadHtmlString(res);
        setState(() {});
      } else {
        currentHtml = "<h3>Error: ${response.reasonPhrase}</h3>";
        _controller.loadHtmlString(currentHtml!);
        setState(() {});
      }
    } catch (e) {
      currentHtml = "<h3>Error: $e</h3>";
      _controller.loadHtmlString(currentHtml!);
    }
  }

  /// Show date range picker
  Future<void> pickDateRange() async {
    final DateTime now = DateTime.now();
    final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    // safe initial range
    final DateTimeRange safeInitialRange = (fromDate != null && toDate != null)
        ? DateTimeRange(
            start: fromDate!,
            end: toDate!.isAfter(lastDayOfMonth) ? lastDayOfMonth : toDate!,
          )
        : DateTimeRange(
            start: now,
            end: now.add(const Duration(days: 3)).isAfter(lastDayOfMonth)
                ? lastDayOfMonth
                : now.add(const Duration(days: 3)),
          );

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020, 8),
      lastDate: lastDayOfMonth,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange: safeInitialRange,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              headerForegroundColor: Colors.white,
              headerBackgroundColor: AppTheme.primaryColor,
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppTheme.primaryColor;
                }
                return Colors.white;
              }),
            ),
          ),
          child: Center(
            child: Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 100),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: child ?? const SizedBox(),
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        fromDate = picked.start;
        toDate = picked.end;
      });

      fetchLedger();
    }
  }

  /// Convert current HTML to PDF and save
  Future<void> downloadPdf() async {
    if (currentHtml == null) return;

    try {
      await Printing.layoutPdf(
        dynamicLayout: false,
        outputType: OutputType.photo,
        format: PdfPageFormat.a4,
        name: "Maintenance Ledger",
        // iOS में undefined issue fix
        forceCustomPrintPaper: true,
        onLayout: (format) async {
          // Convert HTML to PDF
          final pdfBytes = await Printing.convertHtml(
            format: format,
            html: currentHtml!,
          );
          return pdfBytes;
        },
      );
    } catch (e) {
      debugPrint("PDF Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: "Ledger Details", actions: [
        ElevatedButton(
            onPressed: downloadPdf, child: const Text("Download PDF")),
      ]),
      body: Column(
        children: [
          // Filter buttons row
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                // Date range picker
                Expanded(
                  child: ElevatedButton(
                    onPressed: pickDateRange,
                    child: Text(fromDate != null && toDate != null
                        ? "${DateFormat('yyyy-MM-dd').format(fromDate!)} → ${DateFormat('yyyy-MM-dd').format(toDate!)}"
                        : "Select Date Range"),
                  ),
                ),
                const SizedBox(width: 8),
                // Reset button
                ElevatedButton(
                    onPressed: resetDateRange, child: const Text("Reset")),
              ],
            ),
          ),

          // WebView
          Expanded(
            child: WebViewWidget(controller: _controller),
          ),
        ],
      ),
    );
  }
}
