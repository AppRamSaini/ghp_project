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
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VisitorsDetailsPage extends StatefulWidget {
  final String visitorsId;

  const VisitorsDetailsPage({super.key, required this.visitorsId});

  @override
  State<VisitorsDetailsPage> createState() => _VisitorsDetailsPageState();
}

class _VisitorsDetailsPageState extends State<VisitorsDetailsPage> {
  late VisitorsDetailsCubit _visitorsDetailsCubit;

  @override
  void initState() {
    super.initState();
    _visitorsDetailsCubit = VisitorsDetailsCubit();
    _visitorsDetailsCubit = VisitorsDetailsCubit()
      ..fetchVisitorsDetails(
          context: context, visitorsId: widget.visitorsId.toString());
  }

  late BuildContext dialogueContext;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Visitors Details'),
      body: MultiBlocListener(
        listeners: [
          BlocListener<VisitorsDetailsCubit, VisitorsDetailsState>(
              listener: (context, state) {
            if (state is VisitorsDetailsLoaded) {}
          }),
          BlocListener<CheckOutCubit, CheckOutState>(
              listener: (context, state) {
            if (state is CheckOutLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is CheckOutSuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);

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
        ],
        child: BlocBuilder<VisitorsDetailsCubit, VisitorsDetailsState>(
            bloc: _visitorsDetailsCubit,
            builder: (context, state) {
              if (state is VisitorsDetailsLoading) {
                return notificationShimmerLoading();
              } else if (state is VisitorsDetailsLoaded) {
                List<VisitorsDetails> visitorsData = state.visitorDetails;
                DateTime parsedTime = DateFormat("HH:mm:ss")
                    .parse(visitorsData.first.time!.toString());
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
                    return 'N/A';
                  }
                }

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                    color: Colors.grey.withOpacity(0.1))),
                            child: Row(
                              children: [
                                Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(100)),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: FadeInImage(
                                          fit: BoxFit.cover,
                                          height: 60,
                                          width: 60,
                                          image: NetworkImage(state
                                              .visitorDetails.first.image
                                              .toString()),
                                          placeholder: const AssetImage(
                                              'assets/images/profile_icon.png'),
                                          imageErrorBuilder: (_, ss, st) =>
                                              Image.asset(
                                                  fit: BoxFit.cover,
                                                  height: 60,
                                                  width: 60,
                                                  'assets/images/profile_icon.png'))),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                              capitalizeWords(visitorsData
                                                  .first.visitorName
                                                  .toString()),
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          const SizedBox(width: 5),
                                          visitorsData.first.status ==
                                                  "inactive"
                                              ? const Icon(
                                                  size: 20,
                                                  Icons.block,
                                                  color: Colors.red)
                                              : const SizedBox()
                                        ],
                                      ),
                                      Text(
                                          "+91 ${visitorsData.first.phone.toString()}",
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        SizedBox(height: 10.h),
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
                                    Text('Arrive Date : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                    Text('$formatDate || $timeOnly',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                    Text(
                                        '+91 ${visitorsData.first.phone.toString()}',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                    Text(
                                        visitorsData.first.noOfVisitors
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                    Text(
                                        visitorsData.first.typeOfVisitor
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
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
                                    Text('Check In : ',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black45,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                    Text(
                                        checkIn() != null
                                            ? checkIn().toString()
                                            : 'N/A',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                    Text(
                                        checkOut() != null
                                            ? checkOut().toString()
                                            : 'N/A',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
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
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500))),
                                    Text(
                                        visitorsData.first.visitingFrequency
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black87,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500)))
                                  ]),
                              /*       Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Divider(
                                      color: Colors.grey.withOpacity(0.1))),
                              Text('With Visitors : ',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
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
                              Text('Purpose Of Visiting :- ',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500))),
                              const SizedBox(height: 5),
                              Text(visitorsData.first.purposeOfVisit.toString(),
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500))),
                              Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 3),
                                  child: Divider(
                                      color: Colors.grey.withOpacity(0.1))),
                              Text('Visitor`s Feedback :- ',
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black45,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500))),
                              const SizedBox(height: 5),
                              Text(feedBack().toString(),
                                  style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                          color: Colors.black87,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500)))
                            ],
                          ),
                        ),
                      ],
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
