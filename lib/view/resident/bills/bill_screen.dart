import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/controller/my_bills/my_bills_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/resident/bills/bill_detail_screen.dart';
import 'package:ghp_society_management/view/resident/bills/my_bills.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';

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
    context.read<UserProfileCubit>().fetchUserProfile();
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
        appBar: AppBar(
            title: Text('Bills',
                style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600)))),
        body: SafeArea(
          child: Container(
            width: double.infinity,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), topRight: Radius.circular(8))),
            child: RefreshIndicator(
              onRefresh: onRefresh,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: AppTheme.greyColor,
                        borderRadius: BorderRadius.circular(8.r)),
                    child: BlocBuilder<MyBillsCubit, MyBillsState>(
                      bloc: _myBillsCubit, // Attach cubit to builder
                      builder: (context, state) {
                        // if (state is MyBillsLoaded) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                                'Total Paid Amount : ₹ ${_myBillsCubit.paidAmount.toString()}/-',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                            const SizedBox(height: 3),
                            Text(
                                'Total UnPaid Amount : ₹ ${_myBillsCubit.amount.toString()}/-',
                                style: TextStyle(
                                    color: AppTheme.primaryColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ],
                        );

                        //
                        // } else {
                        //   return Column(
                        //     mainAxisSize: MainAxisSize.min,
                        //     children: [
                        //       Text('Total Paid Amount : ₹ 0 /-',
                        //           style: TextStyle(
                        //               color: AppTheme.primaryColor,
                        //               fontSize: 14.sp,
                        //               fontWeight: FontWeight.w500)),
                        //       const SizedBox(height: 3),
                        //       Text('Total Unpaid Amount : ₹ 0/-',
                        //           style: TextStyle(
                        //               color: AppTheme.primaryColor,
                        //               fontSize: 14.sp,
                        //               fontWeight: FontWeight.w500)),
                        //     ],
                        //   );
                        // }
                      },
                    ),
                  ),
                  SizedBox(height: 10.h),
                  SizedBox(
                    height: 50,
                    width: MediaQuery.of(context).size.width,
                    child: ListView.builder(
                      padding: const EdgeInsets.only(left: 5),
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
                                borderRadius: BorderRadius.circular(5.r)),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 20.0.w, right: 20.w),
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
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is MyBillsLogout) {
                          sessionExpiredDialog(context);
                        } else if (state is MyBillsLoaded) {
                          return ListView.builder(
                            controller: _scrollController,
                            shrinkWrap: true,
                            itemCount: state.hasMore
                                ? state.bills.length + 1
                                : state.bills.length,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemBuilder: (context, index) {
                              if (index == state.bills.length) {
                                return const Center(
                                    child:
                                        CircularProgressIndicator.adaptive());
                              }
                              final bill = state.bills[index];
                              int delay = bill.dueDateRemainDays!;
                              String delayData() {
                                final remainDays = bill.dueDateRemainDays ?? 0;
                                final delayDays = bill.dueDateDelayDays ?? 0;

                                if (delay != null && delay > 0) {
                                  return "Due in $remainDays ${remainDays > 1 ? 'days' : 'day'}";
                                } else if (delayDays == 0) {
                                  return 'Today is the last day';
                                } else {
                                  return "$delayDays ${delayDays > 1 ? 'days' : 'day'} overdue";
                                }
                              }

                              return Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 3),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.grey.withOpacity(0.2)),
                                    borderRadius: BorderRadius.circular(5)),
                                child: Column(
                                  children: [
                                    ListTile(
                                        dense: true,
                                        onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (_) => BillDetailScreen(
                                                    billId:
                                                        bill.id.toString()))),
                                        contentPadding: const EdgeInsets.symmetric(
                                            horizontal: 8),
                                        leading: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5.r),
                                                color: const Color(0xFFF2F1FE)),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(10.0),
                                                child: Image.asset(
                                                    ImageAssets.receiptImage,
                                                    height: 20.h,
                                                    width: 25.h,
                                                    color: bill.status == 'unpaid'
                                                        ? Colors.red
                                                            .withOpacity(0.5)
                                                        : Colors.cyanAccent
                                                            .withOpacity(0.5)))),
                                        title: Text(bill.service!.name.toString(), style: const TextStyle(color: Colors.black, fontSize: 14)),
                                        subtitle: Text(bill.invoiceNumber.toString(), style: const TextStyle(color: Colors.deepPurpleAccent, fontSize: 10)),
                                        trailing: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7), decoration: BoxDecoration(borderRadius: BorderRadius.circular(30), color: bill.status == 'paid' ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3)), child: Text(bill.status == 'paid' ? "Paid" : "Unpaid", style: TextStyle(color: bill.status == 'paid' ? Colors.green : Colors.red, fontWeight: FontWeight.w600)))),
                                    Divider(
                                        height: 0,
                                        color: Colors.grey.withOpacity(0.2)),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                              "Amount ${bill.status == 'paid' ? 'Paid' : "Due"}: ₹${bill.amount.toString().replaceAll('.00', '')}",
                                              style: const TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14)),
                                          const SizedBox(width: 20),
                                          bill.status == 'paid'
                                              ? const SizedBox()
                                              : Text(delayData().toString(),
                                                  style: const TextStyle(
                                                      color: Colors.red))
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
                                  child: Text(state.errorMsg.toString(),
                                      style: const TextStyle(
                                          color: Colors.deepPurpleAccent))));
                        } else if (state is MyBillsInternetError) {
                          return const Center(
                            child: Text(
                              'Internet connection error',
                              style: TextStyle(color: Colors.red),
                            ),
                          );
                        }
                        return Container(); // Default case, return empty container
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
