import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/parcel/checkout_parcel/checkout_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/create_parcel/create_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/delete_parcel/delete_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/deliver_parcel/deliver_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_listing/parcel_listing_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_pending_counts/parcel_counts_cubit.dart';
import 'package:ghp_society_management/controller/parcel/receive_parcel/receive_parcel_cubit.dart';
import 'package:ghp_society_management/view/resident/parcel_flow/parcel_management.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/security_staff/parcel_flow_security_staff/create_parcel.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ParcelListingSecurityStaffSide extends StatefulWidget {
  const ParcelListingSecurityStaffSide({super.key});

  @override
  State<ParcelListingSecurityStaffSide> createState() =>
      _ParcelListingSecurityStaffSideState();
}

class _ParcelListingSecurityStaffSideState
    extends State<ParcelListingSecurityStaffSide> {
  final ScrollController _scrollController = ScrollController();

  late ParcelListingCubit _parcelListingCubit;

  @override
  void initState() {
    _parcelListingCubit = ParcelListingCubit()..fetchParcelListingApi('all');
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  late BuildContext dialogueContext;

  Future onRefresh() async {
    _parcelListingCubit.fetchParcelListingApi('all');
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      _parcelListingCubit.loadMoreParcels(filterTypes[currentIndex]);
    }
  }

  int currentIndex = 0;
  List filterTypes = ["all", "pending", "delivered"];

  // popup menu filter
  Widget popMenusForFilter({required BuildContext context}) {
    return CircleAvatar(
      backgroundColor: Colors.white,
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
          return filterOptions2
              .map((selectedOption) => PopupMenuItem(
                  padding: EdgeInsets.zero,
                  value: selectedOption,
                  height: 40,
                  child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 30),
                      child: Text(selectedOption['menu'] ?? "",
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w400)))))
              .toList();
        },
        onSelected: (value) async {
          if (value['menu_id'] == 1) {
            currentIndex = 0;
            _parcelListingCubit.fetchParcelListingApi('all');
          } else if (value['menu_id'] == 2) {
            currentIndex = 1;
            _parcelListingCubit.fetchParcelListingApi('pending');
          } else {
            currentIndex = 2;
            _parcelListingCubit.fetchParcelListingApi('delivered');
          }

          setState(() {});
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<ParcelManagementCubit, ParcelManagementState>(
            listener: (context, state) {
          if (state is CreateParcelSuccess) {
            _parcelListingCubit.fetchParcelListingApi('all');
            context.read<ParcelCountsCubit>().fetchParcelCounts();
          }
        }),
        BlocListener<ParcelListingCubit, ParcelListingState>(
            listener: (context, state) {
          if (state is ParcelListingLogout) {
            sessionExpiredDialog(context);
          }
        }),
        BlocListener<ParcelDeletetCubit, ParcelDeletetState>(
            listener: (context, state) {
          if (state is ParcelDeleteLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is ParcelDeletedSuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            _parcelListingCubit
                .fetchParcelListingApi(filterTypes[currentIndex]);
            context.read<ParcelCountsCubit>().fetchParcelCounts();
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelDeletedFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);

            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelDeletetInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelManagementLogout) {
            Navigator.of(dialogueContext).pop();
            sessionExpiredDialog(context);
          }
        }),
        BlocListener<DeliverParcelCubit, DeliverParcelState>(
            listener: (context, state) {
          if (state is DeliverParcelLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is DeliverParcelSuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            _parcelListingCubit
                .fetchParcelListingApi(filterTypes[currentIndex]);
            context.read<ParcelCountsCubit>().fetchParcelCounts();
            Navigator.of(dialogueContext).pop();
          } else if (state is DeliverParcelFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);

            Navigator.of(dialogueContext).pop();
          } else if (state is DeliverParcelInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is DeliverParcelLogout) {
            Navigator.of(dialogueContext).pop();
            sessionExpiredDialog(context);
          }
        }),
        BlocListener<ParcelCheckoutCubit, ParcelCheckoutState>(
            listener: (context, state) {
          if (state is ParcelCheckoutLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is ParcelCheckoutSuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            _parcelListingCubit
                .fetchParcelListingApi(filterTypes[currentIndex]);

            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelCheckoutFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);

            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelCheckoutInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelCheckoutLogout) {
            Navigator.of(dialogueContext).pop();
            sessionExpiredDialog(context);
          }
        }),
        BlocListener<ReceiveParcelCubit, ReceiveParcelState>(
            listener: (context, state) {
          if (state is ReceiveParcelLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is ReceiveParcelSuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            _parcelListingCubit
                .fetchParcelListingApi(filterTypes[currentIndex]);
            context.read<ParcelCountsCubit>().fetchParcelCounts();

            Navigator.of(dialogueContext).pop();
          } else if (state is ReceiveParcelFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);

            Navigator.of(dialogueContext).pop();
          } else if (state is ReceiveParcelInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is ReceiveParcelLogout) {
            Navigator.of(dialogueContext).pop();
            sessionExpiredDialog(context);
          }
        }),
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text('Parcels',
                style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600))),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: popMenusForFilter(context: context),
              )
            ]),
        floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            backgroundColor: AppTheme.primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => const CreateParcelSecurityStaffSide()));
            },
            child: const Icon(Icons.add, color: Colors.white)),
        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<ParcelListingCubit, ParcelListingState>(
              bloc: _parcelListingCubit,
              builder: (context, state) {
                if (state is ParcelListingLoading &&
                    _parcelListingCubit.parcelListing.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (state is ParcelListingFailed) {
                  return Center(
                      child: Text(state.errorMsg,
                          style:
                              const TextStyle(color: Colors.deepPurpleAccent)));
                }
                if (state is ParcelListingInternetError) {
                  return Center(
                      child: Text(state.errorMsg.toString(),
                          style: const TextStyle(color: Colors.red)));
                }
                var parcelList = _parcelListingCubit.parcelListing;
                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(bottom: 120, top: 10),
                  itemCount: parcelList.length + 1,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    if (index == parcelList.length) {
                      return _parcelListingCubit.state
                              is NotificationListingLoadingMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()))
                          : const SizedBox.shrink();
                    }
                    final parcelData = parcelList[index];
                    String formattedDate =
                        DateFormat('dd MMM yyyy').format(parcelData.date!);
                    DateTime parsedTime =
                        DateFormat("HH:mm:ss").parse(parcelData.time!);
                    String formattedTime = DateFormat.jm().format(
                        parsedTime); // This will convert it to "6:46 PM"

                    String status() {
                      if (parcelData.checkinDetail == null) {
                        return 'Pending';
                      } else {
                        final checkinStatus = parcelData.checkinDetail?.status;
                        final handoverStatus = parcelData.handoverStatus;
                        final entryRole = parcelData.entryByRole;
                        final receivedByRole = parcelData.receivedByRole;

                        if (checkinStatus == 'checked_in' &&
                            handoverStatus != 'delivered') {
                          return "Checked IN";
                        }
                        if (handoverStatus == 'delivered' &&
                            checkinStatus == 'checked_in') {
                          return 'Not Checkout';
                        }
                        if (handoverStatus == 'received' &&
                            entryRole == 'staff_security_guard') {
                          return 'Not Delivered';
                        }

                        if (handoverStatus == 'received' &&
                            receivedByRole == 'staff_security_guard') {
                          return 'Not Delivered';
                        } else {
                          return "Delivered";
                        }
                      }
                      return "Delivered";

                      //
                      // if (parcelData.handoverStatus == "pending") {
                      //   if (parcelData.checkinDetail == null) {
                      //     return 'Pending';
                      //   }
                      //   final checkinStatus =
                      //       parcelData.checkinDetail?.status;
                      //   final handoverStatus =
                      //       parcelData.handoverStatus;
                      //   final entryRole = parcelData.entryByRole;
                      //
                      //   if (checkinStatus == 'checked_in' &&
                      //       handoverStatus != 'delivered') {
                      //     return "Checked IN";
                      //   }
                      //
                      //   if (handoverStatus == 'received' ||
                      //       entryRole == 'staff_security_guard') {
                      //     return 'Not Delivered';
                      //   }
                      //
                      //   if (handoverStatus == 'delivered' &&
                      //       checkinStatus == 'checked_in') {
                      //     return 'Not Checkout';
                      //   }
                      //
                      //   return "Pending";
                      // }else{
                      //   return "Delivered";
                      // }
                    }

                    //
                    //     if (parcelData.checkinDetail!.status ==
                    //         'checked_in') {
                    //       return "Checked IN";
                    //     }
                    //     return parcelData.entryByRole ==
                    //             'staff_security_guard'
                    //         ? "Not Delivered"
                    //         : "Pending";
                    //   }
                    //   return parcelData.entryByRole ==
                    //           'staff_security_guard'
                    //       ? "Not Delivered"
                    //       : "Pending";
                    // } else if (parcelData.handoverStatus ==
                    //     'received') {
                    //   return 'Not Delivered';
                    // }
                    // return "Delivered";

                    List<Map<String, dynamic>> options() {
                      if (parcelData.handoverStatus == 'pending' &&
                          parcelData.checkinDetail == null) {
                        return optionList4;
                      }

                      final checkinStatus = parcelData.checkinDetail?.status;
                      final handoverStatus = parcelData.handoverStatus;

                      if (checkinStatus == 'checked_in') {
                        return optionList6;
                      }

                      if (checkinStatus == 'checked_out' &&
                          handoverStatus == 'received') {
                        return optionList2;
                      }

                      return optionList3;
                    }

                    return Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey[300]!)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                        placeholder: const AssetImage(
                                            "assets/images/default.jpg"),
                                        imageErrorBuilder:
                                            (context, error, stackTrace) {
                                          return Image.asset(
                                            "assets/images/default.jpg",
                                            height: 70,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                        image: NetworkImage(parcelData
                                            .deliveryAgentImage
                                            .toString()),
                                        fit: BoxFit.cover,
                                        height: 70,
                                        width: 70)),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                GestureDetector(
                                                  onTap: () {
                                                    if (parcelData
                                                            .parcelComplaint !=
                                                        null) {
                                                      readComplaintDialog(
                                                          context,
                                                          parcelData
                                                              .parcelComplaint!
                                                              .description
                                                              .toString());
                                                    }
                                                  },
                                                  child: Row(
                                                    children: [
                                                      Text(
                                                          parcelData.parcelid
                                                              .toString(),
                                                          style: GoogleFonts.nunitoSans(
                                                              textStyle: TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      14.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                          overflow: TextOverflow
                                                              .ellipsis),
                                                      parcelData.parcelComplaint ==
                                                              null
                                                          ? const SizedBox()
                                                          : const Icon(
                                                              Icons
                                                                  .info_outline,
                                                              color: Colors.red,
                                                              size: 15),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(height: 2.h),
                                                Text(
                                                    parcelData.parcelName
                                                        .toString(),
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w500)),
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                                SizedBox(height: 2.h),
                                                Text(
                                                    '$formattedDate | $formattedTime',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize: 14.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400)))
                                              ]),
                                          parcelData.entryByRole ==
                                                  "staff_security_guard"
                                              ? popMenusForStaff(
                                                  isStaffSide: true,
                                                  options: options(),
                                                  context: context,
                                                  requestData: parcelData)
                                              : popMenusForResident(
                                                  options: parcelData
                                                              .handoverStatus ==
                                                          'pending'
                                                      ? optionList4
                                                      : parcelData.handoverStatus ==
                                                              'received'
                                                          ? optionList2
                                                          : optionList3,
                                                  context: context,
                                                  requestData: parcelData)
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                    'Created By: ${capitalizeWords(parcelData.entryByRole.toString().replaceAll("_", " ").replaceAll("staff", '').replaceAll("admin", 'Resident'))}',
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black54,
                                            fontSize: 13.sp))),
                                Text(
                                  status().toString(),
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: parcelData.handoverStatus == 'pending' ||
                                          parcelData.checkinDetail == null ||
                                          parcelData.checkinDetail!.checkoutAt == null
                                          ? Colors.red
                                          : parcelData.handoverStatus == 'received'
                                          ? Colors.orange
                                          : Colors.green,
                                      fontSize: 13.sp,
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Divider(color: Colors.green.withOpacity(0.1)),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Name',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12.sp))),
                                      Text(parcelData.member!.name.toString(),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600)))
                                    ]),
                                // Column(
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.center,
                                //     children: [
                                //       Text('Phone',
                                //           style:
                                //               GoogleFonts.nunitoSans(
                                //                   textStyle: TextStyle(
                                //                       color: Colors
                                //                           .black54,
                                //                       fontSize:
                                //                           12.sp))),
                                //       Text(
                                //           "+91 ${parcelData.member!.phone.toString()}",
                                //           style:
                                //               GoogleFonts.nunitoSans(
                                //                   textStyle: TextStyle(
                                //                       color: Colors
                                //                           .black,
                                //                       fontSize: 12.sp,
                                //                       fontWeight:
                                //                           FontWeight
                                //                               .w600)))
                                //     ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Tower ',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12.sp))),
                                      Text(
                                          parcelData.member!.blockName
                                              .toString(),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600)))
                                    ]),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text('Floor',
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black54,
                                                  fontSize: 12.sp))),
                                      Text(
                                          parcelData.member!.floorNumber
                                              .toString(),
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12.sp,
                                                  fontWeight: FontWeight.w600)))
                                    ]),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Property No',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12.sp))),
                                    Text(
                                      parcelData.member!.aprtNo.toString(),
                                      style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                );
              }),
        ),
      ),
    );
  }
}
