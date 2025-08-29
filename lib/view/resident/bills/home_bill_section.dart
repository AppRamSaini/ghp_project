import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/resident/bills/bill_detail_screen.dart';
import 'package:ghp_society_management/view/resident/bills/my_bill_history.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:shimmer/shimmer.dart';

import '../../../model/user_profile_model.dart';

class MyBillsPage extends StatefulWidget {
  final String types;

  const MyBillsPage({super.key, required this.types});

  @override
  MyBillsPageState createState() => MyBillsPageState();
}

class MyBillsPageState extends State<MyBillsPage> {
  final ScrollController _scrollController = ScrollController();
  late MyBillsCubit _myBillsCubit;

  @override
  void initState() {
    super.initState();
    _myBillsCubit = MyBillsCubit();
    _myBillsCubit.fetchMyBills(context: context, billTypes: widget.types);
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
      _myBillsCubit.loadMoreBills(
          context, widget.types); // Load more bills based on current type
    }
  }

  void _fetchData() {
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
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: size.width * 0.03),
              width: size.width,
              height: size.height * 0.15,
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        } else if (state is MyBillsLoaded) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                state.bills.isNotEmpty ? 1 : 0,
                (index) {
                  final bill = state.bills[index];

                  String delayData() {
                    return convertDateFormat(bill.dueDate!);
                  }

                  return Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    height: MediaQuery.sizeOf(context).height * 0.16,
                    width: MediaQuery.sizeOf(context).width * 0.97,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            fit: BoxFit.fill,
                            image: AssetImage(ImageAssets.billFrame))),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                                margin: EdgeInsets.only(left: 10, top: 10),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5.r),
                                    color: Colors.black.withOpacity(0.1)),
                                child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Image.asset(ImageAssets.receiptImage,
                                        height: 20.h,
                                        width: 25.h,
                                        color: Colors.white))),
                            SizedBox(width: 10),
                            Flexible(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(bill.service!.name.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 14)),
                                        bill.status == 'paid'
                                            ? Text(
                                                "₹ ${bill.amount} paid On ${delayData()}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10))
                                            : Text("Due On ${delayData()}",
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10))
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(bill.invoiceNumber.toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12)),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 3),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: bill.status == 'paid'
                                                  ? Colors.green
                                                      .withOpacity(0.2)
                                                  : Colors.red
                                                      .withOpacity(0.2)),
                                          child: Text(
                                              capitalizeWords(
                                                  bill.status.toString()),
                                              style: TextStyle(
                                                  color: bill.status == 'paid'
                                                      ? Colors.green
                                                      : Colors.red,
                                                  fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
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
                                    SizedBox(),
                                    GestureDetector(
                                      onTap: () async {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) =>
                                                    BillDetailScreen(
                                                        billId: bill.id
                                                            .toString())));
                                        // await LocalStorage.localStorage
                                        //     .setString(
                                        //         'bill_id', bill.id.toString());
                                        // payBillFun(
                                        //     double.parse(
                                        //         bill.amount.toString()),
                                        //     context);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 16, vertical: 5),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.green
                                                  .withOpacity(0.3)),
                                          child: Text('View Details',
                                              style: TextStyle(
                                                  color: Colors.red,
                                                  fontWeight:
                                                      FontWeight.w600))),
                                    )
                                  ],
                                ),
                              ),
                      ],
                    ),
                  );
                },
              ),
            ),
          );
        } else if (state is MyBillsFailed) {
          return SizedBox.shrink();
        } else if (state is MyBillsInternetError) {
          return SizedBox.shrink(); // Handle internet error
        }
        return SizedBox.shrink(); // Return empty container if no state matches
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
