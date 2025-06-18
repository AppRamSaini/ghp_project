// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/bill_details/bill_details_cubit.dart';
import 'package:ghp_society_management/payment_gateway_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class BillDetailScreen extends StatefulWidget {
  String billId;

  BillDetailScreen({super.key, required this.billId});

  @override
  State<BillDetailScreen> createState() => _BillDetailScreenState();
}
//

class _BillDetailScreenState extends State<BillDetailScreen> {
  int selectedValue = 0;

  late BillDetailsCubit _billDetailsCubit;

  @override
  void initState() {
    super.initState();
    _billDetailsCubit = BillDetailsCubit()
      ..fetchMyBillsDetails(context, widget.billId);
  }

  BuildContext? dialogueContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Bills Details',
          style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600)))),
      body: BlocBuilder<BillDetailsCubit, BillsDetailsState>(
        bloc: _billDetailsCubit, // Attach cubit
        builder: (context, state) {
          if (state is BillDetailsLoading) {
            return const Center(
                child: CircularProgressIndicator());
          } else if (state is BillDetailsLoaded) {
            var billDetails = state.bills.first;
            DateTime parsedDate =
                DateTime.parse(billDetails.dueDate.toString());
            DateFormat formatter = DateFormat('dd-MMM-yyyy');

            String formattedDate = formatter.format(parsedDate);

            DateTime parsedDate2 =
                DateTime.parse(billDetails.createdAt.toString());

            String createdDate = formatter.format(parsedDate2);

            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color:
                                  Colors.grey.withOpacity(0.3))),
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                      billDetails.service.name
                                          .toString(),
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight:
                                                  FontWeight
                                                      .w600)))),
                              Expanded(
                                child: Text(
                                    capitalizeWords(billDetails
                                        .status
                                        .toString()),
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: billDetails
                                                        .status ==
                                                    'unpaid'
                                                ? Colors.red
                                                : Colors.green,
                                            fontSize: 16))),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4),
                              child: Divider(
                                  color: Colors.grey
                                      .withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Invoice No : ',
                                      style:
                                          GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize:
                                                      14)))),
                              Expanded(
                                child: Text(
                                    billDetails.invoiceNumber
                                        .toString(),
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14),
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4),
                              child: Divider(
                                  color: Colors.grey
                                      .withOpacity(0.2))),
                          Row(children: [
                            Expanded(
                                child: Text('Bill Amount ',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 14)))),
                            Expanded(
                                child: Text(
                                    '₹ ${billDetails.amount.toString()}',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 14)))
                          ]),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4),
                              child: Divider(
                                  color: Colors.grey
                                      .withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Service : ',
                                      style:
                                          GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize:
                                                      14)))),
                              Expanded(
                                child: Text(
                                    billDetails.service.name
                                        .toString(),
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14),
                                    )),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4),
                              child: Divider(
                                  color: Colors.grey
                                      .withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Due Date : ',
                                      style:
                                          GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize:
                                                      14)))),
                              Expanded(
                                  child: Text(formattedDate,
                                      style:
                                          GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize:
                                                      14))))
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 4),
                              child: Divider(
                                  color: Colors.grey
                                      .withOpacity(0.2))),
                          Row(
                            children: [
                              Expanded(
                                  child: Text('Created Date : ',
                                      style:
                                          GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize:
                                                      14)))),
                              Expanded(
                                  child: Text(createdDate,
                                      style:
                                          GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors
                                                      .black87,
                                                  fontSize:
                                                      14))))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  billDetails.status == 'unpaid'
                      ? MaterialButton(
                          height: 45,
                          minWidth:
                              MediaQuery.sizeOf(context).width *
                                  0.9,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(30)),
                          onPressed: () async {
                            await LocalStorage.localStorage
                                .setString('bill_id',
                                    billDetails.id.toString());
                            payBillFun(
                                double.parse(billDetails.amount
                                    .toString()),
                                context);
                          },
                          color: AppTheme.primaryColor,
                          child: const Text('Pay Now',
                              style:
                                  TextStyle(color: Colors.white)))
                      : const SizedBox()
                ],
              ),
            );
          } else if (state is BillDetailsFailed) {
            return const Center(
                child: Text(
                    'Failed to load bills')); // Handle error state
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
    );
  }
}
