import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_in/check_in_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_out/check_out_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitors_details/visitors_details_cubit.dart';
import 'package:ghp_society_management/model/visitors_details_model.dart';
import 'package:ghp_society_management/view/security_staff/dashboard/bottom_navigation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VisitorsDetailsPage2 extends StatefulWidget {
  bool isTypesScan;
  final Map<String, dynamic> visitorsId;

  VisitorsDetailsPage2(
      {Key? key, this.isTypesScan = false, required this.visitorsId})
      : super(key: key);

  @override
  State<VisitorsDetailsPage2> createState() => _VisitorsDetailsPage2State();
}

class _VisitorsDetailsPage2State extends State<VisitorsDetailsPage2> {
  late VisitorsDetailsCubit _visitorsDetailsCubit;

  @override
  void initState() {
    super.initState();
    _visitorsDetailsCubit = VisitorsDetailsCubit();
    fetchDetails();
  }

  fetchDetails() {
    if (widget.visitorsId.containsKey('visitor_id')) {
      _visitorsDetailsCubit.fetchVisitorsDetails(
          context: context,
          visitorsId: widget.visitorsId['visitor_id'].toString());
    } else {
      print("Error: 'visitor_id' not found in visitorsId.");
    }

    setState(() {});
  }

  @override
  void dispose() {
    _visitorsDetailsCubit.close();
    super.dispose();
  }

  late BuildContext dialogueContext;

