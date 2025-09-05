import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/bill_details/bill_details_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BillDetailScreen extends StatefulWidget {
  final String billId;

  BillDetailScreen({super.key, required this.billId});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  late BillDetailsCubit _billDetailsCubit;

  @override
  void initState() {
    super.initState();
    _billDetailsCubit = BillDetailsCubit();
    _billDetailsCubit.fetchMyBillsDetails(context, widget.billId);
  }

  Future<void> onRefresh() async {
    await _billDetailsCubit.fetchMyBillsDetails(context, widget.billId);
  }

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  Widget amountText(num value,
      {Color color = Colors.black, double fontSize = 14, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.only(left: 15),
      child: Text(
        '₹${value.toStringAsFixed(2)}',
        style: GoogleFonts.nunitoSans(
          textStyle: TextStyle(
            color: color,
            fontSize: fontSize,
            fontWeight: bold ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, Widget valueWidget) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(title,
                  style: GoogleFonts.nunitoSans(
                      textStyle: const TextStyle(
                          color: Colors.black87, fontSize: 14)))),
          Expanded(child: valueWidget),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Bill Details'),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BlocBuilder<BillDetailsCubit, BillsDetailsState>(
          bloc: _billDetailsCubit,
          builder: (context, state) {
            if (state is BillDetailsLoading) {
              return notificationShimmerLoading();
            } else if (state is BillDetailsLoaded) {
              var billDetails = state.bills.first;

              // Parsing amounts
              num billAmount = parseNum(billDetails.amount);
              num installment = parseNum(billDetails.installment);
              num prevPending = parseNum(billDetails.prevMonthPending);
              num advanceAmount = parseNum(billDetails.advanceAmount);

              // Calculate pending and extra advance
              num totalDue = billAmount + prevPending;
              num paidTotal = installment + advanceAmount;

              num currentMonthPending = max(0, totalDue - paidTotal);
              num extraAdvance = max(0, paidTotal - totalDue);

              // TOTAL PAY AMOUNT = currentMonthPending
              num totalPayAmount = currentMonthPending;

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(10),
                child: Column(
                  children: [
                    // Main Bill Info Card
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    billDetails.service?.name ?? '-',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                Chip(
                                  label: Text(
                                    (billDetails.status ?? '').toUpperCase(),
                                    style: TextStyle(
                                      color: billDetails.status == 'unpaid'
                                          ? Colors.red
                                          : Colors.green,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  backgroundColor:
                                      (billDetails.status == 'unpaid'
                                          ? Colors.red[50]
                                          : Colors.green[50]),
                                ),
                              ],
                            ),
                            const Divider(thickness: 0.5, color: Colors.grey),
                            buildInfoRow(
                                'Invoice No :',
                                Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                        billDetails.invoiceNumber ?? '-'))),
                            buildInfoRow('Current Month Payment :',
                                amountText(billAmount)),
                            buildInfoRow(
                                'Installment Paid :', amountText(installment)),
                            buildInfoRow('Previous Outstanding :',
                                amountText(prevPending)),
                            buildInfoRow(
                                'Advance Payment :', amountText(advanceAmount)),
                            buildInfoRow('Current Month Pending Amount :',
                                amountText(currentMonthPending)),
                            if (extraAdvance > 0)
                              buildInfoRow('Extra Advance Carried Forward :',
                                  amountText(extraAdvance, color: Colors.blue)),
                            buildInfoRow(
                                'Service :',
                                Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(
                                        billDetails.service?.name ?? '-'))),
                            buildInfoRow(
                                'Due Date :',
                                Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(formatDate(
                                        billDetails.dueDate.toString())))),
                            buildInfoRow(
                                'Created Date :',
                                Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Text(formatDate(
                                        billDetails.createdAt.toString())))),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    totalPayAmount > 0
                        ? Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            color: Colors.blue[50],
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  Expanded(
                                      child: Text(
                                    'TOTAL PAY AMOUNT :',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: const TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold)),
                                  )),
                                  amountText(totalPayAmount,
                                      color: Colors.black,
                                      fontSize: 16,
                                      bold: true),
                                ],
                              ),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
              );
            } else if (state is BillDetailsFailed) {
              return const Center(child: Text('Failed to load bills'));
            } else if (state is BillDetailsInternetError) {
              return const Center(
                  child: Text('Internet connection error',
                      style: TextStyle(color: Colors.red)));
            }
            return Container();
          },
        ),
      ),
    );
  }
}

num parseNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value;
  if (value is String) {
    final cleaned = value.replaceAll(RegExp(r'[^0-9\.\-]'), '');
    return num.tryParse(cleaned) ?? 0;
  }
  return 0;
}
