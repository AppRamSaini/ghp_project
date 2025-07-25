import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/daliy_helps_member/daily_help_listing/daily_help_cubit.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_check-in/resident_check_in_cubit.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_check-out/resident_checkout_cubit.dart';
import 'package:ghp_society_management/model/daily_help_members_modal.dart';
import 'package:ghp_society_management/view/security_staff/daliy_help/daily_help_details.dart';
import 'package:ghp_society_management/view/security_staff/scan_qr.dart';

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
        appBar: customAppbar(
          searchBarOpen: searchBarOpen,
          context: context,
          title: 'Daily Help Member',
          textController: textController,
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
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }
              if (state is DailyHelpListingError) {
                return Center(
                    child: Text(state.errorMsg,
                        style:
                            const TextStyle(color: Colors.deepPurpleAccent)));
              }

              List<DailyHelp> newHistoryLogs =
                  _dailyHelpListingCubit.dailyHelpMemberList;

              if (state is DailyHelpListingSearchLoaded) {
                newHistoryLogs = state.dailyHelpMemberList;
              }

              if (newHistoryLogs.isEmpty) {
                return const Center(
                    child: Text('Member not found!',
                        style: TextStyle(color: Colors.deepPurpleAccent)));
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: newHistoryLogs.length,
                padding: const EdgeInsets.only(top: 10),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  // Last checkouts
                  lastChecking() {
                    return newHistoryLogs[index].lastCheckinDetail != null
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
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400))),
                              ],
                            ),
                          )
                        : const SizedBox(height: 10);
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
                                                      fontSize: 16.sp,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Text(
                                              "+91 : ${newHistoryLogs[index].phone.toString()}",
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black45,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Text(
                                              "Role : ${newHistoryLogs[index].role.toString().replaceAll("_", ' ')}",
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                        ]),
                                    SizedBox(width: 10.w)
                                  ]),
                                  popMenusForStaff(
                                      fromResidentPage: false,
                                      context: context,
                                      requestData: newHistoryLogs[index])
                                ],
                              ),
                            ),
                            SizedBox(child: lastChecking()),
                            SizedBox(
                                child: serviceOnFlats(
                                    newHistoryLogs[index], index))
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

  Map<int, int> selectedIndexes = {};

  // Service on Flats
  serviceOnFlats(DailyHelp newHistoryLogs, listIndex) {
    List<AssignedDailyHelpMember> assignedFlatsList =
        newHistoryLogs.assignedDailyHelpMembers!;
    int selectedIndex = selectedIndexes[listIndex] ?? 0;

    return assignedFlatsList.isNotEmpty
        ? Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Divider(color: Colors.grey.withOpacity(0.2)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text("Service On Flats",
                            style: GoogleFonts.ptSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600))),
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
                    Text(
                        "SHIFT : ${formatTimeToAMPM(assignedFlatsList[selectedIndex].shiftFrom.toString())}-${formatTimeToAMPM(assignedFlatsList[selectedIndex].shiftTo.toString())}",
                        style: GoogleFonts.ptSans(
                            textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600))),
                  ],
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                SizedBox(
                    height: 50,
                    child: PageView.builder(
                      itemCount: assignedFlatsList.length,
                      onPageChanged: (pageOnchangeIndex) {
                        setState(() =>
                            selectedIndexes[listIndex] = pageOnchangeIndex);
                      },
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
                    )),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        assignedFlatsList.length,
                        (index) => AnimatedContainer(
                            margin: const EdgeInsets.only(left: 5, bottom: 10),
                            height: 6,
                            width: index == selectedIndex ? 10 : 6,
                            decoration: BoxDecoration(
                                color: index == selectedIndex
                                    ? Colors.deepPurpleAccent
                                    : Colors.grey,
                                borderRadius: BorderRadius.circular(15)),
                            duration: const Duration(milliseconds: 500))))
              ],
            ),
          )
        : const SizedBox();
  }
}

List<Map<String, dynamic>> optionList3 = [
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 0},
  {"icon": Icons.qr_code, "menu": "Scan By QR", "menu_id": 1},
  {"icon": Icons.scanner, "menu": "Scan By Manual", "menu_id": 2},
];

Widget popMenusForStaff(
    {bool fromResidentPage = false,
    required BuildContext context,
    required DailyHelp requestData}) {
  return Padding(
    padding: const EdgeInsets.only(right: 5),
    child: CircleAvatar(
      backgroundColor: AppTheme.primaryColor.withOpacity(0.2),
      child: PopupMenuButton(
        elevation: 10,
        padding: EdgeInsets.zero,
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        icon: const Icon(Icons.more_horiz_rounded,
            color: Colors.deepPurpleAccent, size: 18.0),
        offset: const Offset(0, 50),
        itemBuilder: (BuildContext bc) {
          return optionList3
              .map(
                (selectedOption) => PopupMenuItem(
                  padding: EdgeInsets.zero,
                  value: selectedOption,
                  child: Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 30),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(selectedOption['icon']),
                            const SizedBox(width: 10),
                            Text(selectedOption['menu'] ?? "",
                                style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w400))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .toList();
        },
        onSelected: (value) async {
          if (value['menu_id'] == 0) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => DailyHelpProfileDetails(
                            dailyHelpId: {
                              "daily_help_id": requestData.id.toString(),
                            },
                            forDetailsPage: true,
                            fromResidentPage: fromResidentPage)));
          } else if (value['menu_id'] == 1) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) =>
                        QrCodeScanner(fromResidentSide: fromResidentPage)));
          } else if (value['menu_id'] == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (_) => DailyHelpProfileDetails(
                            dailyHelpId: {
                              'daily_help_id': requestData.id.toString()
                            },
                            forQRPage: false,
                            fromResidentPage: fromResidentPage)));
            // if (isStaffSide) {
            //   Navigator.pushReplacement(
            //       context,
            //       MaterialPageRoute(
            //           builder: (_) => DailyHelpProfileDetails(dailyHelpId: {
            //                 'daily_help_id': requestData.id.toString()
            //               }, forQRPage: false, fromResidentPage: false)));
            // } else {
            //   context.read<ResidentCheckInCubit>().checkInAPI(
            //       statusBody: {"parcel_id": requestData.id.toString()});
            // }
          }
        },
      ),
    ),
  );
}
