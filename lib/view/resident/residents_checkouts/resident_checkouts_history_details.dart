import 'package:ghp_app/constants/export.dart';
import 'package:ghp_app/controller/resident_checkout_log/resident_checkouts_history_details/resident_checkouts_details_cubit.dart';
import 'package:ghp_app/model/resident_checkout_history_details_model.dart';
import 'package:intl/intl.dart';

class ResidentCheckoutsHistoryDetails extends StatefulWidget {
  bool forResident;
  final String userId;
  ResidentCheckoutsHistoryDetails(
      {super.key, this.forResident = false, required this.userId});

  @override
  State<ResidentCheckoutsHistoryDetails> createState() =>
      _ResidentCheckoutsHistoryDetailsState();
}

class _ResidentCheckoutsHistoryDetailsState
    extends State<ResidentCheckoutsHistoryDetails> {
  late ResidentCheckoutsHistoryDetailsCubit
      _residentCheckoutsHistoryDetailsCubit;

  @override
  void initState() {
    super.initState();
    _residentCheckoutsHistoryDetailsCubit =
        ResidentCheckoutsHistoryDetailsCubit();
    if (widget.forResident) {
      _residentCheckoutsHistoryDetailsCubit
          .fetchResidentCheckoutsHistoryDetailsApi();
    } else {
      _residentCheckoutsHistoryDetailsCubit
          .fetchResidentCheckoutsHistoryDetailsApi(
              userId: widget.userId.toString());
    }
  }

  String? fromDate;
  String? toDate;

  Future<void> selectDateRange(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime lastDayOfMonth = DateTime(now.year, now.month + 1, 0);

    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2015, 8),
      lastDate: lastDayOfMonth,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      initialDateRange:
          DateTimeRange(start: now, end: now.add(const Duration(days: 3))),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData(
            datePickerTheme: DatePickerThemeData(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.transparent,
              headerForegroundColor: Colors.white,
              headerBackgroundColor: AppTheme.primaryColor,
              dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
                if (states.contains(MaterialState.selected)) {
                  return AppTheme.primaryColor;
                }
                return Colors.white;
              }),
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 100), // Removed extra bottom padding
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: child ?? const SizedBox(),
              ),
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        fromDate = DateFormat('yyyy-MM-dd').format(picked.start);
        toDate = DateFormat('yyyy-MM-dd').format(picked.end);
      });

      _residentCheckoutsHistoryDetailsCubit
          .fetchResidentCheckoutsHistoryDetailsApi(
              userId: widget.userId.toString(),
              fromDate: fromDate,
              toDate: toDate);
    }
  }

  Future onRefresh() async {
    if (widget.forResident) {
      _residentCheckoutsHistoryDetailsCubit
          .fetchResidentCheckoutsHistoryDetailsApi();
    } else {
      _residentCheckoutsHistoryDetailsCubit
          .fetchResidentCheckoutsHistoryDetailsApi(
              userId: widget.userId.toString());
    }

    fromDate = null;
    toDate = null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20.h, left: 6.h, bottom: 20.h),
                child: Row(children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white)),
                  SizedBox(width: 10.w),
                  Text('Checkout History',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600)))
                ])),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: BlocBuilder<ResidentCheckoutsHistoryDetailsCubit,
                        ResidentCheckoutsHistoryDetailsState>(
                    bloc: _residentCheckoutsHistoryDetailsCubit,
                    builder: (context, state) {
                      if (state is ResidentCheckoutsHistoryDetailsLoading) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.deepPurpleAccent));
                      } else if (state
                          is ResidentCheckoutsHistoryDetailsLoaded) {
                        ResidentCheckoutsHistoryDetailsData
                            residentsCheckoutsData =
                            state.residentCheckoutsHistoryDetailsModal.data!;

                        return RefreshIndicator(
                          onRefresh: onRefresh,
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: ListView(
                              // crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(
                                          color:
                                              Colors.grey.withOpacity(0.15))),
                                  child: Column(
                                    children: [
                                      ListTile(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 5),
                                          leading: CircleAvatar(
                                              radius: 30.h,
                                              backgroundImage: NetworkImage(
                                                  residentsCheckoutsData
                                                      .user!.imageUrl
                                                      .toString()),
                                              onBackgroundImageError:
                                                  (error, stack) =>
                                                      const AssetImage(
                                                          'assets/images/default.jpg')),
                                          title: Text(capitalizeWords(residentsCheckoutsData.user!.name.toString()),
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16.sp,
                                                      fontWeight: FontWeight.w500))),
                                          subtitle: Text("+91 ${residentsCheckoutsData.user!.phone.toString()}", style: GoogleFonts.nunitoSans(textStyle: TextStyle(color: Colors.green, fontSize: 14.sp, fontWeight: FontWeight.w500))),
                                          trailing: GestureDetector(child: SizedBox(height: 100, width: 80, child: Image.asset('assets/images/qr-image.png')))),
                                      Divider(
                                          color: Colors.grey.withOpacity(0.2)),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10, bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                    residentsCheckoutsData
                                                        .user!.member!.blockName
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12)),
                                                const Text(
                                                  "Tower Name",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                    residentsCheckoutsData.user!
                                                        .member!.floorNumber
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12)),
                                                const Text(
                                                  "Floor No",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            ),
                                            Column(
                                              children: [
                                                Text(
                                                    residentsCheckoutsData
                                                        .user!.member!.aprtNo
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        fontSize: 12)),
                                                const Text(
                                                  "Property No",
                                                  style: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 15),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Center(
                                        child: Text("Checkout info",
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w500)))),
                                    GestureDetector(
                                      onTap: () {
                                        selectDateRange(context);
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 5, bottom: 5),
                                        decoration: BoxDecoration(
                                            color: Colors.transparent,
                                            border: Border.all(
                                                color: const Color(0xFFD9D9D9)),
                                            borderRadius:
                                                BorderRadius.circular(6.r)),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10.0.w, vertical: 8),
                                          child: Center(
                                              child: Text(
                                            fromDate == null
                                                ? 'YY-MM-DD  to  YY-MM-DD'
                                                : "${formatDateOnly(fromDate.toString())} - ${formatDateOnly(toDate.toString())}",
                                            style: GoogleFonts.poppins(
                                              color: const Color.fromARGB(
                                                  255, 102, 101, 101),
                                              fontSize: 11.sp,
                                              fontWeight: FontWeight.w400,
                                            ),
                                          )),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                residentsCheckoutsData.logs!.isEmpty
                                    ? const Center(
                                        child: Text(
                                            'Check-outs History Not Found!',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color:
                                                    Colors.deepPurpleAccent)))
                                    : ListView.builder(
                                        shrinkWrap: true,
                                        physics: const BouncingScrollPhysics(),
                                        itemCount:
                                            residentsCheckoutsData.logs!.length,
                                        itemBuilder: (_, index) {
                                          checkOut() {
                                            DateTime outTime;
                                            if (residentsCheckoutsData
                                                    .logs![index].checkoutAt !=
                                                null) {
                                              outTime = DateTime.parse(
                                                  residentsCheckoutsData
                                                      .logs![index].checkoutAt!
                                                      .toString());
                                              return formatTime(outTime);
                                            } else {
                                              return 'N/A';
                                            }
                                          }

                                          checkIn() {
                                            DateTime inTime;
                                            if (residentsCheckoutsData
                                                    .logs![index].checkinAt !=
                                                null) {
                                              inTime = DateTime.parse(
                                                  residentsCheckoutsData
                                                      .logs![index].checkinAt!
                                                      .toString());
                                              return formatTime(inTime);
                                            } else {
                                              return 'N/A';
                                            }
                                          }

                                          return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              index == 0
                                                  ? Text(
                                                      'Date : ${formatDateOnly(residentsCheckoutsData.logs![0].checkinAt!.toString())} (${formatCheckoutDate(residentsCheckoutsData.logs![0].checkinAt!.toString())})',
                                                      style: const TextStyle(
                                                          fontSize: 14))
                                                  : const SizedBox(),
                                              const SizedBox(height: 10),
                                              Container(
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              8),
                                                      border: Border.all(
                                                          color: Colors.grey
                                                              .withOpacity(
                                                                  0.2))),
                                                  child: ListTile(
                                                      dense: true,
                                                      title: Text(
                                                          'In-Time : ${checkIn()}',
                                                          style: const TextStyle(
                                                              fontSize: 12)),
                                                      trailing: Text(
                                                          'Out-Time : ${checkOut()}',
                                                          style: const TextStyle(
                                                              fontSize: 12)))),
                                            ],
                                          );
                                        })
                              ],
                            ),
                          ),
                        );
                      } else if (state
                          is ResidentCheckoutsHistoryDetailsError) {
                        return Center(
                            child: Text(state.errorMsg.toString(),
                                style: const TextStyle(
                                    color: Colors.deepPurpleAccent)));
                      } else {
                        return const SizedBox();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