  void onBack(BuildContext buildContext) {
    Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
          buildContext,
          MaterialPageRoute(builder: (_) => SecurityGuardDashboard()),
          (route) => false);
    });
  }

  /// verify the user
  verifyTheUser(BuildContext buildContext, VisitorsDetails visitorsData) {
    String dateTime = getDateTime();
    if (visitorsData.status == 'inactive') {
      snackBarMsg(context,
          "This visitor has been blocked by resident. Please contact to resident");
      onBack(buildContext);
    } else {
      var lastCheckinDetail = visitorsData.lastCheckinDetail;
      if (lastCheckinDetail == null) {
        Map checkInData = {
          "visitor_id": visitorsData.id.toString(),
          "checkin_at": dateTime.toString()
        };
        buildContext.read<CheckInCubit>().checkInAPI(statusBody: checkInData);
      } else {
        if (lastCheckinDetail.status == 'checked_in') {
          Map checkInData = {
            "visitor_id": visitorsData.id.toString(),
            "checkout_at": dateTime.toString()
          };
          buildContext
              .read<CheckOutCubit>()
              .checkOutAPI(statusBody: checkInData);
        } else if (lastCheckinDetail.status == 'checked_out') {
          snackBarMsg(context, "The visitor has been already checked");
          onBack(buildContext);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CheckInCubit, CheckInState>(
          listener: (_, state) {
            if (state is CheckInLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is CheckInSuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onBack(context); // Delay navigation
              });
            } else if (state is CheckInFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
              onBack(context);
            } else if (state is CheckInInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
              onBack(context);
            }
          },
        ),
        BlocListener<CheckOutCubit, CheckOutState>(listener: (_, state) {
          if (state is CheckOutLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is CheckOutSuccessfully) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            Navigator.of(dialogueContext).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onBack(context);
            });
          } else if (state is CheckOutFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
            onBack(context);
          } else if (state is CheckOutInternetError) {
            snackBar(context, 'Internet connection failed', Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
            onBack(context);
          }
        }),
      ],
      child: Scaffold(
        appBar: appbarWidget(title: 'Visitors Details'),
        body: BlocBuilder<VisitorsDetailsCubit, VisitorsDetailsState>(
            bloc: _visitorsDetailsCubit,
            builder: (context, state) {
              if (state is VisitorsDetailsLoading) {
                return notificationShimmerLoading();
              } else if (state is VisitorsDetailsLoaded) {
                List<VisitorsDetails> visitorsData = state.visitorDetails;

                if (widget.isTypesScan) {
                  verifyTheUser(context, visitorsData.first);
                }
                DateTime parsedTime = DateFormat("HH:mm:ss")
                    .parse(visitorsData.first.time.toString());
                String timeOnly = DateFormat("hh:mm a").format(parsedTime);
                String formatDate = DateFormat('dd-MMM-yyyy')
                    .format(DateTime.parse(visitorsData.first.date.toString()));

                checkIn() {
                  if (state.visitorDetails.first.lastCheckinDetail != null) {
                    if (state.visitorDetails.first.lastCheckinDetail!
                            .checkinAt !=
                        null) {
                      return DateFormat('dd-MMM-yyyy hh:mm a').format(
                          DateTime.parse(state
                              .visitorDetails.first.lastCheckinDetail!.checkinAt
                              .toString()));
                    } else {
                      return '';
                    }
                  }
                }

                checkOut() {
                  if (state.visitorDetails.first.lastCheckinDetail != null) {
                    if (state.visitorDetails.first.lastCheckinDetail!
                            .checkoutAt !=
                        null) {
                      return DateFormat('dd-MMM-yyyy hh:mm a').format(
                          DateTime.parse(state.visitorDetails.first
                              .lastCheckinDetail!.checkoutAt
                              .toString()));
                    } else {
                      return '';
                    }
                  }
                }

                feedBack() {
                  if (state.visitorDetails.first.visitorFeedback != null) {
                    return state.visitorDetails.first.visitorFeedback!.feedback
                        .toString();
                  } else {
                    return '';
                  }
                }

                visitorsStatus() {
                  if (visitorsData.first.lastCheckinDetail != null) {
                    return capitalizeWords(visitorsData
                        .first.lastCheckinDetail!.status
                        .toString()
                        .replaceAll("_", " "));
                  }
                  return '';
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    fetchDetails();
                  },
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          CircleAvatar(
                              radius: 50.h,
                              backgroundImage: NetworkImage(
                                  state.visitorDetails.first.image.toString()),
                              onBackgroundImageError: (error, stack) =>
                                  const AssetImage(
                                      'assets/images/profile_icon.png')),
                          SizedBox(height: 10.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                  capitalizeWords(visitorsData.first.visitorName
                                      .toString()),
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 17.sp,
                                          fontWeight: FontWeight.w500))),
                              const SizedBox(width: 5),
                              visitorsData.first.status == "inactive"
                                  ? const Icon(
                                      size: 20, Icons.block, color: Colors.red)
                                  : const SizedBox()
                            ],
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1))),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Date : ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text('$formatDate || $timeOnly',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500)))
                                    ]),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Mobile Number : ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(
                                          '+91 ${visitorsData.first.phone.toString()}',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500)))
                                    ]),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('No. Of Visitors  :',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(
                                          visitorsData.first.noOfVisitors
                                              .toString(),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500)))
                                    ]),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Visitor types : ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(
                                          visitorsData.first.typeOfVisitor
                                              .toString(),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500)))
                                    ]),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Visitor Status : ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(visitorsStatus(),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color:
                                                      Colors.deepPurpleAccent,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w600)))
                                    ]),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Check In : ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(
                                          checkIn() != null
                                              ? checkIn().toString()
                                              : 'N/A',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500)))
                                    ]),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Check Out : ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(
                                          checkOut() != null
                                              ? checkOut().toString()
                                              : 'N/A',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500)))
                                    ]),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Visiting Frequency : ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black45,
                                                  fontSize: 15.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(
                                          visitorsData.first.visitingFrequency
                                              .toString(),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 15.sp,
                                                  fontWeight: FontWeight.w500)))
                                    ]),
                                /* Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),*/
                                /*  Text('With Visitors : ',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500))),
                                const SizedBox(height: 5),
                                ListView.builder(
                                  itemCount:
                                      visitorsData.first.bulkVisitors!.length,
                                  shrinkWrap: true,
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (BuildContext context, int index) {
                                    List<BulkVisitor> bulkVisitors =
                                        visitorsData.first.bulkVisitors!;

                                    if (bulkVisitors.isEmpty) {
                                      return const SizedBox();
                                    }
                                    return Container(
                                      margin: const EdgeInsets.only(top: 5),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.1))),
                                      child: ListTile(
                                          dense: true,
                                          minLeadingWidth: 30,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 10),
                                          leading: const CircleAvatar(
                                              child: Icon(Icons.person_outline,
                                                  color: Colors.indigoAccent)),
                                          title: Text(
                                              bulkVisitors[index].name.toString(),
                                              style: GoogleFonts.nunitoSans(
                                                  color: Colors.black,
                                                  fontSize: 14.sp,
                                                  fontWeight: FontWeight.w500)),
                                          subtitle: Text(
                                              '+91 ${bulkVisitors[index].phone.toString()}',
                                              style: GoogleFonts.nunitoSans(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w500))),
                                    );
                                  },
                                ),*/
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Text('Visit to :',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500))),
                                const SizedBox(height: 10),
                                visitorsData.first.visitorClassification ==
                                        'other'
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('Name',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    14.sp))),
                                                Text(
                                                    visitorsData
                                                        .first.member!.name
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))
                                              ]),
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('Phone',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    14.sp))),
                                                Text(
                                                    "+91 ${visitorsData.first.member!.phone.toString()}",
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))
                                              ]),
                                        ],
                                      ),
                                const SizedBox(height: 20),
                                visitorsData.first.visitorClassification ==
                                        'other'
                                    ? const SizedBox()
                                    : Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('Tower/Block : ',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    14.sp))),
                                                Text(
                                                    visitorsData
                                                        .first.member!.blockName
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))
                                              ]),
                                          // Column(
                                          //     crossAxisAlignment:
                                          //         CrossAxisAlignment.center,
                                          //     children: [
                                          //       Text('Floor ',
                                          //           style: GoogleFonts.nunitoSans(
                                          //               textStyle: TextStyle(
                                          //                   color: Colors.black54,
                                          //                   fontSize: 14.sp))),
                                          //       Text(
                                          //           visitorsData
                                          //               .first.member!.floorNumber
                                          //               .toString(),
                                          //           style: GoogleFonts.nunitoSans(
                                          //               textStyle: TextStyle(
                                          //                   color: Colors.black,
                                          //                   fontSize: 14.sp,
                                          //                   fontWeight:
                                          //                       FontWeight.w600)))
                                          //     ]),
                                          Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text('Property No : ',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    14.sp))),
                                                Text(
                                                    visitorsData
                                                        .first.member!.aprtNo
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600)))
                                              ]),
                                        ],
                                      ),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Text('Purpose Of Visiting : ',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500))),
                                const SizedBox(height: 5),
                                Text(
                                    visitorsData.first.purposeOfVisit
                                        .toString(),
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500))),
                                Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: Divider(
                                        color: Colors.grey.withOpacity(0.1))),
                                Text('Visitor`s Feedback : ',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black45,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500))),
                                const SizedBox(height: 5),
                                Text(feedBack(),
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black87,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.w500)))
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              } else if (state is VisitorsDetailsFailed) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style:
                            const TextStyle(color: Colors.deepPurpleAccent)));
              } else if (state is VisitorsDetailsMessage) {
                return Center(
                    child: Text(state.msg.toString(),
                        style:
                            const TextStyle(color: Colors.deepPurpleAccent)));
              } else if (state is VisitorsDetailsInternetError) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style: const TextStyle(color: Colors.red)));
              } else {
                return const SizedBox();
              }
            }),
      ),
    );
  }
}
