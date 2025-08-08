import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/daliy_helps_member/daily_help_listing/daily_help_cubit.dart';
import 'package:ghp_society_management/view/resident/daily_helps_member/daily_help_gatepass.dart';

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
        appBar: customAppbar(
          context: context,
          title: 'Daily Help',
          textController: textController,
          searchBarOpen: searchBarOpen,
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
        ),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<DailyHelpListingCubit, DailyHelpListingState>(
            bloc: _dailyHelpListingCubit,
            builder: (context, state) {
              if (state is DailyHelpListingLoading) {
                return notificationShimmerLoading();
              }
              if (state is DailyHelpListingError) {
                return emptyDataWidget(state.errorMsg);
              }

              var newHistoryLogs = _dailyHelpListingCubit.dailyHelpMemberList;

              if (state is DailyHelpListingSearchLoaded) {
                newHistoryLogs = state.dailyHelpMemberList;
              }

              if (newHistoryLogs.isEmpty) {
                return emptyDataWidget('Member not found!');
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: newHistoryLogs.length,
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  lastChecking() {
                    return newHistoryLogs[index].lastCheckinDetail != null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400))),
                                Text(
                                    newHistoryLogs[index]
                                                .lastCheckinDetail!
                                                .checkoutAt ==
                                            null
                                        ? formatDate(newHistoryLogs[index]
                                            .lastCheckinDetail!
                                            .checkinAt
                                            .toString())
                                        : formatDate(newHistoryLogs[index]
                                            .lastCheckinDetail!
                                            .checkoutAt
                                            .toString()),
                                    style: GoogleFonts.ptSans(
                                        textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 11.sp,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text("Not checked in by staff",
                                style: GoogleFonts.ptSans(
                                    textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w400))),
                          );
                  }

                  Widget layoutChild() => Container(
                        margin: const EdgeInsets.only(bottom: 5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(color: Colors.grey[300]!)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(children: [
                                    ClipRRect(
                                        borderRadius: BorderRadius.circular(4),
                                        child: FadeInImage(
                                            height: 50.h,
                                            width: 50.w,
                                            fit: BoxFit.cover,
                                            imageErrorBuilder: (_, child,
                                                    stackTrack) =>
                                                Image.asset(
                                                    'assets/images/default.jpg',
                                                    height: 60.h,
                                                    width: 55.w,
                                                    fit: BoxFit.cover),
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
                                                  newHistoryLogs[index]
                                                      .name
                                                      .toString()),
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Text(
                                              "+91 ${newHistoryLogs[index].phone.toString()}",
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Text(
                                              "Role : ${newHistoryLogs[index].role.toString().replaceAll("_", ' ').replaceAll('staff', '')}",
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ]),
                                    SizedBox(width: 10.w)
                                  ]),
                                  popMenusForStaff(
                                      optionList: optionListForResident,
                                      fromResidentPage: true,
                                      context: context,
                                      requestData: newHistoryLogs[index])
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
                            Divider(color: Colors.grey.withOpacity(0.2)),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8),
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
                                          style: TextStyle(fontSize: 12),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    child: layoutChild(),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
