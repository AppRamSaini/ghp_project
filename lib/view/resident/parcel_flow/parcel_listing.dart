import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/parcel/create_parcel/create_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/delete_parcel/delete_parcel_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_complaint/parcel_complaint_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_listing/parcel_listing_cubit.dart';
import 'package:ghp_society_management/controller/parcel/receive_parcel/receive_parcel_cubit.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/resident/bills/my_bills.dart';
import 'package:ghp_society_management/view/resident/parcel_flow/create_parcel.dart';
import 'package:ghp_society_management/view/resident/parcel_flow/parcel_management.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:intl/intl.dart';
import 'package:searchbar_animation/const/colours.dart';

class ParcelListingPage extends StatefulWidget {
  const ParcelListingPage({super.key});

  @override
  State<ParcelListingPage> createState() => _ParcelListingPageState();
}

class _ParcelListingPageState extends State<ParcelListingPage> {
  final ScrollController _scrollController = ScrollController();

  late ParcelListingCubit _parcelListingCubit;
  late UserProfileCubit _userProfileCubit;

  @override
  void initState() {
    _parcelListingCubit = ParcelListingCubit()..fetchParcelListingApi('all');
    _scrollController.addListener(_onScroll);
    super.initState();
    print("UserProfileCubit Called");
    _userProfileCubit = UserProfileCubit();
    _userProfileCubit.fetchUserProfile();
  }

  late BuildContext dialogueContext;

  Future onRefresh() async {
    _parcelListingCubit.fetchParcelListingApi('all');
    setState(() {});
  }

  bool _dialogShown = false;

