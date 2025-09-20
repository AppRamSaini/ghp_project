import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_in/check_in_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/check_out/check_out_cubit.dart';
import 'package:ghp_society_management/controller/visitors/chek_in_check_out/visitors_scan/scan_visitors_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/not_responding/not_responde_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitor_request/resend_request/resend_request_cubit.dart';
import 'package:ghp_society_management/controller/visitors/visitors_listing_staff_side/visitors_cubit.dart';
import 'package:ghp_society_management/timer_countdown.dart';
import 'package:ghp_society_management/view/security_staff/visitors/visitors_tab.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VisitorsListPage extends StatefulWidget {
  final int index;
  final String type;

  const VisitorsListPage({super.key, required this.type, required this.index});

  @override
  State<VisitorsListPage> createState() => _VisitorsListPageState();
}

class _VisitorsListPageState extends State<VisitorsListPage> {
  final TextEditingController searchController = TextEditingController();
  final TextEditingController fromDate = TextEditingController();
  final TextEditingController toDate = TextEditingController();

  bool searchBarOpen = false;
  DateTime selectFromDate = DateTime.now();
  DateTime selectToDate = DateTime.now();

  late VisitorsListingCubit _visitorsListingCubit;
  final List<String> filterList = ['today_list', 'past_list'];
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _visitorsListingCubit = VisitorsListingCubit()
      ..fetchVisitorsListing(
          fromDate: '',
          toDate: '',
          search: searchController.text.toString(),
          filterTypes: filterList[widget.index].toString(),
          context: context,
          fotStaffSide: true);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 300) {
      _visitorsListingCubit.loadMoreVisitorsUsers(
          context,
          filterList[widget.index].toString(),
          searchController.text.toLowerCase().toString(),
          fromDate.text.toString(),
          toDate.text.toString(),
          forStaffSide: true);
    }
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectFromDate,
        firstDate: DateTime(2024), // Restrict to today or later
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectFromDate = picked;
        fromDate.text = DateFormat('yyyy-MM-dd').format(selectFromDate);
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectToDate,
        firstDate: DateTime(2024),
        lastDate: DateTime(2101));
    if (picked != null) {
      setState(() {
        selectToDate = picked;
        toDate.text = DateFormat('yyyy-MM-dd').format(selectToDate);
        _visitorsListingCubit.fetchVisitorsListing(
            fromDate: fromDate.text.toString(),
            toDate: toDate.text.toString(),
            context: context,
            search: searchController.text.toString(),
            filterTypes: filterList[widget.index].toString());
      });
    }
  }

  Future fetchData() async {
    fromDate.clear();
    toDate.clear();
    _visitorsListingCubit.fetchVisitorsListing(
        fromDate: '',
        toDate: '',
        context: context,
        search: searchController.text.toString(),
        filterTypes: filterList[widget.index].toString(),
        fotStaffSide: true);

    setState(() {});
  }

  late BuildContext dialogueContext;

  void _handleNotResponding(String visitorsId) {
    print('----------->>>>>called not responding');
    var requestBody = {"visitor_id": visitorsId.toString()};
    context
        .read<NotRespondingCubit>()
        .notRespondingAPI(statusBody: requestBody);
  }

  Timer? periodicTimer;

  void _startCountdownAndAPICalls(String visitorsId) {
    const duration = Duration(seconds: 4);
    const totalTime = 59;
    int remainingTime = totalTime;

    timerCountdownDialog(
      context: context,
      setDialogueContext: (ctx) {
        dialogueContext = ctx;
      },
      onComplete: () {
        if (mounted) {
          periodicTimer?.cancel();
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
  }

  void stopTimerDialog() {
    if (mounted) {
      periodicTimer?.cancel();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    dialogueContext = context;
  }

  @override
  Widget build(BuildContext _ctx) {
    return MultiBlocListener(
      listeners: [
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
              fetchData();
            }
          },
        ),
        BlocListener<CheckOutCubit, CheckOutState>(listener: (context, state) {
          if (state is CheckOutLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is CheckOutSuccessfully) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            fetchData();
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
              fetchData();
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
              fetchData();
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
      child: Scaffold(
        appBar: customAppbar(
            context: context,
            title: widget.type == 'T_V' ? 'Today Visitors' : "Past Visitors",
            textController: searchController,
            onExpansionComplete: () {
              setState(() {
                searchBarOpen = true;
              });
            },
            onCollapseComplete: () {
              searchController.clear();
              setState(() {
                searchBarOpen = false;
                fetchData();
              });
            },
            onPressButton: (isSearchBarOpens) {
              setState(() {
                searchBarOpen = true;
              });
            },
            onChanged: (value) {
              _visitorsListingCubit = VisitorsListingCubit()
                ..fetchVisitorsListing(
                    fromDate: fromDate!.text.toString(),
                    toDate: toDate!.text.toString(),
                    context: context,
                    search: searchController.text.toString(),
                    filterTypes: filterList[widget.index].toString(),
                    fotStaffSide: true);
              setState(() {});
            }),
        body: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: RefreshIndicator(
            onRefresh: fetchData,
            child: Column(
              children: [
                widget.type == 'T_V'
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: Row(
                          children: [
                            Expanded(
                                child: TextFormField(
                                    onTap: () {
                                      _selectFromDate(context);
                                    },
                                    readOnly: true,
                                    controller: fromDate,
                                    style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.w500),
                                    decoration: InputDecoration(
                                        hintText: 'From Date',
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 12.h, horizontal: 10.0),
                                        prefixIcon:
                                            const Icon(Icons.calendar_month),
                                        filled: true,
                                        hintStyle: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 15.sp,
                                            fontWeight: FontWeight.normal),
                                        fillColor: AppTheme.greyColor,
                                        errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: BorderSide(
                                                color: AppTheme.greyColor)),
                                        focusedErrorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: BorderSide(
                                                color: AppTheme.greyColor)),
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide: BorderSide(
                                                color: AppTheme.greyColor)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(15.0),
                                            borderSide:
                                                BorderSide(color: AppTheme.greyColor))))),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: TextFormField(
                                onTap: () {
                                  _selectToDate(context);
                                },
                                readOnly: true,
                                controller: toDate,
                                style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  hintText: 'To Date',
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 12.h, horizontal: 10.0),
                                  prefixIcon: const Icon(Icons.calendar_month),
                                  filled: true,
                                  hintStyle: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.normal),
                                  fillColor: AppTheme.greyColor,
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                          color: AppTheme.greyColor)),
                                  focusedErrorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                          color: AppTheme.greyColor)),
                                  focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      borderSide: BorderSide(
                                          color: AppTheme.greyColor)),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                    borderSide: BorderSide(
                                      color: AppTheme.greyColor,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                Expanded(
                  child:
                      BlocBuilder<VisitorsListingCubit, VisitorsListingState>(
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
                            child: Text("Visitors Not Found!",
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
                                        child: CircularProgressIndicator()))
                                : const SizedBox.shrink();
                          }
                          return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: customVisitorsWidget(
                                  context,
                                  filterList[widget.index].toString(),
                                  visitorsList[index]));
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
