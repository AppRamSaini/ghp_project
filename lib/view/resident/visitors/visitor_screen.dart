import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/visitors/delete_visitors/delete_visitor_cubit.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/accept_request/accept_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/not_responding/not_responde_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitors_feedback/visitors_feedback_cubit.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/model/visitors_listing_model.dart';
import 'package:ghp_society_management/view/resident/bills/my_bills.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/resident/visitors/add_visitor_screen.dart';
import 'package:ghp_society_management/view/resident/visitors/generate_qr_code.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:ghp_society_management/view/resident/visitors/visitors_details_page.dart';
import 'package:intl/intl.dart';
import 'package:simple_ripple_animation/simple_ripple_animation.dart';

class VisitorScreen extends StatefulWidget {
  const VisitorScreen({super.key});
  @override
  State<VisitorScreen> createState() => _VisitorScreenState();
}

class _VisitorScreenState extends State<VisitorScreen> {
  late VisitorsListingCubit _visitorsListingCubit;
  final ScrollController _scrollController = ScrollController();
  late UserProfileCubit _userProfileCubit;
  @override
  void initState() {
    super.initState();
    context.read<IncomingRequestCubit>().fetchIncomingRequest();
    _visitorsListingCubit = VisitorsListingCubit();
    fetchData();
    _scrollController.addListener(_onScroll);
    _userProfileCubit = UserProfileCubit();
    _userProfileCubit.fetchUserProfile();
  }

