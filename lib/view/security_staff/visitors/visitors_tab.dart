import 'dart:async';

import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/notification/notification_listing/notification_list_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_in/check_in_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_out/check_out_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/visitors_scan/scan_visitors_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/not_responding/not_responde_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/resend_request/resend_request_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/visitors_listing_model.dart';
import 'package:ghp_society_management/timer_countdown.dart';
import 'package:ghp_society_management/view/security_staff/scan_qr.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_details_page.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_list_page.dart';
import 'package:intl/intl.dart';

class VisitorsTabBar extends StatefulWidget {
  const VisitorsTabBar({super.key});

  @override
  State<VisitorsTabBar> createState() => _VisitorsTabBarState();
}

class _VisitorsTabBarState extends State<VisitorsTabBar> {
  late VisitorsListingCubit _visitorsListingCubit;
  final List<String> filterList = [
    'all',
    'resident_entry',
    'guard_entry',
    'daily_frequency'
  ];
  int selectedIndex = 0;

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _visitorsListingCubit = VisitorsListingCubit();
    fetchApi();
    _scrollController.addListener(_onScroll);
    context.read<NotificationListingCubit>().fetchNotifications();
  }

  Future<void> fetchApi() async {
    _visitorsListingCubit.fetchVisitorsListing(
        fromDate: '',
        toDate: '',
        search: '',
        filterTypes: filterList[selectedIndex],
        context: context,
        fotStaffSide: true);

    setState(() {});
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent < 300) {
      _visitorsListingCubit.loadMoreVisitorsUsers(
          context, filterList[selectedIndex].toString(), '', '', '');
    }
  }

  void _handleNotResponding(String visitorsId) {
    print('----------->>>>>called not responding');
    var requestBody = {"visitor_id": visitorsId.toString()};
    context
        .read<NotRespondingCubit>()
        .notRespondingAPI(statusBody: requestBody);
  }

  Timer? periodicTimer;

  void _startCountdownAndAPICalls(String visitorsId) {
    const duration = Duration(seconds: 4); // Call API every 5 seconds
    const totalTime = 59; // Total countdown time in seconds
    int remainingTime = totalTime;

    // Show the countdown dialog
    timerCountdownDialog(
      context: context,
      setDialogueContext: (ctx) {
        dialogueContext = ctx;
      },
      onComplete: () {
        if (mounted) {
          periodicTimer?.cancel(); // Stop the timer
          if (Navigator.canPop(dialogueContext)) {
            Navigator.of(dialogueContext).pop();
          }
          _handleNotResponding(visitorsId);
        }
      },
      onChange: (time) {
        remainingTime = int.tryParse(time)!;
      },
    );

    // Start a periodic timer to call the API
    periodicTimer = Timer.periodic(duration, (timer) {
      if (mounted && remainingTime > 0) {
        context
            .read<ScanVisitorsCubit>()
            .fetchScanVisitors(visitorsId: visitorsId);
        setState(() {});
      } else {
        timer.cancel();
      }
    });

    print('remaining------------>>>>>>$remainingTime');
  }

  /// Stops the active timer and closes the dialog.
  void stopTimerDialog() {
    if (mounted) {
      // Ensure widget is still in the tree
      periodicTimer?.cancel(); // Stop the timer
      if (dialogueContext.mounted) {
        // Ensure the context is valid
        if (Navigator.canPop(dialogueContext)) {
          Navigator.of(dialogueContext).pop();
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dialogueContext = context; // Store the context safely
  }

  @override
  void dispose() {
    periodicTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  late BuildContext dialogueContext;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: fetchApi,
      child: MultiBlocListener(
        listeners: [
          BlocListener<CreateVisitorsCubit, CreateVisitorsState>(
              listener: (context, state) {
            if (state is CreateVisitorsSuccessfully) {
              fetchApi();
            }
          }),
          BlocListener<ScanVisitorsCubit, ScanVisitorsState>(
            listener: (context, state) {
              if (state is CallToFetchListAPI) {
                if (state.status == 'not_allowed') {
                  snackBar(context, 'Resident Not Allowed This Visitor!',
                      Icons.clear, AppTheme.redColor);
                }

                if (state.status == 'checked_in') {
                  snackBar(context, 'Resident has been Allowed This Visitor!',
                      Icons.done, AppTheme.guestColor);
                }
                stopTimerDialog();
                fetchApi();
              }
            },
          ),
          BlocListener<CheckOutCubit, CheckOutState>(
              listener: (context, state) {
            if (state is CheckOutLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is CheckOutSuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              fetchApi();
              Navigator.of(dialogueContext).pop();
            } else if (state is CheckOutFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is CheckOutInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            }
          }),
          BlocListener<CheckInCubit, CheckInState>(
            listener: (context, state) {
              if (state is CheckInLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is CheckInSuccessfully) {
                snackBar(context, state.successMsg.toString(), Icons.done,
                    AppTheme.guestColor);
                fetchApi();
                Navigator.of(dialogueContext).pop();
              } else if (state is CheckInFailed) {
                snackBar(context, state.errorMsg.toString(), Icons.warning,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              } else if (state is CheckInInternetError) {
                snackBar(context, 'Internet connection failed', Icons.wifi_off,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              }
            },
          ),
          BlocListener<NotRespondingCubit, NotRespondingState>(
            listener: (context, state) {
              if (state is NotRespondingLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is NotRespondingSuccessfully) {
                fetchApi();
                snackBar(context, state.successMsg.toString(), Icons.warning,
                    AppTheme.redColor);
                Navigator.of(dialogueContext).pop();
              }
            },
          ),
          BlocListener<ResendRequestCubit, ResendRequestState>(
              listener: (context, state) {
            if (state is ResendRequestLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is ResendRequestSuccessfully) {
              Navigator.of(dialogueContext).pop();
              _startCountdownAndAPICalls(state.visitorsId.toString());
            } else if (state is ResendRequestFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is ResendRequestInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            }
          }),
        ],
        child: DefaultTabController(
          length: 3,
          child: Column(
            children: [
              const SizedBox(height: 10),
              BlocBuilder<VisitorsListingCubit, VisitorsListingState>(
                bloc: _visitorsListingCubit,
                builder: (context, state) {
                  if (state is VisitorsListingLoaded) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const VisitorsListPage(
                                      index: 0, type: 'T_V'))),
                          child: Container(
                              width: size.width * 0.44,
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.color1,
                                  border: Border.all(
                                      color: AppTheme.color1, width: 2)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(state.todayVisitors.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.w600)),
                                      Image.asset(ImageAssets.visitors1,
                                          height: size.height * 0.08),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text('Today visitors',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              )),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  const VisitorsListPage(index: 1, type: 'P_V'),
                            ),
                          ),
                          child: Container(
                              width: size.width * 0.44,
                              margin: EdgeInsets.only(bottom: 5),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: AppTheme.color3,
                                  border: Border.all(
                                      color: AppTheme.color3, width: 2)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(state.pastVisitors.toString(),
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 26.sp,
                                              fontWeight: FontWeight.w600)),
                                      Image.asset(ImageAssets.visitors1,
                                          height: size.height * 0.08),
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10, bottom: 10),
                                    child: Text('Past visitors',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              )),
                        ),
                      ],
                    );
                  } else {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                            width: size.width * 0.44,
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.color1,
                                border: Border.all(
                                    color: AppTheme.color1, width: 2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26.sp,
                                            fontWeight: FontWeight.w600)),
                                    Image.asset(ImageAssets.visitors1,
                                        height: size.height * 0.08),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  child: Text('Today visitors',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            )),
                        Container(
                            width: size.width * 0.44,
                            margin: EdgeInsets.only(bottom: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: AppTheme.color3,
                                border: Border.all(
                                    color: AppTheme.color3, width: 2)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 26.sp,
                                            fontWeight: FontWeight.w600)),
                                    Image.asset(ImageAssets.visitors1,
                                        height: size.height * 0.08),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10, bottom: 10),
                                  child: Text('Past visitors',
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w600)),
                                ),
                              ],
                            )),
                      ],
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                automaticIndicatorColorAdjustment: true,
                physics: const BouncingScrollPhysics(),
                onTap: (index) {
                  setState(() {
                    selectedIndex = index;
                  });
                  fetchApi();
                },
                tabs: const [
                  Tab(height: 40, text: "All"),
                  Tab(height: 40, text: "By Residence"),
                  Tab(height: 40, text: "By Staff"),
                  // Tab(height: 40, text: "Daily"),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: BlocBuilder<VisitorsListingCubit, VisitorsListingState>(
                  bloc: _visitorsListingCubit,
                  builder: (context, state) {
                    if (state is VisitorsListingLoading) {
                      return notificationShimmerLoading();
                    }

                    if (state is VisitorsListingFailed) {
                      return Center(
                          child: Text(state.errorMsg.toString(),
                              style: const TextStyle(color: Colors.red)));
                    }

                    if (state is VisitorsListingInternetError) {
                      return Center(
                          child: Text(state.errorMsg.toString(),
                              style: const TextStyle(color: Colors.red)));
                    }

                    var visitorsList = _visitorsListingCubit.visitorsListing;

                    if (visitorsList.isEmpty) {
                      return const Center(
                          child: Text("Visitors not Found!",
                              style:
                                  TextStyle(color: Colors.deepPurpleAccent)));
                    }

                    return ListView.builder(
                      padding: const EdgeInsets.only(bottom: 100),
                      controller: _scrollController,
                      shrinkWrap: true,
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: visitorsList.length + 1,
                      itemBuilder: (context, index) {
                        if (index == visitorsList.length) {
                          return _visitorsListingCubit.state
                                  is ViewVisitorsLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive()))
                              : const SizedBox.shrink();
                        }

                        VisitorsListing data = visitorsList[index];
                        return customVisitorsWidget(
                            context, 'today_list', data);
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String checkStatus(String type, VisitorsListing visitorsData) {
  if (type == 'past_list') {
    if (visitorsData.lastCheckinDetail.status.isNotEmpty) {
      if (visitorsData.lastCheckinDetail.status == 'requested') {
        return "Requested";
      } else if (visitorsData.lastCheckinDetail.status == 'not_responded') {
        return "Re Send";
      } else if (visitorsData.lastCheckinDetail.status == 'not_allowed') {
        return "Not Allowed";
      } else if (visitorsData.lastCheckinDetail.status == 'allowed') {
        return "Check IN";
      } else if (visitorsData.lastCheckinDetail.status == 'checked_in') {
        return "Check OUT";
      } else if (visitorsData.lastCheckinDetail.status == 'checked_out') {
        return "Completed";
      } else {
        return "Check IN";
      }
    } else {
      return "Not Arrived";
    }
  } else {
    if (visitorsData.lastCheckinDetail.status.isNotEmpty) {
      if (visitorsData.lastCheckinDetail.status == 'requested') {
        return "Requested";
      } else if (visitorsData.lastCheckinDetail.status == 'not_responded') {
        return "Re Send";
      } else if (visitorsData.lastCheckinDetail.status == 'not_allowed') {
        return "Not Allowed";
      } else if (visitorsData.lastCheckinDetail.status == 'allowed') {
        return "Check IN";
      } else if (visitorsData.lastCheckinDetail.status == 'checked_in') {
        return "Check OUT";
      } else if (visitorsData.lastCheckinDetail.status == 'checked_out') {
        return "Completed";
      } else {
        return "Check IN";
      }
    } else {
      return "Check IN";
    }
  }
}

/// VISITORS CUSTOM WIDGETS
Widget customVisitorsWidget(
    BuildContext context, String filterTypes, VisitorsListing visitorsData) {
  String status = checkStatus(filterTypes, visitorsData);
  VisitorActionsHandler actionsHandler = VisitorActionsHandler();

  DateTime parsedDate = DateTime.parse(visitorsData.date.toString());
  String visitorsDate = DateFormat("dd-MMM-yyyy").format(parsedDate);
  DateTime parsedTime =
      DateFormat("HH:mm:ss").parse(visitorsData.time.toString());
  String formattedTime = DateFormat("hh:mm a").format(parsedTime);
  return Container(
    margin: const EdgeInsets.only(top: 10),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.withOpacity(0.2))),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          leading: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: FadeInImage(
                  placeholder: const AssetImage("assets/images/default.jpg"),
                  imageErrorBuilder: (context, error, stackTrace) {
                    return Image.asset("assets/images/default.jpg",
                        height: 50, width: 50, fit: BoxFit.cover);
                  },
                  image: NetworkImage(visitorsData.image.toString()),
                  fit: BoxFit.cover,
                  height: 50,
                  width: 50)),
          title: Row(
            children: [
              Flexible(
                  child: Text(
                      capitalizeWords(visitorsData.visitorName.toString()),
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black, fontSize: 16))),
              const SizedBox(width: 5),
              visitorsData.status == "active"
                  ? const SizedBox()
                  : const Icon(size: 20, Icons.block, color: Colors.red)
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("+91 ${visitorsData.phone.toString()}",
                  style: const TextStyle(color: Colors.black45, fontSize: 12)),
              status == 'Requested' ||
                      status == 'Completed' ||
                      status == 'Not Arrived'
                  ? Text(status.toString(),
                      style: TextStyle(
                          color: status == 'Requested'
                              ? Colors.blue
                              : status == 'Completed'
                                  ? Colors.green
                                  : status == 'Not Arrived'
                                      ? Colors.yellow
                                      : Colors.white,
                          fontSize: 12))
                  : const SizedBox()
            ],
          ),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => VisitorsDetailsPage2(visitorsId: {
                          "visitor_id": visitorsData.id.toString()
                        })));
          },
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              status == 'Requested' ||
                      status == 'Completed' ||
                      status == 'Not Arrived'
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () {
                        String dateTime = getDateTime();
                        actionsHandler.handleTap(
                          context: context,
                          status: status,
                          visitorsData: visitorsData,
                          dateTime: dateTime,
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                            color: status == 'Check IN'
                                ? Colors.blue
                                : status == 'Check OUT' ||
                                        status == 'Not Allowed'
                                    ? Colors.red
                                    : status == 'Re Send'
                                        ? Colors.red.withOpacity(0.6)
                                        : Colors.blue,
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                          child: Text(
                            status.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
              status == 'Requested' ||
                      // status == 'Completed' ||
                      status == 'Not Arrived'
                  ? const SizedBox()
                  : GestureDetector(
                      onTap: () => phoneCallLauncher(visitorsData.member == null
                          ? visitorsData.phone.toString()
                          : visitorsData.member!.phone.toString()),
                      child: const CircleAvatar(
                          backgroundColor: Colors.blue,
                          radius: 18,
                          child:
                              Icon(Icons.call, size: 15, color: Colors.white)),
                    )
            ],
          ),
        ),
        visitorsData.visitingFrequency == 'Daily'
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                    "Arrived At : ${visitorsDate.toString()} $formattedTime",
                    style:
                        const TextStyle(color: Colors.black45, fontSize: 12)),
              ),
        Divider(color: Colors.grey.withOpacity(0.2)),
        visitorsData.member == null
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text('Name',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black54, fontSize: 14.sp))),
                          Text(visitorsData.member!.name.toString(),
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w600))),
                        ],
                      ),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Tower/Block Name ',
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12.sp))),
                            Text(visitorsData.member!.blockName.toString(),
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600)))
                          ]),
                      // Column(
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: [
                      //       Text('Floor ',
                      //           style: GoogleFonts.nunitoSans(
                      //               textStyle: TextStyle(
                      //                   color: Colors.black54,
                      //                   fontSize: 12.sp))),
                      //       Text(visitorsData.member!.floorNumber.toString(),
                      //           style: GoogleFonts.nunitoSans(
                      //               textStyle: TextStyle(
                      //                   color: Colors.black,
                      //                   fontSize: 12.sp,
                      //                   fontWeight: FontWeight.w600)))
                      //     ]),
                      Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Property No',
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 12.sp))),
                            Text(visitorsData.member!.aprtNo.toString(),
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600)))
                          ]),
                    ]),
              ),
        const SizedBox(height: 10)
      ],
    ),
  );
}