  @override
  void dispose() {
    _dialogShown = false; // Reset for next time
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
      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
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
          return filterOptions
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
        // BlocListener<UserProfileCubit, UserProfileState>(
        //   listenWhen: (previous, current) {
        //     return current is UserProfileLoaded && !_dialogShown;
        //   },
        //   listener: (context, state) {
        //     if (state is UserProfileLoaded) {
        //       _dialogShown = true;
        //
        //     }
        //   },
        // ),
        BlocListener<ParcelManagementCubit, ParcelManagementState>(
            listener: (context, state) {
          if (state is CreateParcelSuccess) {
            _parcelListingCubit.fetchParcelListingApi('all');
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
            _parcelListingCubit.fetchParcelListingApi('all');
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
        BlocListener<ParcelComplaintCubit, ParcelComplaintState>(
            listener: (context, state) {
          if (state is ParcelComplaintLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is ParcelComplaintSuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            _parcelListingCubit.fetchParcelListingApi('all');
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelComplaintFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelComplaintInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is ParcelComplaintLogout) {
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
            _parcelListingCubit.fetchParcelListingApi('all');
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
        floatingActionButton: BlocBuilder<UserProfileCubit, UserProfileState>(
          bloc: _userProfileCubit,
          builder: (context, profileState) {
            if (profileState is UserProfileLoaded) {
              Future.delayed(const Duration(milliseconds: 5), () {
                List<UnpaidBill> billData =
                    profileState.userProfile.first.data!.unpaidBills!;
                if (billData.isNotEmpty) {
                  checkPaymentReminder(
                      context: context,
                      myUnpaidBill: profileState
                          .userProfile.first.data!.unpaidBills!.first);
                }
              });
            }
            return FloatingActionButton(
              backgroundColor: AppTheme.primaryColor,
              onPressed: () {
                if (profileState is UserProfileLoaded) {
                  List<UnpaidBill> billData =
                      profileState.userProfile.first.data!.unpaidBills!;

                  if (billData.isNotEmpty) {
                    String status = checkBillStatus(context, billData.first);

                    if (status == 'overdue') {
                      overDueBillAlertDialog(context, billData.first);
                    } else {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (builder) => const CreateParcelPage()));
                    }
                  } else {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => const CreateParcelPage()));
                  }
                }
              },
              child: const Icon(Icons.add, color: Colors.white),
            );
          },
        ),

        appBar: AppBar(title: Text('Parcels',
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600))),actions: [ Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: popMenusForFilter(context: context),
                    )]),
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
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent)));
              }

              if (state is ParcelListingInternetError) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style: const TextStyle(color: Colors.red)));
              }

              var parcelsList = _parcelListingCubit.parcelListing;

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: parcelsList.length + 1,
                padding: const EdgeInsets.only(bottom: 120),
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  if (index == parcelsList.length) {
                    return _parcelListingCubit.state
                            is NotificationListingLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                                child: CircularProgressIndicator
                                    .adaptive()))
                        : const SizedBox.shrink();
                  }

                  final parcels = parcelsList[index];
                  String formattedDate =
                      DateFormat('dd MMM yyyy').format(parcels.date!);
                  String timeString = parcels.time!;
                  DateTime parsedTime =
                      DateFormat("HH:mm:ss").parse(timeString);
                  String formattedTime =
                      DateFormat.jm().format(parsedTime);
                  String status() {
                    if (parcels.handoverStatus == "pending") {
                      if (parcels.checkinDetail != null) {
                        if (parcels.checkinDetail!.status ==
                            'checked_in') {
                          return "Parcel Arrived";
                        }
                        return parcels.entryByRole ==
                                'staff_security_guard'
                            ? "Received By Staff"
                            : "Not Received";
                      }
                      return parcels.entryByRole ==
                              'staff_security_guard'
                          ? "Received By Staff"
                          : "Pending";
                    } else if (parcels.handoverStatus == 'received') {
                      return 'Received By Staff';
                    }
                    return "Received";
                  }

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey[300]!)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
                          children: [
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(10),
                                    child: FadeInImage(
                                        placeholder: const AssetImage(
                                            "assets/images/default.jpg"),
                                        imageErrorBuilder: (context,
                                            error, stackTrace) {
                                          return Image.asset(
                                              "assets/images/default.jpg",
                                              height: 70,
                                              width: 70,
                                              fit: BoxFit.cover);
                                        },
                                        image: NetworkImage(parcels
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
                                            MainAxisAlignment
                                                .spaceBetween,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (parcels
                                                          .parcelComplaint !=
                                                      null) {
                                                    readComplaintDialog(
                                                        context,
                                                        parcels
                                                            .parcelComplaint!
                                                            .description
                                                            .toString());
                                                  }
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(
                                                        parcels
                                                            .parcelid
                                                            .toString(),
                                                        style: GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .deepPurpleAccent,
                                                                fontSize: 14
                                                                    .sp,
                                                                fontWeight: FontWeight
                                                                    .w500)),
                                                        overflow:
                                                            TextOverflow
                                                                .ellipsis),
                                                    parcels.parcelComplaint ==
                                                            null
                                                        ? const SizedBox()
                                                        : const Icon(
                                                            Icons
                                                                .info_outline,
                                                            color: Colors
                                                                .red,
                                                            size: 12),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 2.h),
                                              Text(
                                                  parcels.parcelName
                                                      .toString(),
                                                  style: GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                          color: Colors
                                                              .black,
                                                          fontSize:
                                                              12,
                                                          fontWeight:
                                                              FontWeight
                                                                  .w500)),
                                                  overflow:
                                                      TextOverflow
                                                          .ellipsis),
                                              SizedBox(height: 2.h),
                                            ],
                                          ),
                                          popMenusForStaff(
                                              options:
                                                  parcels.handoverStatus !=
                                                          'pending'
                                                      ? optionList0
                                                      : optionList,
                                              context: context,
                                              requestData: parcels)
                                        ],
                                      ),
                                      Text(
                                        'Arrive At : $formattedDate  |  $formattedTime',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                                fontWeight:
                                                    FontWeight.w400)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 3),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                      'Created By : ${capitalizeWords(parcels.entryByRole.toString().replaceAll("_", " ").replaceAll("staff", ''))}',
                                      style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                              color: Colors.black54,
                                              fontSize: 12))),
                                  Text(
                                    status(),
                                    style: GoogleFonts.nunitoSans(
                                        textStyle: TextStyle(
                                            color: parcels
                                                        .handoverStatus ==
                                                    'pending'
                                                ? Colors.red
                                                : parcels.handoverStatus ==
                                                        'received'
                                                    ? Colors.orange
                                                    : Colors.green,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }
}
