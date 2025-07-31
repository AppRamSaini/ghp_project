import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/model/service_request_model.dart';
import 'package:ghp_society_management/view/dashboard/bottom_nav_screen.dart';
import 'package:ghp_society_management/view/maintenance_staff/mark_done_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';
import 'package:pinput/pinput.dart';

class StaffHomeScreen extends StatefulWidget {
  const StaffHomeScreen({super.key});

  @override
  State<StaffHomeScreen> createState() => _StaffHomeScreenState();
}

class _StaffHomeScreenState extends State<StaffHomeScreen> {
  bool showLess = true;
  late PageController _pageController;
  late BuildContext dialogueContext;
  DashboardState homePageState = DashboardState();
  int? selectedFilter = 0;
  String? startDate;
  String? endDate;

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().fetchUserProfile();
    context.read<ServiceRequestCubit>().serviceRequest();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserProfileCubit, UserProfileState>(
      listener: (context, state) {
        if (state is UserProfileLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: BlocListener<LogoutCubit, LogoutState>(
        listener: (context, state) async {
          if (state is LogoutLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is LogoutSuccessfully) {
            snackBar(context, 'User logout successfully', Icons.done,
                AppTheme.guestColor);
            Navigator.of(dialogueContext).pop();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (builder) => const SelectSocietyScreen()),
                (route) => false);
          } else if (state is LogoutFailed) {
            snackBar(context, 'User logout failed', Icons.warning,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is LogoutInternetError) {
            snackBar(context, 'Internet connection failed', Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is LogoutSessionError) {
            Navigator.of(dialogueContext).pop();
            sessionExpiredDialog(context);
          }
        },
        child: BlocListener<StartServiceCubit, StartServiceState>(
          listener: (context, state) {
            if (state is StartServiceLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is StartServiceSuccess) {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              context.read<ServiceRequestCubit>().serviceRequest();
              snackBar(context, state.successMsg.toString(), Icons.check,
                  Colors.green);
            } else if (state is StartServiceFailed) {
              Navigator.of(context).pop();
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  Colors.red);
            } else if (state is StartServiceTimeout) {
              Navigator.of(context).pop();

              snackBar(
                  context, 'Time out exception', Icons.warning, Colors.red);
            } else if (state is StartServiceInternetError) {
              Navigator.of(context).pop();
              snackBar(context, 'Internet connection failed.', Icons.wifi,
                  Colors.red);
            } else if (state is StartServiceLogout) {
              Navigator.of(context).pop();
              sessionExpiredDialog(context);
            }
          },
          child: BlocListener<DoneServiceCubit, DoneServiceState>(
            listener: (context, state) {
              if (state is DoneServiceLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is DoneServiceSuccess) {
                snackBar(context, state.successMsg.toString(), Icons.done,
                    AppTheme.guestColor);
                Navigator.of(context).pop();
                Navigator.of(context).pop();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const MarkDoneScreen()));
                context.read<ServiceRequestCubit>().serviceRequest();
              } else if (state is DoneServiceFailed) {
                Navigator.of(context).pop();
                snackBar(context, state.errorMsg.toString(), Icons.warning,
                    Colors.red);
              } else if (state is DoneServiceTimeout) {
                Navigator.of(context).pop();
                snackBar(
                    context, 'Time out exception', Icons.warning, Colors.red);
              } else if (state is DoneServiceInternetError) {
                Navigator.of(context).pop();
                snackBar(context, 'Internet connection failed.', Icons.wifi,
                    Colors.red);
              } else if (state is DoneServiceLogout) {
                Navigator.of(context).pop();
                sessionExpiredDialog(context);
              }
            },
            child: Scaffold(
              appBar: AppBar(
                  leadingWidth: double.infinity,
                  leading: BlocBuilder<UserProfileCubit, UserProfileState>(
                    builder: (context, state) {
                      if (state is UserProfileLoaded) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          profileViewAlertDialog(
                                              context, state.userProfile.first);
                                        },
                                        child: state.userProfile.first.data!
                                                    .user!.image !=
                                                null
                                            ? CircleAvatar(
                                                radius: 22.h,
                                                backgroundImage: NetworkImage(
                                                    state.userProfile.first
                                                        .data!.user!.image
                                                        .toString()))
                                            : const CircleAvatar(
                                                radius: 22,
                                                backgroundImage: AssetImage(
                                                    'assets/images/default.jpg'))),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              state.userProfile.first.data!
                                                  .user!.name
                                                  .toString(),
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      overflow: TextOverflow
                                                          .ellipsis))),
                                          const SizedBox(height: 3),
                                          Text(
                                              state.userProfile.first.data!
                                                  .user!.categoryName
                                                  .toString(),
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 10.sp,
                                                      fontWeight:
                                                          FontWeight.w500)))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                  ],
                                ),
                              ),
                              serviceProviderHeaderWidget(
                                  context,
                                  state.userProfile.first.data!.user!.id
                                      .toString(),
                                  state.userProfile.first.data!.user!.name
                                      .toString(),
                                  state.userProfile.first.data!.user!.image ??
                                      '')
                            ],
                          ),
                        );
                      } else {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const CircleAvatar(
                                        radius: 22,
                                        backgroundImage: AssetImage(
                                            'assets/images/default.jpg')),
                                    const SizedBox(width: 10),
                                    Flexible(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("LOADING...",
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 15.sp,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      overflow: TextOverflow
                                                          .ellipsis))),
                                          const SizedBox(height: 3),
                                          Text('TOWER LOADING...',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11.sp,
                                                      fontWeight:
                                                          FontWeight.w500)))
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 10)
                                  ],
                                ),
                              ),
                              headerWidget(context, '', '', '', isDemo: true)
                            ],
                          ),
                        );
                      }
                    },
                  )),
              body: RefreshIndicator(
                onRefresh: () async {
                  context.read<ServiceRequestCubit>().serviceRequest();
                },
                child: BlocBuilder<ServiceRequestCubit, ServiceRequestState>(
                  builder: (context, state) {
                    if (state is ServiceRequestsLoading) {
                      return dashboardSimmerLoading(context);
                    } else if (state is ServiceRequestsLoaded) {
                      List<ServiceRequestData> runningServiceList = state
                          .serviceHistory.first.data!.serviceRunning!.data!;
                      List<ServiceRequestData> requestServicesList = state
                          .serviceHistory.first.data!.serviceRequests!.data!;

                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 10.h),
                              Text('Running Services',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600))),
                              SizedBox(height: 10.h),
                              if (runningServiceList.isEmpty)
                                Align(
                                  alignment: Alignment.center,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Image.asset('assets/images/not-found.png',
                                          height: 250),
                                      Text('No running service!',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  fontSize: 16.sp))),
                                    ],
                                  ),
                                )
                              else
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  padding: EdgeInsets.zero,
                                  itemCount: runningServiceList.length,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    List<ServiceRequestData> runningList = state
                                        .serviceHistory
                                        .first
                                        .data!
                                        .serviceRunning!
                                        .data!;
                                    DateTime startDate =
                                        runningList[index].startAt!;

                                    String day = startDate.day.toString();
                                    String formattedDate =
                                        "$day ${monthYear(startDate).toString()}";

                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 5),
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: const Color(0xFFC1EAFE),
                                            borderRadius:
                                                BorderRadius.circular(5.r)),
                                        child: Column(
                                          children: [
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Flexible(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(8),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                            runningList[index]
                                                                .area
                                                                .toString(),
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                        Text(
                                                            "Complaint By : ${runningList[index].member!.name.toString()}",
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                                    color: Colors
                                                                        .pink,
                                                                    fontSize:
                                                                        12.sp,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                        Text(
                                                            'TOWER/BLOC: ${runningList[index].blockName} - Property NO: ${runningList[index].aprtNo}'
                                                                .toUpperCase(),
                                                            style: GoogleFonts.nunitoSans(
                                                                color: AppTheme
                                                                    .staffPrimaryColor,
                                                                fontSize: 10,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)),
                                                        Text(
                                                            runningList[index]
                                                                .description
                                                                .toString(),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                            maxLines: 3,
                                                            style: GoogleFonts.nunitoSans(
                                                                color: const Color(
                                                                    0xFF131313),
                                                                fontSize: 12.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  child: Image.asset(
                                                    'assets/images/staff_banner.png',
                                                    height: 100.h,
                                                  ),
                                                )
                                              ],
                                            ),
                                            Divider(
                                                color: Colors.grey
                                                    .withOpacity(0.1),
                                                height: 0),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 8),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                      Text('Start At : ',
                                                          style: GoogleFonts
                                                              .nunitoSans(
                                                                  color: AppTheme
                                                                      .staffPrimaryColor,
                                                                  fontSize:
                                                                      12)),
                                                      Text(
                                                          '${formattedDate.toString()} ${formatTime(startDate).toString()}',
                                                          style: GoogleFonts
                                                              .nunitoSans(
                                                                  color: AppTheme
                                                                      .staffPrimaryColor,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      enterOtpAlertDialogue(
                                                          runningList[index]
                                                              .id);
                                                    },
                                                    child: Container(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10,
                                                          vertical: 5),
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(4),
                                                          color: AppTheme
                                                              .staffPrimaryColor
                                                              .withOpacity(
                                                                  0.8)),
                                                      child: Center(
                                                        child: Text(
                                                          'Complete Service',
                                                          style: GoogleFonts
                                                              .nunitoSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 12),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              SizedBox(height: 10.h),
                              Text('Service Requests',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.w600))),
                              SizedBox(height: 10.h),
                              requestServicesList.isEmpty
                                  ? Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Image.asset(
                                              'assets/images/not-found.png',
                                              height: 250),
                                          Text('No Complaints Assigned',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      fontSize: 16.sp))),
                                          SizedBox(height: 50)
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: requestServicesList.length,
                                      itemBuilder: (context, index) {
                                        List<ServiceRequestData> requestList =
                                            state.serviceHistory.first.data!
                                                .serviceRequests!.data!;

                                        DateTime assignedDate =
                                            requestList[index].assignedAt!;

                                        String day =
                                            assignedDate.day.toString();
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(bottom: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10.r),
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFE5E5E5))),
                                          child: Column(
                                            children: [
                                              ListTile(
                                                  contentPadding:
                                                      const EdgeInsets
                                                          .symmetric(
                                                          horizontal: 10),
                                                  dense: true,
                                                  leading: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.r),
                                                        color: const Color(
                                                            0xFFF2F1FE)),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              10.0),
                                                      child: Image.asset(
                                                        ImageAssets
                                                            .serviceRequestImage,
                                                        height: 32.h,
                                                        width: 25,
                                                      ),
                                                    ),
                                                  ),
                                                  title: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Flexible(
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: [
                                                            Text(
                                                                requestList[
                                                                        index]
                                                                    .area
                                                                    .toString(),
                                                                style: GoogleFonts.nunitoSans(
                                                                    color: Colors
                                                                        .black,
                                                                    fontSize:
                                                                        16,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600)),
                                                            Text(
                                                              "Complaint By : ${requestList[index].member!.name.toString()}",
                                                              style: GoogleFonts.nunitoSans(
                                                                  color: Colors
                                                                      .pink,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          CircleAvatar(
                                                              radius: 16,
                                                              child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          1),
                                                                  child: CircleAvatar(
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white,
                                                                      child: Text(
                                                                          day
                                                                              .toString(),
                                                                          style: GoogleFonts.nunitoSans(
                                                                              color: Colors.grey,
                                                                              fontSize: 15,
                                                                              fontWeight: FontWeight.bold))))),
                                                          Text(
                                                              monthYear(
                                                                  assignedDate),
                                                              style: GoogleFonts
                                                                  .nunitoSans(
                                                                      color: Colors
                                                                          .black,
                                                                      fontSize:
                                                                          12))
                                                        ],
                                                      )
                                                    ],
                                                  ),
                                                  subtitle: Text(
                                                      "TOWER/BLOC:  ${requestList[index].blockName}  Property NO:  ${requestList[index].aprtNo}"
                                                          .toUpperCase(),
                                                      style: GoogleFonts
                                                          .nunitoSans(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 10))),
                                              Divider(
                                                  color: Colors.grey
                                                      .withOpacity(0.2)),
                                              Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    actionButton(
                                                        onTap: () {
                                                          serviceDetailAlertDialogue(
                                                              requestList[
                                                                  index]);
                                                        },
                                                        icon: Icons
                                                            .design_services,
                                                        text: "Start Service",
                                                        color:
                                                            Colors.lightBlue),
                                                    actionButton(
                                                        onTap: () async {
                                                          await phoneCallLauncher(
                                                              requestList[index]
                                                                  .member!
                                                                  .phone
                                                                  .toString());
                                                        },
                                                        icon: Icons.phone,
                                                        text:
                                                            "Call To Resident",
                                                        color: AppTheme
                                                            .primaryColor)
                                                  ]),
                                              const SizedBox(height: 5)
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is ServiceRequestsFailed) {
                      return const SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(child: Text('No Service requests Found')),
                          ],
                        ),
                      );
                    } else if (state is ServiceRequestsInternetError) {
                      return const SizedBox(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                                child: Text(
                              'Internet connection error',
                              style: TextStyle(color: Colors.red),
                            )),
                          ],
                        ),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// SERVICE DETAILS DIALOG
  serviceDetailAlertDialogue(ServiceRequestData serviceDetails) {
    DateTime assignDate = serviceDetails.assignedAt!;
    String assignDateDate =
        "${assignDate.day.toString()} ${monthYear(assignDate).toString()}";

    DateTime complaintDate = serviceDetails.complaintAt!;
    String complaintDateFormat =
        "${complaintDate.day.toString()} ${monthYear(complaintDate).toString()}";
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              margin: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(8)),
              width: MediaQuery.sizeOf(context).width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding:
                          EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Service Detail",
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 18.sp,
                                    fontWeight: FontWeight.w600)),
                            GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Icon(Icons.close))
                          ])),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  Padding(
                    padding:
                        EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
                    child: Row(
                      children: [
                        Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                color: const Color(0xFFF2F1FE)),
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                    ImageAssets.serviceRequestImage,
                                    height: 27.h,
                                    width: 25.h))),
                        SizedBox(width: 10.w),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  serviceDetails.serviceCategory!.name
                                      .toString(),
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w600)),
                              Text(
                                "Complaint By : ${serviceDetails.member!.name.toString()}",
                                style: GoogleFonts.nunitoSans(
                                  color: Colors.pink,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                  "TOWER/BLOC:  ${serviceDetails.blockName}   PROPERTY NO:  ${serviceDetails.aprtNo}",
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: const Color(0XffE6E6E6))),
                      child: Padding(
                        padding: EdgeInsets.all(15.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Area :',
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500)),
                                Text(serviceDetails.area.toString(),
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500))
                              ],
                            ),
                            Divider(color: Colors.grey.withOpacity(0.1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Assigned Date :',
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    "${assignDateDate.toString()} ${formatTime(assignDate)}",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                            Divider(color: Colors.grey.withOpacity(0.1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Complaint Date : ',
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500)),
                                Text(
                                    "${complaintDateFormat.toString()} ${formatTime(complaintDate)}",
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w600))
                              ],
                            ),
                            Divider(color: Colors.grey.withOpacity(0.1)),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Description : ',
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.grey,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w500)),
                                Flexible(
                                  child: Text(
                                      serviceDetails.description.toString(),
                                      style: GoogleFonts.nunitoSans(
                                          color: Colors.grey,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.w500)),
                                )
                              ],
                            ),
                            Divider(color: Colors.grey.withOpacity(0.1)),
                            Padding(
                              padding: EdgeInsets.all(10.w),
                              child: GestureDetector(
                                onTap: () {
                                  context
                                      .read<StartServiceCubit>()
                                      .startService(
                                          serviceDetails.id.toString());
                                },
                                child: Container(
                                  height: 40.h,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: AppTheme.primaryColor),
                                  child: Center(
                                    child: Text(
                                      'Start Service',
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.white,
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        );
      },
    );
  }

  /// ENTER OTP DIALOG
  enterOtpAlertDialogue(id) {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
        final defaultPinTheme = PinTheme(
            width: 56.w,
            height: 56.h,
            margin: const EdgeInsets.symmetric(horizontal: 5),
            textStyle: const TextStyle(
                fontSize: 22, color: Colors.black, fontWeight: FontWeight.bold),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppTheme.staffPrimaryColor)));
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                width: MediaQuery.sizeOf(context).width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                        padding:
                            EdgeInsets.only(top: 10.w, left: 10.w, right: 10.w),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Enter OTP",
                                  style: GoogleFonts.nunitoSans(
                                      color: Colors.black,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600)),
                              GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Icon(Icons.close))
                            ])),
                    Divider(color: Colors.grey.withOpacity(0.1)),
                    Padding(
                        padding: EdgeInsets.only(
                            top: 10.w, left: 10.w, right: 10.w, bottom: 10.h),
                        child: Text(
                            'Please enter the OTP to verify and complete the service from residence.',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunitoSans(
                                color: Colors.black,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w400))),
                    SizedBox(height: 10.h),
                    Center(
                        child: Pinput(
                            controller: controller,
                            defaultPinTheme: defaultPinTheme,
                            separatorBuilder: (index) =>
                                const SizedBox(width: 10),
                            hapticFeedbackType: HapticFeedbackType.lightImpact,
                            onCompleted: (pin) {
                              context
                                  .read<DoneServiceCubit>()
                                  .doneService(id.toString(), controller.text);
                              Navigator.of(context).pop();
                            },
                            cursor: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Container(
                                      width: 22,
                                      height: 1,
                                      color: focusedBorderColor)
                                ]))),
                    SizedBox(height: 10.h),
                    Padding(
                      padding: EdgeInsets.all(15.w),
                      child: GestureDetector(
                        onTap: () {
                          if (controller.text.isNotEmpty) {
                            context
                                .read<DoneServiceCubit>()
                                .doneService(id.toString(), controller.text);
                          } else {
                            snackBar(context, 'OTP Filed Required!',
                                Icons.warning, Colors.red);
                          }
                        },
                        child: Container(
                          height: 50,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: AppTheme.primaryColor),
                          child: Center(
                            child: Text(
                              'Mark as Done',
                              style: GoogleFonts.nunitoSans(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// action
Widget actionButton(
    {required IconData icon,
    required String text,
    required Color color,
    Function()? onTap}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      margin: EdgeInsets.all(5.w),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              text,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
/*  actionButton(
                                                                  onTap: () {
                                                                    var uuid =
                                                                        const Uuid();
                                                                    String
                                                                        groupId =
                                                                        uuid.v6();

                                                                    Navigator.of(
                                                                            context)
                                                                        .push(
                                                                            MaterialPageRoute(
                                                                      builder:
                                                                          (context) =>
                                                                              MessagingScreen(
                                                                        userImage: requestList[index].member!.unitType ??
                                                                            '' ??
                                                                            '',
                                                                        groupId:
                                                                            '1efdfc1a-fbfa-67b0-8ff5-a9293cbc8a1d',
                                                                        userId: requestList[index]
                                                                            .member!
                                                                            .userId
                                                                            .toString(),
                                                                        userName: requestList[index]
                                                                            .member!
                                                                            .name
                                                                            .toString(),
                                                                        userCategory:
                                                                            requestList[index].member!.unitType ??
                                                                                '',
                                                                      ),
                                                                    ));
                                                                  },
                                                                  icon: Icons
                                                                      .chat,
                                                                  text: "Chat",
                                                                  color: Colors
                                                                      .teal),*/
