import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/my_bills/my_bills_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/resident/bills/bill_detail_screen.dart';
import 'package:ghp_society_management/view/resident/bills/home_bill_section.dart';
import 'package:ghp_society_management/view/resident/bills/view_ledger.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../../model/my_bill_model.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final ScrollController _scrollController = ScrollController();
  late MyBillsCubit _myBillsCubit;
  List<String> filterTypes = ["All", "Paid Bills", "Unpaid Bills"];
  List<String> selectedFilterList = ["all", "paid", "unpaid"];

  int selectedFilter = 0;

  @override
  void initState() {
    super.initState();
    _myBillsCubit = MyBillsCubit();
    _myBillsCubit.fetchMyBills(
        context: context, billTypes: selectedFilterList.first.toString());
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _myBillsCubit.loadMoreBills(context,
          filterTypes[selectedFilter]); // Load more bills based on current type
    }
  }

  Future onRefresh() async {
    _myBillsCubit = MyBillsCubit()
      ..fetchMyBills(
          context: context,
          billTypes: selectedFilterList[selectedFilter].toLowerCase());

    setState(() {});
  }

  bool showingBill = false;

  String formatDate(String? dateStr) {
    if (dateStr == null || dateStr.isEmpty) return '-';
    DateTime date = DateTime.parse(dateStr);
    return DateFormat('dd-MMM-yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<UserProfileCubit, UserProfileState>(
            listener: (context, state) {
          if (state is UserProfileLoaded) {
            Future.delayed(const Duration(milliseconds: 5), () {
              List<UnpaidBill> billData =
                  state.userProfile.first.data!.unpaidBills!;
              if (billData.isNotEmpty) {
                if (!showingBill) {
                  setState(() {
                    showingBill = true;
                  });
                  checkPaymentReminder(
                      context: context,
                      myUnpaidBill:
                          state.userProfile.first.data!.unpaidBills!.first);
                }
              }
            });
          }
        }),
      ],
      child: Scaffold(
        appBar: appbarWidget(title: 'My Bill History', actions: [
          GestureDetector(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => LedgerWebViewScreen()));
            },
            child: Container(
                margin: EdgeInsets.only(right: 10),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: AppTheme.greyColor),
                child: Text('View Ledgers',
                    style: TextStyle(
                        color: Colors.red, fontWeight: FontWeight.w600))),
          )
        ]),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: Column(
            children: [
              SizedBox(
                height: 50,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  itemCount: filterTypes.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedFilter = index;
                        });

                        _myBillsCubit = MyBillsCubit()
                          ..fetchMyBills(
                              context: context,
                              billTypes: selectedFilterList[selectedFilter]
                                  .toLowerCase());
                      },
                      child: Container(
                        margin: EdgeInsets.all(5.w),
                        decoration: BoxDecoration(
                            color: selectedFilter == index
                                ? AppTheme.primaryColor
                                : Colors.transparent,
                            border: Border.all(
                                color: selectedFilter == index
                                    ? AppTheme.primaryColor
                                    : Colors.grey.withOpacity(0.5)),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: EdgeInsets.only(left: 20.0.w, right: 20.w),
                          child: Center(
                            child: Text(
                              filterTypes[index].toString(),
                              style: GoogleFonts.poppins(
                                color: selectedFilter == index
                                    ? Colors.white
                                    : Colors.black54,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<MyBillsCubit, MyBillsState>(
                  bloc: _myBillsCubit,
                  builder: (context, state) {
                    if (state is MyBillsLoading) {
                      return notificationShimmerLoading();
                    } else if (state is MyBillsLogout) {
                      sessionExpiredDialog(context);
                    } else if (state is MyBillsLoaded) {
                      return ListView.builder(
                          padding: EdgeInsets.only(top: 10),
                          itemCount: state.hasMore
                              ? state.bills.length + 1
                              : state.bills.length,
                          itemBuilder: (_, index) {
                            if (index == state.bills.length) {
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            }
                            final bill = state.bills[index];

                            String delayData() {
                              return formatDate(bill.dueDate!.toString());
                            }

                            return Container(
                              margin: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              width: MediaQuery.sizeOf(context).width,
                              decoration: BoxDecoration(
                                  color: AppTheme.color4,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ListTile(
                                    dense: true,
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 8),
                                    leading: Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5.r),
                                            color: AppTheme.primaryColor
                                                .withOpacity(0.5)),
                                        child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                                ImageAssets.receiptImage,
                                                height: 20.h,
                                                width: 25.h,
                                                color: Colors.white))),
                                    title: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Flexible(
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(right: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    bill.service!.name
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14)),
                                                bill.status == 'paid'
                                                    ? Text(
                                                        "₹${bill.amount} paid on ${delayData()}",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12))
                                                    : Text(
                                                        "₹${max(0, parseNum(bill.amount) + parseNum(bill.prevMonthPending) - (parseNum(bill.installment) + parseNum(bill.advanceAmount)))} due on ${delayData()}",
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12))
                                              ],
                                            ),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text(bill.invoiceNumber.toString(),
                                                style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12)),
                                            SizedBox(height: 5),
                                            bill.status != 'paid'
                                                ? Container(
                                                    padding:
                                                        EdgeInsets.symmetric(
                                                            horizontal: 10,
                                                            vertical: 3),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(5),
                                                        color: bill.status ==
                                                                'paid'
                                                            ? Colors.green
                                                                .withOpacity(
                                                                    0.2)
                                                            : Colors.red
                                                                .withOpacity(
                                                                    0.2)),
                                                    child: Text(
                                                        capitalizeWords(bill
                                                            .status
                                                            .toString()),
                                                        style: TextStyle(
                                                            color:
                                                                bill.status ==
                                                                        'paid'
                                                                    ? Colors
                                                                        .green
                                                                    : Colors
                                                                        .red,
                                                            fontSize: 14)),
                                                  )
                                                : SizedBox(),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  bill.status == 'paid'
                                      ? Padding(
                                          padding: const EdgeInsets.only(
                                              bottom: 10, left: 15, right: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                  height: 30,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                              .width *
                                                          0.55,
                                                  child: marqueeText(
                                                      "👍Thanks for being a wonderful resident!")),
                                              GestureDetector(
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              BillDetailScreen(
                                                                  billId: bill
                                                                      .id
                                                                      .toString())));
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.green
                                                            .withOpacity(0.3)),
                                                    child: Text('View Details',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Container(
                                          margin: EdgeInsets.only(
                                              bottom: 10, left: 10, right: 10),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.white),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              payAmount(bill),
                                              Text(
                                                  "Property : ${bill.property!.aprtNo.toString() ?? ''}"
                                                      .toUpperCase(),
                                                  style: const TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14)),
                                              GestureDetector(
                                                onTap: () async {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              BillDetailScreen(
                                                                  billId: bill
                                                                      .id
                                                                      .toString())));
                                                },
                                                child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 16,
                                                        vertical: 5),
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
                                                        color: Colors.green
                                                            .withOpacity(0.3)),
                                                    child: Text('View Details',
                                                        style: TextStyle(
                                                            color: Colors.red,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600))),
                                              )
                                            ],
                                          ),
                                        )
                                ],
                              ),
                            );
                          });
                    } else if (state is MyBillsFailed) {
                      return emptyDataWidget(state.errorMsg.toString());
                    } else if (state is MyBillsInternetError) {
                      return const Center(
                        child: Text(
                          'Internet connection error',
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }
                    return emptyDataWidget(
                        "Something went wrong!"); // Default case, return empty container
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// pay bill widget
payAmount(Datum billDetails) {
  // Parsing amounts
  num billAmount = parseNum(billDetails.amount);
  num installment = parseNum(billDetails.installment);
  num prevPending = parseNum(billDetails.prevMonthPending);
  num advanceAmount = parseNum(billDetails.advanceAmount);
  // Calculate pending and extra advance
  num totalDue = billAmount + prevPending;
  num paidTotal = installment + advanceAmount;
  num currentMonthPending = max(0, totalDue - paidTotal);
  // TOTAL PAY AMOUNT = currentMonthPending
  num totalPayAmount = currentMonthPending;
// दिखाएँ:
  return Text(
    " ₹ ${totalPayAmount.toString() ?? '0.0'}",
    style: GoogleFonts.nunitoSans(
      textStyle: const TextStyle(
        color: Colors.black,
        fontSize: 14,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
