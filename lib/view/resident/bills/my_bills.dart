import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/controller/my_bills/my_bills_cubit.dart';
import 'package:ghp_society_management/payment_gateway_service.dart';
import 'package:ghp_society_management/view/resident/bills/bill_detail_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import '../../../model/user_profile_model.dart';

class MyBillsPage extends StatefulWidget {
  final String types;
  MyBillsPage({required this.types});

  @override
  MyBillsPageState createState() => MyBillsPageState();
}

class MyBillsPageState extends State<MyBillsPage> {
  final ScrollController _scrollController = ScrollController();
  late MyBillsCubit _myBillsCubit;

  @override
  void initState() {
    super.initState();
    // Initialize cubit and fetch bills based on the types passed
    _myBillsCubit = MyBillsCubit()
      ..fetchMyBills(context: context, billTypes: widget.types);
    _scrollController
        .addListener(_onScroll); // Add scroll listener for pagination
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    // If scrolled to the bottom, attempt to load more bills
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _myBillsCubit.loadMoreBills(
          context, widget.types); // Load more bills based on current type
    }
  }

  void _fetchData() {
    // Re-fetch the data when types are changed (when navigating between sections)
    _myBillsCubit.fetchMyBills(context: context, billTypes: widget.types);
  }

  @override
  void didUpdateWidget(covariant MyBillsPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Check if the bill type has changed, then re-fetch data
    if (oldWidget.types != widget.types) {
      _fetchData(); // Re-fetch data based on the new type
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyBillsCubit, MyBillsState>(
      bloc: _myBillsCubit, // Attach cubit
      builder: (context, state) {
        if (state is MyBillsLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is MyBillsLoaded) {
          return ListView.builder(
            controller: _scrollController,
            shrinkWrap: true,
            itemCount:
                state.hasMore ? state.bills.length + 1 : state.bills.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              if (index == state.bills.length) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              final bill = state.bills[index];
              int delay = bill.dueDateRemainDays!;
              String delayData() {
                if (delay > 0) {
                  return "Due in ${bill.dueDateRemainDays} Days";
                } else {
                  return bill.dueDateDelayDays == 0
                      ? 'Today Is Last Day'
                      : "${bill.dueDateDelayDays} Days Delay";
                }
              }

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(5)),
                child: Column(
                  children: [
                    ListTile(
                        dense: true,
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => BillDetailScreen(
                                    billId: bill.id.toString()))),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                        leading: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.r),
                                color: const Color(0xFFF2F1FE)),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(ImageAssets.receiptImage,
                                    height: 20.h,
                                    width: 25.h,
                                    color: bill.status == 'unpaid'
                                        ? Colors.red.withOpacity(0.5)
                                        : Colors.cyanAccent.withOpacity(0.5)))),
                        title: Text(bill.service!.name.toString(),
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16)),
                        subtitle: Text(bill.invoiceNumber.toString(),
                            style: TextStyle(
                                color: AppTheme.blueColor, fontSize: 12)),
                        trailing: GestureDetector(
                          onTap: () => payBillFun(
                              double.parse(bill.amount.toString()), context),
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: bill.status == 'paid'
                                      ? Colors.green.withOpacity(0.3)
                                      : Colors.red.withOpacity(0.3)),
                              child: Text(
                                  bill.status == 'paid' ? "Paid" : "Unpaid",
                                  style: TextStyle(
                                      color: bill.status == 'paid'
                                          ? Colors.green
                                          : Colors.red,
                                      fontWeight: FontWeight.w600))),
                        )),
                    Divider(height: 0, color: Colors.grey.withOpacity(0.2)),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                              "Amount ${bill.status == 'paid' ? 'Paid' : "Due"}: ₹${bill.amount.toString().replaceAll('.00', '')}",
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14)),
                          const SizedBox(width: 20),
                          bill.status == 'paid'
                              ? const SizedBox()
                              : Text(delayData().toString(),
                                  style: const TextStyle(color: Colors.red))
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        } else if (state is MyBillsFailed) {
          return Padding(
            padding: const EdgeInsets.all(15),
            child: Center(
                child: Text(
              state.errorMsg.toString(),
              style: const TextStyle(color: Colors.deepPurpleAccent),
            )),
          );
        } else if (state is MyBillsInternetError) {
          return const Center(
              child: Text(
            'Internet connection error',
            style: TextStyle(color: Colors.red),
          )); // Handle internet error
        }
        return Container(); // Return empty container if no state matches
      },
    );
  }
}

/// DUE BILL MANAGEMENT
void checkPaymentReminder(
    {required BuildContext context, required UnpaidBill myUnpaidBill}) {
  print("कोई ड्यू मैसेज नहीं दिखाना है।");
  if (myUnpaidBill != null && myUnpaidBill.status == 'unpaid') {
    DateTime today = DateTime.now();
    DateTime dueDate = DateTime.parse(myUnpaidBill.dueDate.toString());

    if (today.isAfter(dueDate.add(const Duration(days: 2)))) {
      // 2 दिन बाद → overdue
      print('calllllllled oooooooo');
      overDueBillAlertDialog(context, myUnpaidBill);
    } else if (today.isAfter(dueDate.subtract(const Duration(days: 3)))) {
      // 3 दिन पहले से लेकर due date + 2 दिन तक → due
      print('calllllllled 1111111');
      overDueBillAlertDialog(context, myUnpaidBill);
    } else {
      print("कोई ड्यू मैसेज नहीं दिखाना है।");
    }
  }
}

/// OVER DUE BILL MANAGEMENT
String checkBillStatus(BuildContext context, UnpaidBill myUnpaidBill) {
  DateTime dueDate =
      DateTime.parse(myUnpaidBill.dueDate.toString()); // e.g. "2025-04-10"
  String paymentStatus = myUnpaidBill.status.toString(); // 'paid' या 'unpaid'
  DateTime today = DateTime.now();

  String status = 'no_due';

  if (paymentStatus == 'unpaid') {
    if (today.isBefore(dueDate.add(const Duration(days: 3)))) {
      status = 'due';
    } else {
      status = 'overdue';
    }
  } else {
    status = 'paid';
  }
  print('Current Status: $status');

  return status;
}
