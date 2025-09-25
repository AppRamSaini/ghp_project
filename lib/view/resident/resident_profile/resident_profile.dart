import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_check-in/resident_check_in_cubit.dart';
import 'package:ghp_society_management/controller/resident_checkout_log/resident_check-out/resident_checkout_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/resident/bills/home_bill_section.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/security_staff/dashboard/bottom_navigation.dart';
import 'package:google_fonts/google_fonts.dart';

class ResidentProfileDetails extends StatefulWidget {
  bool forQRPage;
  bool forDetails;
  bool forResident;

  final Map<String, dynamic>? residentId;

  ResidentProfileDetails(
      {super.key,
      this.residentId,
      this.forQRPage = false,
      this.forResident = true,
      this.forDetails = false});

  @override
  State<ResidentProfileDetails> createState() => _ResidentProfileDetailsState();
}

class _ResidentProfileDetailsState extends State<ResidentProfileDetails> {
  late UserProfileCubit _userProfileCubit;

  @override
  void initState() {
    super.initState();
    onRefresh();
  }

  Future onRefresh() async {
    _userProfileCubit = UserProfileCubit();
    if (widget.forDetails) {
      _userProfileCubit.fetchUserProfile();
    } else {
      fetchDetails();
    }

    setState(() {});
  }

  fetchDetails() {
    if (widget.residentId!.containsKey('resident_id')) {
      _userProfileCubit.fetchUserProfile(
          userId: widget.residentId!['resident_id'].toString());
    } else {
      print("Error: 'visitor_id' not found in visitorsId.");
    }
  }

  @override
  void dispose() {
    _userProfileCubit.close();
    super.dispose();
  }

  late BuildContext dialogueContext;

  Future<bool> onCallBack() async {
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //         builder: (_) =>
    //             widget.forResident ? Dashboard() : SecurityGuardDashboard()),
    //     (route) => false);
    return true;
  }

  void onBack(BuildContext buildContext) {
    Future.delayed(Duration.zero, () {
      Navigator.pushAndRemoveUntil(
          buildContext,
          MaterialPageRoute(builder: (_) => SecurityGuardDashboard(index: 1)),
          (route) => false);
    });
  }

  /// verify the user
  void verifyTheUser(BuildContext buildContext, UserProfileData userInfo) {
    if (userInfo.user!.status == 'inactive') {
      snackBarMsg(
          context, "User has been blocked by Admin. Please contact the Admin");
      onBack(buildContext);
      return;
    }
    final unpaidBills = userInfo.unpaidBills!;
    if (unpaidBills != null && unpaidBills.isNotEmpty) {
      final billStatus = checkBillStatus(context, unpaidBills.first);
      print('------------->>>> $billStatus');

      if (billStatus == 'overdue') {
        Future.delayed(const Duration(milliseconds: 10), () {
          overDueBillAlertDialog(context, unpaidBills.first,
              fromStaffSide: true);
        });
        onBack(buildContext);

        return;
      } else {
        lastChecking(buildContext, userInfo.user!);
      }
    } else {
      lastChecking(buildContext, userInfo.user!);
    }
  }

