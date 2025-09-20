import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class LedgerPdfPage extends StatelessWidget {
  final List<Map<String, dynamic>> ledgerData;

  const LedgerPdfPage({super.key, required this.ledgerData});

  Future<Uint8List> _generatePdf(final PdfPageFormat format) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: format,
        build: (context) => [
          // Header
          pw.Center(
            child: pw.Text(
              "RANGOLI GARDENS, JAIPUR",
              style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red),
            ),
          ),
          pw.SizedBox(height: 10),

          pw.Text("Ledger Detail",
              style:
                  pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),

          pw.SizedBox(height: 10),
          pw.Text("Name of project: RANGOLI GARDENS, JAIPUR"),
          pw.Text("Name of customer: VISHAL SOLANKI & TRIPTI SOLANKI"),
          pw.Text("Unit No.: T-1143"),

          pw.SizedBox(height: 20),

          // Table
          pw.Table.fromTextArray(
            border: pw.TableBorder.all(width: 0.5),
            headerStyle: pw.TextStyle(
                fontWeight: pw.FontWeight.bold, color: PdfColors.white),
            headerDecoration: pw.BoxDecoration(color: PdfColors.red),
            cellHeight: 25,
            headers: [
              "S.No.",
              "Date",
              "Bills",
              "Narrations",
              "Debit",
              "Credit",
              "Balance"
            ],
            data: List<List<String>>.generate(
              ledgerData.length,
              (index) => [
                "${index + 1}",
                ledgerData[index]["date"] ?? "",
                ledgerData[index]["bill"] ?? "",
                ledgerData[index]["narration"] ?? "",
                ledgerData[index]["debit"].toString(),
                ledgerData[index]["credit"].toString(),
                ledgerData[index]["balance"].toString(),
              ],
            ),
          ),

          pw.SizedBox(height: 20),

          // Grand total
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                "Grand Total   ${_calculateTotals()}",
                style:
                    pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),

          pw.SizedBox(height: 20),

          // Disclaimer
          pw.Text(
            "Legal Disclaimer",
            style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.red),
          ),
          pw.Text(
            "This is a trial version of our maintenance services web portal. "
            "The financial information pertaining to your property could have some errors or inaccuracies. "
            "Hence please do not use this information for any purpose where authenticity is to be assured.\n\n"
            "This is beta testing ledgers. If found any discrepancy in ledgers, please report at maintenance@ashianhousing.com",
            style: pw.TextStyle(fontSize: 10),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  String _calculateTotals() {
    double debit = 0, credit = 0, balance = 0;
    for (var entry in ledgerData) {
      debit += double.tryParse(entry["debit"].toString()) ?? 0;
      credit += double.tryParse(entry["credit"].toString()) ?? 0;
      balance =
          double.tryParse(entry["balance"].toString()) ?? 0; // last balance
    }
    return "Debit: $debit   Credit: $credit   Balance: $balance";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Ledger PDF")),
      body: PdfPreview(
        build: (format) => _generatePdf(format),
      ),
    );
  }
}