  Future<void> fetchData() async {
    context.read<IncomingRequestCubit>().fetchIncomingRequest();
    _visitorsListingCubit = VisitorsListingCubit()
      ..fetchVisitorsListing(
          fromDate: '',
          toDate: '',
          search: '',
          filterTypes: '',
          context: context);
    setState(() {});
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      _visitorsListingCubit.loadMoreVisitorsUsers(context, '', '', '', '');
    }
  }

  late BuildContext dialogueContext;
  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IncomingRequestCubit, IncomingRequestState>(
            listener: (context, state) {
          if (state is IncomingRequestLoaded) {
            IncomingVisitorsModel incomingVisitorsRequest =
                state.incomingVisitorsRequest;
            if (incomingVisitorsRequest.lastCheckinDetail!.status ==
                'requested') {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VisitorsIncomingRequestPage(
                          incomingVisitorsRequest: incomingVisitorsRequest,
                          fromForegroundMsg: true,
                          setPageValue: (value) {})));
            }
          }
        }),
        BlocListener<AcceptRequestCubit, AcceptRequestState>(
          listener: (context, state) {
            if (state is AcceptRequestSuccessfully) {
              fetchData();
              context.read<IncomingRequestCubit>().fetchIncomingRequest();
            }
          },
        ),
        BlocListener<NotRespondingCubit, NotRespondingState>(
            listener: (context, state) {
          if (state is NotRespondingSuccessfully) {
            fetchData();
            context.read<IncomingRequestCubit>().fetchIncomingRequest();
          }
        }),
        BlocListener<UpdateVisitorsStatusCubit, UpdateVisitorsStatusState>(
          listener: (context, state) {
            if (state is UpdateVisitorsStatusLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is UpdateVisitorsStatusSuccessfully) {
              fetchData();
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is UpdateVisitorsStatusFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is UpdateVisitorsStatusInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is UpdateVisitorsStatusLogout) {
              Navigator.of(dialogueContext).pop();
              sessionExpiredDialog(context);
            }
          },
        ),
        BlocListener<VisitorsFeedBackCubit, VisitorsFeedBackState>(
          listener: (context, state) {
            if (state is VisitorsFeedBackLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is VisitorsFeedBackSuccessfully) {
              fetchData();
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is VisitorsFeedBackFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is VisitorsFeedBackInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else {
              Navigator.of(dialogueContext).pop();
            }
          },
        ),
        BlocListener<DeleteVisitorCubit, DeleteVisitorState>(
          listener: (context, state) {
            if (state is DeleteVisitorLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is DeleteVisitorSuccessfully) {
              fetchData();
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is DeleteVisitorFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else if (state is DeleteVisitorInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);
              Navigator.of(dialogueContext).pop();
            } else {
              Navigator.of(dialogueContext).pop();
            }
          },
        ),
        BlocListener<CreateVisitorsCubit, CreateVisitorsState>(
            listener: (context, state) {
          if (state is CreateVisitorsSuccessfully) {
            fetchData();
          }
        })
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('Visitors',
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600))),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: BlocBuilder<IncomingRequestCubit, IncomingRequestState>(
                builder: (context, state) {
                  if (state is IncomingRequestLoaded) {
                    IncomingVisitorsModel incomingVisitorsRequest =
                        state.incomingVisitorsRequest;
                    if (incomingVisitorsRequest.lastCheckinDetail!.status ==
                        'requested') {
                      return Stack(
                        alignment: Alignment.topLeft,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: RippleAnimation(
                                color: Colors.red,
                                delay: const Duration(milliseconds: 300),
                                repeat: true,
                                minRadius: 20,
                                maxRadius: 50,
                                ripplesCount: 6,
                                duration: const Duration(milliseconds: 1800),
                                child: CircleAvatar(
                                  radius: 19,
                                  child: CircleAvatar(
                                      radius: 18,
                                      backgroundColor: AppTheme.primaryColor,
                                      child: const Icon(
                                          Icons.notification_important_outlined,
                                          color: Colors.white,
                                          size: 19)),
                                )),
                          ),
                          CircleAvatar(
                            radius: 11,
                            child: Text("1",
                                style: GoogleFonts.nunitoSans(
                                    textStyle: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.w600))),
                          )
                        ],
                      );
                    }
                  }

                  return CircleAvatar(
                    radius: 19,
                    child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppTheme.primaryColor,
                        child: const Icon(Icons.notification_important_outlined,
                            color: Colors.white, size: 19)),
                  );
                },
              ),
            ),
          ],
        ),
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
                      final profile = profileState.userProfile.first;

                      final List<UnpaidBill>? billData = profile.data?.unpaidBills;

                      if (billData != null && billData.isNotEmpty) {
                        String status = checkBillStatus(context, billData.first);

                        if (status == 'overdue') {
                          overDueBillAlertDialog(context, billData.first);
                        } else {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => AddVisitorScreen(isTypeResidence: true),
                            ),
                          );
                        }
                      } else {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddVisitorScreen(isTypeResidence: true),
                          ),
                        );
                      }
                    }

                  },
                  child: const Icon(Icons.add, color: Colors.white));
            }),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: RefreshIndicator(
                    onRefresh: fetchData,
                    child: BlocBuilder<VisitorsListingCubit,
                            VisitorsListingState>(
                        bloc: _visitorsListingCubit,
                        builder: (context, state) {
                          if (state is VisitorsListingLoading &&
                              _visitorsListingCubit.visitorsListing.isEmpty) {
                            return const Center(
                                child: CircularProgressIndicator.adaptive(
                                    backgroundColor: Colors.deepPurpleAccent));
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

                          var visitorsList =
                              _visitorsListingCubit.visitorsListing;

                          if (visitorsList.isEmpty) {
                            return const Center(
                                child: Text("Visitors Not Found!",
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent)));
                          }

                          return ListView.builder(
                            padding: const EdgeInsets.only(bottom: 100),
                            controller: _scrollController,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: visitorsList.length + 1,
                            itemBuilder: ((context, index) {
                              if (index == visitorsList.length) {
                                return _visitorsListingCubit.state
                                        is ViewVisitorsLoadingMore
                                    ? const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                            child: CircularProgressIndicator()))
                                    : const SizedBox.shrink();
                              }

                              VisitorsListing visitors = visitorsList[index];

                              String formattedDate = DateFormat('dd MMM yyyy')
                                  .format(visitors.date);
                              String timeString =
                                  visitors.time; // e.g., "18:46:00"
                              DateTime parsedTime =
                                  DateFormat("HH:mm:ss").parse(timeString);
                              String formattedTime = DateFormat.jm().format(
                                  parsedTime); // This will convert it to "6:46 PM"

                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: colorStatus(visitors),
                                      border: Border.all(
                                          color: colorStatus(visitors))),
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
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10),
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  child: FadeInImage(
                                                      placeholder: const AssetImage(
                                                          "assets/images/default.jpg"),
                                                      imageErrorBuilder:
                                                          (context, error,
                                                              stackTrace) {
                                                        return Image.asset(
                                                            "assets/images/default.jpg",
                                                            height: 80,
                                                            width: 80,
                                                            fit: BoxFit.cover);
                                                      },
                                                      image: NetworkImage(
                                                          visitors.image
                                                              .toString()),
                                                      fit: BoxFit.cover,
                                                      height: 80,
                                                      width: 80)),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Text(
                                                            capitalizeWords(
                                                                visitors
                                                                    .visitorName
                                                                    .toString()),
                                                            style: GoogleFonts
                                                                .nunitoSans(
                                                              textStyle:
                                                                  TextStyle(
                                                                color: Colors
                                                                    .black,
                                                                fontSize: 15,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          const SizedBox(
                                                              width: 5),
                                                          if (visitors.status ==
                                                              "inactive")
                                                            const Icon(
                                                                Icons.block,
                                                                color:
                                                                    Colors.red,
                                                                size: 20),
                                                        ],
                                                      ),
                                                      const SizedBox(width: 10),

                                                      /// GestureDetector for More Options
                                                      GestureDetector(
                                                        onTap: () {
                                                          visitorsModelBottomSheet(
                                                              context,
                                                              const Offset(
                                                                  10, 150),
                                                              visitors);
                                                        },
                                                        child: Container(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(3),
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color: AppTheme
                                                                      .primaryColor
                                                                      .withOpacity(
                                                                          0.5)),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          50)),
                                                          child: Icon(
                                                            Icons.more_horiz,
                                                            color: AppTheme
                                                                .primaryColor,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),

                                                  /// Using Wrap ensures text wraps to new line if needed
                                                  Wrap(children: [
                                                    Text(
                                                        'Visitors Types : ${visitors.typeOfVisitor}',
                                                        style: GoogleFonts.nunitoSans(
                                                            textStyle: TextStyle(
                                                                color: Colors
                                                                    .black54,
                                                                fontSize:
                                                                    12)))
                                                  ]),

                                                  Wrap(
                                                    children: [
                                                      Text(
                                                        'Visiting Frequency : ${visitors.visitingFrequency}',
                                                        style: GoogleFonts
                                                            .nunitoSans(
                                                          textStyle: TextStyle(
                                                            color:
                                                                Colors.black54,
                                                            fontSize: 12,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  Text(
                                                    'Arrive At : $formattedDate  |  $formattedTime',
                                                    style:
                                                        GoogleFonts.nunitoSans(
                                                      textStyle: TextStyle(
                                                        color: Colors.black54,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    ),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                  status(visitors),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),

                                        Divider(
                                            color:
                                                Colors.grey.withOpacity(0.2)),

                                        /// Wrap for Purpose of Visit
                                        Wrap(
                                          children: [
                                            Text(
                                              visitors.purposeOfVisit
                                                  .toString(),
                                              style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                  color: Colors.black87,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          );
                        }),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// VISITORS STATUS
colorStatus(VisitorsListing visitors) {
  if (visitors.lastCheckinDetail == null) {
    return Colors.deepOrange.withOpacity(0.05);
  } else if (visitors.lastCheckinDetail.status == 'not_responded') {
    return Colors.orange.withOpacity(0.05);
  } else if (visitors.lastCheckinDetail.status == 'not_allowed') {
    return Colors.red.withOpacity(0.05);
  } else if (visitors.lastCheckinDetail.status == 'allowed' ||
      visitors.lastCheckinDetail.status == 'checked_in') {
    return Colors.green.withOpacity(0.05);
  } else if (visitors.lastCheckinDetail.status == 'checked_out') {
    return Colors.teal.withOpacity(0.05);
  }
  return Colors.deepOrange.withOpacity(0.05);
}

/// VISITORS STATUS
Widget status(VisitorsListing visitors) {
  if (visitors.lastCheckinDetail == null) {
    return const Text("Not Arrived",
        style: TextStyle(color: Colors.deepOrange, fontSize: 12));
  } else if (visitors.lastCheckinDetail.status == 'not_responded') {
    return const Text("Not Respond",
        style: TextStyle(color: Colors.orange, fontSize: 12));
  } else if (visitors.lastCheckinDetail.status == 'not_allowed') {
    return const Text("Not Allowed",
        style: TextStyle(color: Colors.red, fontSize: 12));
  } else if (visitors.lastCheckinDetail.status == 'allowed' ||
      visitors.lastCheckinDetail.status == 'checked_in') {
    return const Text("Arrived",
        style: TextStyle(color: Colors.green, fontSize: 12));
  } else if (visitors.lastCheckinDetail.status == 'checked_out') {
    return const Text("Completed",
        style: TextStyle(color: Colors.teal, fontSize: 12));
  }
  return const Text("Not Arrived",
      style: TextStyle(color: Colors.deepOrange, fontSize: 12));
}

/// VISITORS MODELS  SHEET
void visitorsModelBottomSheet(
    BuildContext buildContext, Offset offset, VisitorsListing visitors) {
  showModalBottomSheet(
    isScrollControlled: true,
    context: buildContext,
    enableDrag: false,
    builder: (BuildContext _context) {
      return Container(
        decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Actions',
                        style: TextStyle(color: Colors.black)),
                    GestureDetector(
                        onTap: () => Navigator.pop(_context),
                        child: const Icon(Icons.clear, color: Colors.black))
                  ]),
            ),
            Divider(color: Colors.black45.withOpacity(0.1)),
            ListTile(
                onTap: () {
                  Map<String, String> statusData;
                  Navigator.pop(_context);
                  if (visitors.status == 'active') {
                    statusData = {"status": "inactive"};
                  } else {
                    statusData = {"status": "active"};
                  }
                  _context
                      .read<UpdateVisitorsStatusCubit>()
                      .updateVisitorsStatusAPI(
                          visitorId: visitors.id.toString(),
                          statusBody: statusData);
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.block, color: Colors.red),
                title: Text(visitors.status == 'active' ? 'Block' : 'UnBlock')),
            Divider(color: Colors.black45.withOpacity(0.1), height: 0),
            ListTile(
                onTap: () {
                  Navigator.pop(_context);
                  visitorsDeletePermissionDialog(buildContext, () {
                    Navigator.pop(buildContext);
                    buildContext
                        .read<DeleteVisitorCubit>()
                        .deleteVisitorAPI(visitors.id.toString());
                  });
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete')),
            Divider(color: Colors.black45.withOpacity(0.1), height: 0),
            ListTile(
                onTap: () {
                  Navigator.pop(_context);
                  Navigator.push(
                      _context,
                      MaterialPageRoute(
                          builder: (_) => VisitorGatePass(visitors: visitors)));
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.qr_code, color: Colors.green),
                title: const Text('Generate QR')),
            Divider(color: Colors.black45.withOpacity(0.1), height: 0),
            ListTile(
                onTap: () {
                  Navigator.pop(_context);
                  Navigator.push(
                      _context,
                      MaterialPageRoute(
                          builder: (_) => VisitorsDetailsPage(
                              visitorsId: visitors.id.toString())));
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.visibility, color: Colors.teal),
                title: const Text('Visitor\'s Details')),
            Divider(color: Colors.black45.withOpacity(0.1), height: 0),
            ListTile(
                onTap: () {
                  if (visitors.visitorFeedback != null) {
                    Navigator.pop(_context);
                    snackBar(_context, 'Visitor`s Feedback AllReady Added!',
                        Icons.warning, AppTheme.redColor);
                  } else {
                    Navigator.pop(_context);
                    visitorsFeedbackDialog(buildContext, visitors);
                  }
                },
                contentPadding: EdgeInsets.zero,
                dense: true,
                leading: const Icon(Icons.feedback, color: Colors.blue),
                title: const Text('Visitor\'s Feedback')),
          ],
        ),
      );
    },
  );
}

/// Custom formatter to auto-insert '-' in the correct places
class VehicleNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String text =
        newValue.text.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');

    String formatted = "";
    for (int i = 0; i < text.length; i++) {
      if (i == 2 || i == 4 || i == 6) formatted += "-";
      formatted += text[i];
    }

    return newValue.copyWith(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
