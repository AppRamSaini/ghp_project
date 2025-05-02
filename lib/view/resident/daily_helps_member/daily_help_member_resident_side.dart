import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/daliy_helps_member/daily_help_listing/daily_help_cubit.dart';
import 'package:ghp_society_management/view/security_staff/daliy_help/daily_help_details.dart';
import 'package:ghp_society_management/view/resident/daily_helps_member/daily_help_gatepass.dart';
import 'package:ghp_society_management/view/security_staff/scan_qr.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

import '../../security_staff/daliy_help/daily_helps_members.dart';

class DailyHelpListingHistoryResidentSide extends StatefulWidget {
  const DailyHelpListingHistoryResidentSide({super.key});

  @override
  State<DailyHelpListingHistoryResidentSide> createState() =>
      DailyHelpListingHistoryResidentSideState();
}

class DailyHelpListingHistoryResidentSideState
    extends State<DailyHelpListingHistoryResidentSide> {
  late DailyHelpListingCubit _dailyHelpListingCubit;

  bool searchBarOpen = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _dailyHelpListingCubit = DailyHelpListingCubit();
    _dailyHelpListingCubit.fetchDailyHelpsApi();
    super.initState();
  }

  Future onRefresh() async {
    _dailyHelpListingCubit.fetchDailyHelpsApi();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<NoticeModelCubit, NoticeModelState>(
      listener: (context, state) {
        if (state is NoticeModelLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            searchBarOpen
                                ? const SizedBox()
                                : Row(children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Icon(Icons.arrow_back,
                                            color: Colors.white)),
                                    SizedBox(width: 10.w),
                                    Text('Daily Help',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.w600)))
                                  ]),
                            SearchBarAnimation(
                                searchBoxColour: AppTheme.primaryLiteColor,
                                buttonColour: AppTheme.primaryLiteColor,
                                searchBoxWidth:
                                    MediaQuery.of(context).size.width / 1.1,
                                isSearchBoxOnRightSide: false,
                                textEditingController: textController,
                                isOriginalAnimation: true,
                                enableKeyboardFocus: true,
                                enteredTextStyle: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600)),
                                onExpansionComplete: () {
                                  setState(() {
                                    searchBarOpen = true;
                                  });
                                },
                                onCollapseComplete: () {
                                  setState(() {
                                    searchBarOpen = false;
                                    textController.clear();
                                    _dailyHelpListingCubit.fetchDailyHelpsApi();
                                  });
                                },
                                onPressButton: (isSearchBarOpens) {
                                  setState(() {
                                    searchBarOpen = true;
                                  });
                                },
                                onChanged: (value) {
                                  _dailyHelpListingCubit.searchQueryData(value);
                                },
                                trailingWidget: const Icon(Icons.search,
                                    size: 20, color: Colors.white),
                                secondaryButtonWidget: const Icon(Icons.close,
                                    size: 20, color: Colors.white),
                                buttonWidget: const Icon(Icons.search,
                                    size: 20, color: Colors.white))
                          ]))),
              SizedBox(height: 5.h),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: RefreshIndicator(
                    onRefresh: onRefresh,
                    child: BlocBuilder<DailyHelpListingCubit,
                        DailyHelpListingState>(
                      bloc: _dailyHelpListingCubit,
                      builder: (context, state) {
                        if (state is DailyHelpListingLoading) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        }
                        if (state is DailyHelpListingError) {
                          return Center(
                              child: Text(state.errorMsg,
                                  style: const TextStyle(
                                      color: Colors.deepPurpleAccent)));
                        }

                        var newHistoryLogs =
                            _dailyHelpListingCubit.dailyHelpMemberList;

                        if (state is DailyHelpListingSearchLoaded) {
                          newHistoryLogs = state.dailyHelpMemberList;
                        }

                        if (newHistoryLogs.isEmpty) {
                          return const Center(
                              child: Text('Member not found!',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent)));
                        }

                        return ListView.builder(
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: newHistoryLogs.length,
                          padding: const EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            lastChecking() {
                              return newHistoryLogs[index].lastCheckinDetail !=
                                      null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Row(
                                        children: [
                                          Text(
                                              newHistoryLogs[index]
                                                          .lastCheckinDetail!
                                                          .checkoutAt ==
                                                      null
                                                  ? "Last Check-In : "
                                                  : "Last Check-Out : ",
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                          Text(
                                              newHistoryLogs[index]
                                                          .lastCheckinDetail!
                                                          .checkoutAt ==
                                                      null
                                                  ? formatDate(
                                                      newHistoryLogs[index]
                                                          .lastCheckinDetail!
                                                          .checkinAt
                                                          .toString())
                                                  : formatDate(
                                                      newHistoryLogs[index]
                                                          .lastCheckinDetail!
                                                          .checkoutAt
                                                          .toString()),
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black54,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w400))),
                                        ],
                                      ),
                                    )
                                  : const SizedBox();
                            }

                            Widget layoutChild() => Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(6),
                                      border:
                                          Border.all(color: Colors.grey[300]!)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10, top: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(children: [
                                              ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(4),
                                                  child: FadeInImage(
                                                      height: 50.h,
                                                      width: 50.w,
                                                      fit: BoxFit.cover,
                                                      imageErrorBuilder: (_,
                                                              child,
                                                              stackTrack) =>
                                                          Image.asset(
                                                              'assets/images/default.jpg',
                                                              height: 60.h,
                                                              width: 55.w,
                                                              fit:
                                                                  BoxFit.cover),
                                                      image: NetworkImage(
                                                          newHistoryLogs[index]
                                                              .imageUrl
                                                              .toString()),
                                                      placeholder: const AssetImage(
                                                          'assets/images/default.jpg'))),
                                              SizedBox(width: 10.w),
                                              Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                        capitalizeWords(
                                                            newHistoryLogs[
                                                                    index]
                                                                .name
                                                                .toString()),
                                                        style: GoogleFonts.ptSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 16.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))),
                                                    Text(
                                                        "+91 ${newHistoryLogs[index].phone.toString()}",
                                                        style: GoogleFonts.ptSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black45,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))),
                                                    Text(
                                                        "Role : ${newHistoryLogs[index].role.toString().replaceAll("_", ' ').replaceAll('staff', '')}",
                                                        style: GoogleFonts.ptSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .deepPurpleAccent,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500))),
                                                  ]),
                                              SizedBox(width: 10.w)
                                            ]),
                                            popMenusForStaff(
                                                fromResidentPage: true,
                                                context: context,
                                                requestData:
                                                    newHistoryLogs[index])
                                            // GestureDetector(
                                            //     onTap: () => Navigator.push(
                                            //         context,
                                            //         MaterialPageRoute(
                                            //             builder: (_) =>
                                            //                 QrCodeScanner(
                                            //                     fromResidentSide:
                                            //                         true))),
                                            //     child: SizedBox(
                                            //         height: 60,
                                            //         width: 70,
                                            //         child: Image.asset(
                                            //             'assets/images/qr-image.png'))),
                                          ],
                                        ),
                                      ),
                                      Divider(
                                          color: Colors.grey.withOpacity(0.2)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(child: lastChecking()),
                                            SizedBox(
                                              height: 32,
                                              child: TextButton(
                                                  onPressed: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              DailyHelpGatePass(
                                                                  dailyHelpUser:
                                                                      newHistoryLogs[
                                                                          index]))),
                                                  child: const Text(
                                                    "GATE PASS",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 3),
                              child: layoutChild(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
