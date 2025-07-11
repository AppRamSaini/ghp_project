import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/export.dart';
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
          return


            SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
                children: List.generate(
                    state.hasMore ? state.bills.length + 1 : state.bills.length,
                    (index) {
              if (index == state.bills.length) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              final bill = state.bills[index];

              String delayData() {
                return convertDateFormat(bill.dueDate!);
                // if (delay > 0) {
                //   return "Due in ${bill.dueDateRemainDays} Days";
                // } else {
                //   return bill.dueDateDelayDays == 0
                //       ? 'Today Is Last Day'
                //       : "${bill.dueDateDelayDays} Days Delay";
                // }
              }

              return Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                height: MediaQuery.sizeOf(context).height * 0.16,
                width: MediaQuery.sizeOf(context).width*0.97,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(ImageAssets.billFrame))),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                color: Colors.black.withOpacity(0.1)),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(ImageAssets.receiptImage,
                                    height: 20.h,
                                    width: 25.h,
                                    color: Colors.white))),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(bill.service!.name.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 14)),
                            Text(bill.invoiceNumber.toString(),
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          ],
                        ),
                        subtitle: bill.status == 'paid'
                            ? Text("₹ ${bill.amount} paid On ${delayData()}",

                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10))
                            : Text("Due On ${delayData()}",
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10))),
                    bill.status == 'paid'
                        ? Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 15, right: 10),
                            child: SizedBox(
                                height: 30,
                                width: MediaQuery.sizeOf(context).width,
                                child: marqueeText(
                                    "👍Thanks for being a wonderful resident!")))
                        : Container(
                            margin: EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('₹ ${bill.amount}',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold))),
                                Text("D-123 1st",
                                    style: const TextStyle(
                                        color: Colors.black45, fontSize: 14)),
                                GestureDetector(
                                  onTap: () async {
                                    await LocalStorage.localStorage.setString(
                                        'bill_id', bill.id.toString());
                                    payBillFun(
                                        double.parse(bill.amount.toString()),
                                        context);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 5),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30),
                                          color: Colors.green.withOpacity(0.3)),
                                      child: Text('Pay',
                                          style: TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.w600))),
                                )
                              ],
                            ),
                          )
                  ],
                ),
              );
            })),
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
  if (myUnpaidBill != null && myUnpaidBill.status == 'unpaid') {
    DateTime today = DateTime.now();
    DateTime dueDate = DateTime.parse(myUnpaidBill.dueDate.toString());

    if (today.isAfter(dueDate.add(const Duration(days: 2)))) {
      // 2 दिन बाद → overdue
      print('calllllllled ');
      overDueBillAlertDialog(context, myUnpaidBill);
    } else if (today.isAfter(dueDate.subtract(const Duration(days: 3)))) {
      // 3 दिन पहले से लेकर due date + 2 दिन तक → due
      print('calllllllled ');
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
