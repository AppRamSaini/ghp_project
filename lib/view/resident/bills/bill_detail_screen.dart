// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/bill_details/bill_details_cubit.dart';
import 'package:ghp_society_management/model/my_bill_details_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BillDetailScreen extends StatefulWidget {
  String billId;

  BillDetailScreen({super.key, required this.billId});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}

class _BillDetailScreenState extends State<BillDetailScreen> {
  int selectedValue = 0;

  late BillDetailsCubit _billDetailsCubit;

  @override
  void initState() {
    super.initState();
    _billDetailsCubit = BillDetailsCubit();
    _billDetailsCubit.fetchMyBillsDetails(context, widget.billId);
  }

  BuildContext? dialogueContext;

  Future onRefresh() async {
    _billDetailsCubit.fetchMyBillsDetails(context, widget.billId);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Bills Details'),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BlocBuilder<BillDetailsCubit, BillsDetailsState>(
          bloc: _billDetailsCubit, // Attach cubit
          builder: (context, state) {
            if (state is BillDetailsLoading) {
              return notificationShimmerLoading();
            } else if (state is BillDetailsLoaded) {
              var billDetails = state.bills.first;
              DateTime parsedDate =
                  DateTime.parse(billDetails.dueDate.toString());
              DateFormat formatter = DateFormat('dd-MMM-yyyy');

              String formattedDate = formatter.format(parsedDate);

              DateTime parsedDate2 =
                  DateTime.parse(billDetails!.dueDate!.toString());

              String createdDate = formatter.format(parsedDate2);

              return SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3))),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        billDetails.service!.name.toString(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)))),
                                Expanded(
                                  child: Text(
                                      capitalizeWords(
                                          billDetails.status.toString()),
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color:
                                                  billDetails.status == 'unpaid'
                                                      ? Colors.red
                                                      : Colors.green,
                                              fontSize: 16))),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('Invoice No : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14)))),
                                Expanded(
                                  child:
                                      Text(billDetails.invoiceNumber.toString(),
                                          style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14),
                                          )),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(children: [
                              Expanded(
                                  child: Text('Current Month Payment : ',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black87,
                                              fontSize: 14)))),
                              Expanded(
                                  child: Text(
                                      '₹ ${billDetails.amount.toString()}',
                                      style: TextStyle(
                                          color: Colors.black87, fontSize: 14)))
                            ]),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('Installment Payment : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14)))),
                                Expanded(
                                    child: Text(
                                        "₹ ${billDetails.installment ?? '0.0'}",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14))))
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                        'Previous Month Pending Payment : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14)))),
                                Expanded(
                                    child: Text(
                                        "₹ ${billDetails.prevMonthPending ?? '0.0'}",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14))))
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('Advance payment : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14)))),
                                Expanded(
                                    child: Text(
                                        "₹ ${billDetails.advanceAmount ?? '0.0'}",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14))))
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('Service : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14)))),
                                Expanded(
                                  child:
                                      Text(billDetails.service!.name.toString(),
                                          style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14),
                                          )),
                                ),
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('Due Date : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14)))),
                                Expanded(
                                    child: Text(formattedDate,
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14))))
                              ],
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Divider(
                                    color: Colors.grey.withOpacity(0.2))),
                            Row(
                              children: [
                                Expanded(
                                    child: Text('Created Date : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14)))),
                                Expanded(
                                    child: Text(createdDate,
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14))))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: Colors.grey.withOpacity(0.3))),
                        child: Row(
                          children: [
                            Expanded(
                                child: Text('TOTAL PAY AMOUNT : ',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 16)))),
                            Expanded(child: totalPayAmount(billDetails))
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else if (state is BillDetailsFailed) {
              return const Center(
                  child: Text('Failed to load bills')); // Handle error state
            } else if (state is BillDetailsInternetError) {
              return const Center(
                  child: Text(
                'Internet connection error',
                style: TextStyle(color: Colors.red),
              )); // Handle internet error
            }
            return Container(); // Return empty container if no state matches
          },
        ),
      ),
    );
  }
}

/// pay bill widget
totalPayAmount(Bill bill) {
  num _toNum(dynamic v) {
    if (v == null) return 0;
    if (v is num) return v;
    if (v is String) {
      final cleaned = v.replaceAll(RegExp(r'[^0-9\.\-]'), '');
      return num.tryParse(cleaned) ?? 0;
    }
    return 0;
  }

// जहां widget build हो रहा है:
  final num billAmount = _toNum(bill.amount);
  final num prevPending = _toNum(bill.prevMonthPending);
  final num payAmount = billAmount + prevPending;

// दिखाएँ:
  return Text(
    " ₹ ${payAmount.toString() ?? '0.0'}",
    style: GoogleFonts.nunitoSans(
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
