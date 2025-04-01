import 'package:ghp_app/constants/export.dart';
import 'package:ghp_app/controller/daliy_helps_member/daily_help_listing/daily_help_cubit.dart';
import 'package:ghp_app/controller/resident_checkout_log/resident_check-in/resident_check_in_cubit.dart';
import 'package:ghp_app/controller/resident_checkout_log/resident_check-out/resident_checkout_cubit.dart';
import 'package:ghp_app/model/daily_help_members_modal.dart';
import 'package:ghp_app/view/security_staff/daliy_help/daily_help_details.dart';
import 'package:ghp_app/view/security_staff/scan_qr.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class DailyHelpListingHistory extends StatefulWidget {
  const DailyHelpListingHistory({super.key});

  @override
  State<DailyHelpListingHistory> createState() =>
      _DailyHelpListingHistoryState();
}

class _DailyHelpListingHistoryState extends State<DailyHelpListingHistory> {
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
  void dispose() {
    super.dispose();
    textController.dispose();
    _dailyHelpListingCubit.close();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ResidentCheckInCubit, ResidentCheckInState>(
            listener: (context, state) {
          if (state is ResidentCheckInSuccessfully) {
            onRefresh();
          }
        }),
        BlocListener<ResidentCheckOutCubit, ResidentCheckOutState>(
            listener: (context, state) {
          if (state is ResidentCheckOutSuccessfully) {
            onRefresh();
          }
        }),
      ],
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

                        List<DailyHelp> newHistoryLogs =
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
                            // Last checkouts
                            lastChecking() {
                              return newHistoryLogs[index].lastCheckinDetail !=
                                      null
                                  ? Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                              newHistoryLogs[index]
                                                          .lastCheckinDetail!
                                                          .checkoutAt ==
                                                      null
                                                  ? "Last Check-IN : "
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
                                  : const SizedBox(height: 10);
                            }

                            Widget layoutChild() => GestureDetector(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (_) =>
                                              DailyHelpProfileDetails(
                                                  dailyHelpId: {
                                                    "daily_help_id":
                                                        newHistoryLogs[index]
                                                            .id
                                                            .toString()
                                                  }))),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(
                                            color: Colors.grey[300]!)),
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
                                                        BorderRadius.circular(
                                                            4),
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
                                                                fit: BoxFit
                                                                    .cover),
                                                        image: NetworkImage(
                                                            newHistoryLogs[index]
                                                                .imageUrl
                                                                .toString()),
                                                        placeholder:
                                                            const AssetImage(
                                                                'assets/images/default.jpg'))),
                                                SizedBox(width: 10.w),
                                                Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
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
                                                                  fontSize:
                                                                      16.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))),
                                                      Text(
                                                          "+91 : ${newHistoryLogs[index].phone.toString()}",
                                                          style: GoogleFonts.ptSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black45,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))),
                                                      Text(
                                                          "Role : ${newHistoryLogs[index].role.toString().replaceAll("_", ' ')}",
                                                          style: GoogleFonts.ptSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .deepPurpleAccent,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500))),
                                                    ]),
                                                SizedBox(width: 10.w)
                                              ]),
                                              GestureDetector(
                                                  onTap: () => Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (_) =>
                                                              QrCodeScanner())),
                                                  child: SizedBox(
                                                      height: 50,
                                                      width: 65,
                                                      child: Image.asset(
                                                          'assets/images/qr-image.png'))),
                                            ],
                                          ),
                                        ),
                                        SizedBox(child: lastChecking()),
                                        SizedBox(
                                            child: serviceOnFlats(
                                                newHistoryLogs[index]))
                                      ],
                                    ),
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

  // Service on Flats
  serviceOnFlats(DailyHelp newHistoryLogs) {
    List<AssignedDailyHelpMember> assignedFlatsList =
        newHistoryLogs.assignedDailyHelpMembers!;

    return assignedFlatsList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.grey.withOpacity(0.2)),
                Row(
                  children: [
                    Row(
                      children: [
                        Text("Service On Flats ",
                            style: GoogleFonts.ptSans(
                                textStyle: TextStyle(
                                    color: Colors.black45,
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500))),
                        CircleAvatar(
                            radius: 10,
                            child: Text(assignedFlatsList.length.toString(),
                                style: GoogleFonts.ptSans(
                                    textStyle: TextStyle(
                                        color: Colors.red,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600))))
                      ],
                    ),
                  ],
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                SizedBox(
                  height: 50,
                  child: PageView.builder(
                    itemCount: assignedFlatsList.length,
                    itemBuilder: (_, pageIndex) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              Text(
                                  assignedFlatsList[pageIndex]
                                      .memberUser!
                                      .member!
                                      .name
                                      .toString(),
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600))),
                              Text("Name",
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  "+91 ${assignedFlatsList[pageIndex].memberUser!.member!.phone.toString()}",
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w600))),
                              Text("Phone",
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                  "${assignedFlatsList[pageIndex].memberUser!.member!.blockName.toString()}, ${assignedFlatsList[pageIndex].memberUser!.member!.aprtNo.toString()}",
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 11.sp,
                                          fontWeight: FontWeight.w600))),
                              Text("Tower Name",
                                  style: GoogleFonts.ptSans(
                                      textStyle: TextStyle(
                                          color: Colors.black54,
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400))),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : const SizedBox();
  }
}
