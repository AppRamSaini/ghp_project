import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/my_bills/my_bills_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/payment_gateway_service.dart';
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
                            padding: EdgeInsets.only(top: 10),
                              itemCount: state.hasMore
                                  ? state.bills.length + 1
                                  : state.bills.length,
                              itemBuilder: (_, index) {
                                if (index == state.bills.length) {
                                  return const Center(
                                      child:
                                          CircularProgressIndicator.adaptive());
                                }
                                final bill = state.bills[index];

                                String delayData() {
                                  return convertDateFormat(bill.dueDate!);
                                }

                                return Container(
                                  margin: EdgeInsets.only(left: 10,right: 10,bottom: 10),
                                  height:
                                      MediaQuery.sizeOf(context).height * 0.16,
                                  width: MediaQuery.sizeOf(context).width,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          fit: BoxFit.fill,
                                          image: AssetImage(
                                              ImageAssets.billFrame))),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      ListTile(
                                          dense: true,
                                          onTap: () => Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (_) =>
                                                      BillDetailScreen(
                                                          billId: bill.id
                                                              .toString()))),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 8),
                                          leading: Container(
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.r),
                                                  color: Colors.black
                                                      .withOpacity(0.1)),
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(10.0),
                                                  child: Image.asset(ImageAssets.receiptImage, height: 20.h, width: 25.h, color: Colors.white))),
                                          title: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  bill.service!.name.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14)),
                                              Text(
                                                  bill.invoiceNumber.toString(),
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12)),
                                            ],
                                          ),
                                          subtitle: bill.status == 'paid' ? Text("₹ ${bill.amount} paid On ${delayData()}", style: const TextStyle(color: Colors.white, fontSize: 10)) : Text("Due On ${delayData()}", style: const TextStyle(color: Colors.white, fontSize: 10))),
                                      bill.status == 'paid'
                                          ? Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 15,
                                                  right: 10),
                                              child: SizedBox(
                                                  height: 30,
                                                  width:
                                                      MediaQuery.sizeOf(context)
                                                          .width,
                                                  child: marqueeText(
                                                      "👍Thanks for being a wonderful resident!")))
                                          : Container(
                                              margin: EdgeInsets.only(
                                                  bottom: 10,
                                                  left: 10,
                                                  right: 10),
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10, vertical: 5),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.white),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('₹ ${bill.amount}',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold))),
                                                  Text("D-123 1st",
                                                      style: const TextStyle(
                                                          color: Colors.black45,
                                                          fontSize: 14)),
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await LocalStorage
                                                          .localStorage
                                                          .setString(
                                                              'bill_id',
                                                              bill.id
                                                                  .toString());
                                                      payBillFun(
                                                          double.parse(bill
                                                              .amount
                                                              .toString()),
                                                          context);
                                                    },
                                                    child: Container(
                                                        padding: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 16,
                                                            vertical: 5),
                                                        decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                    30),
                                                            color: Colors.green
                                                                .withOpacity(
                                                                    0.3)),
                                                        child: Text('Pay',
                                                            style: TextStyle(
                                                                color:
                                                                    Colors.red,
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