  lastChecking(BuildContext buildContext, User userInfo) {
    final checkInData = {
      "user_id": userInfo.id.toString(),
      "entry_type": widget.forQRPage ? "qr" : 'manual'
    };

    print('------------->>>>$checkInData');
    final lastCheckInDetail = userInfo.lastCheckinDetail;
    if (lastCheckInDetail == null) {
      buildContext
          .read<ResidentCheckInCubit>()
          .checkInAPI(statusBody: checkInData);
    } else {
      switch (lastCheckInDetail.status) {
        case 'checked_in':
          buildContext
              .read<ResidentCheckOutCubit>()
              .checkOutApi(statusBody: checkInData);
          break;
        case 'checked_out':
          buildContext
              .read<ResidentCheckInCubit>()
              .checkInAPI(statusBody: checkInData);
          break;
        default:
          snackBarMsg(context, "Unknown check-in status.");
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ResidentCheckInCubit, ResidentCheckInState>(
          listener: (_, state) {
            if (state is ResidentCheckInLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is ResidentCheckInSuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                onBack(context); // Delay navigation
              });
            } else if (state is ResidentCheckInFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
              onBack(context);
            }
          },
        ),
        BlocListener<ResidentCheckOutCubit, ResidentCheckOutState>(
            listener: (_, state) {
          if (state is ResidentCheckOutLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is ResidentCheckOutSuccessfully) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            Navigator.of(dialogueContext).pop();
            WidgetsBinding.instance.addPostFrameCallback((_) {
              onBack(context);
            });
          } else if (state is ResidentCheckOutFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
            onBack(context);
          }
        }),
      ],
      child: WillPopScope(
        onWillPop: onCallBack,
        child: Scaffold(
          appBar: appbarWidget(title: 'Profile Details'),
          body: BlocBuilder<UserProfileCubit, UserProfileState>(
              bloc: _userProfileCubit,
              builder: (context, state) {
                if (state is UserProfileLoading) {
                  return notificationShimmerLoading();
                } else if (state is UserProfileLoaded) {
                  User usersData = state.userProfile.first.data!.user!;
                  if (!widget.forDetails) {
                    verifyTheUser(context, state.userProfile.first.data!);
                  }

                  return RefreshIndicator(
                    onRefresh: onRefresh,
                    child: SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            SizedBox(height: 10.h),
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.1))),
                              child: Row(
                                children: [
                                  usersData.image != null
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FadeInImage(
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.fill,
                                            placeholder: AssetImage(
                                                'assets/images/profile_icon.png'),
                                            image: NetworkImage(
                                                usersData.image.toString()),
                                            imageErrorBuilder: (_, child, st) =>
                                                Image.asset(
                                                    'assets/images/profile_icon.png',
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.fill),
                                          ),
                                        )
                                      : ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: FadeInImage(
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.fill,
                                            placeholder: AssetImage(
                                                'assets/images/profile_icon.png'),
                                            image: AssetImage(''),
                                            imageErrorBuilder: (_, child, st) =>
                                                Image.asset(
                                                    'assets/images/profile_icon.png',
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.fill),
                                          ),
                                        ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          capitalizeWords(
                                              usersData.name.toString()),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.sp,
                                                  fontWeight:
                                                      FontWeight.w500))),
                                      Text(
                                          usersData.email ??
                                              'Email Not Provided!',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12.sp))),
                                      Text(
                                          capitalizeWords(
                                              usersData.status.toString()),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.green,
                                                  fontSize: 12.sp))),
                                    ],
                                  ),
                                  const SizedBox(width: 5)
                                ],
                              ),
                            ),
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
                                        Text('Date : ',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Text(
                                            formatDate(
                                                usersData.createdAt.toString()),
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)))
                                      ]),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
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
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Text(
                                            '+91 ${usersData.phone.toString()}',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)))
                                      ]),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Divider(
                                          color: Colors.grey.withOpacity(0.1))),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Society Name',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Text(usersData.societyName.toString(),
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.deepPurple,
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w500)))
                                      ]),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 3),
                                      child: Divider(
                                          color: Colors.grey.withOpacity(0.1))),
                                  Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Property No : ',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black45,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Text(usersData.aprtNo ?? 'N/A',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black87,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.w500)))
                                      ]),
                                  widget.forResident
                                      ? Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Divider(
                                              color:
                                                  Colors.grey.withOpacity(0.1)))
                                      : SizedBox(),
                                  widget.forResident
                                      ? Column(
                                          children: [
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Tower / Block : ',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  Text(
                                                      usersData.property!
                                                              .blockName ??
                                                          'N/A',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)))
                                                ]),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                child: Divider(
                                                    color: Colors.grey
                                                        .withOpacity(0.1))),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Unit Type : ',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  Text(
                                                      capitalizeWords(
                                                          usersData.unitType ??
                                                              'N/A'),
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)))
                                                ]),
                                          ],
                                        )
                                      : SizedBox(),
                                  usersData.lastCheckinDetail != null
                                      ? Column(
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                child: Divider(
                                                    color: Colors.grey
                                                        .withOpacity(0.1))),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Last Check-IN : ',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  Text(
                                                      formatDate(usersData
                                                          .lastCheckinDetail!
                                                          .checkinAt
                                                          .toString()),
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)))
                                                ]),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 3),
                                                child: Divider(
                                                    color: Colors.grey
                                                        .withOpacity(0.1))),
                                            Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text('Last Check-Out : ',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black45,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                  Text(
                                                      usersData.lastCheckinDetail!
                                                                  .checkoutAt !=
                                                              null
                                                          ? formatDate(usersData
                                                              .lastCheckinDetail!
                                                              .checkoutAt
                                                              .toString())
                                                          : 'N/A',
                                                      style: GoogleFonts.nunitoSans(
                                                          textStyle: TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500)))
                                                ]),
                                          ],
                                        )
                                      : const SizedBox()
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                } else if (state is UserProfileFailed) {
                  if (widget.forQRPage) {
                    onBack(context);
                  }
                  return Center(
                      child: Text(state.errorMsg.toString(),
                          style:
                              const TextStyle(color: Colors.deepPurpleAccent)));
                } else if (state is UserProfileInternetError) {
                  if (widget.forQRPage) {
                    onBack(context);
                  }
                  return const Center(
                      child: Text("Internet connection error",
                          style: TextStyle(color: Colors.red)));
                } else {
                  if (widget.forQRPage) {
                    onBack(context);
                  }
                  return const SizedBox();
                }
              }),
        ),
      ),
    );
  }
}