class VisitorActionsHandler {
  final Map<String, int> resendAttempts = {};

  void handleTap({
    required BuildContext context,
    required String status,
    required dynamic visitorsData,
    required String dateTime,
  }) {
    if (visitorsData.status == 'inactive') {
      snackBar(
          context,
          'This visitor has been blocked by residence! Please contact residence',
          Icons.block,
          AppTheme.redColor);
      return;
    }

    if (status == 'Check IN') {
      if (visitorsData.addedByRole == 'staff_security_guard') {
        Map checkInData = {
          "visitor_id": visitorsData.id.toString(),
          "checkin_at": dateTime.toString(),
        };
        context.read<CheckInCubit>().checkInAPI(statusBody: checkInData);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => QrCodeScanner()),
        );
      }
    } else if (status == 'Check OUT') {
      Map checkOutData = {
        "visitor_id": visitorsData.id.toString(),
        "checkout_at": dateTime.toString(),
      };
      context.read<CheckOutCubit>().checkOutAPI(statusBody: checkOutData);
    } else if (status == 'Re Send') {
      String visitorId = visitorsData.id.toString();
      Map resendData = {"visitor_id": visitorId};
      context
          .read<ResendRequestCubit>()
          .resendRequestAPI(statusBody: resendData);
    }
  }
}
