import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:intl/intl.dart';

class NoticeBoardScreen extends StatefulWidget {
  bool isResidentSide;
  NoticeBoardScreen({super.key, required, this.isResidentSide = false});

  @override
  State<NoticeBoardScreen> createState() => _NoticeBoardScreenState();
}

class _NoticeBoardScreenState extends State<NoticeBoardScreen> {
  late NoticeModelCubit _noticeModelCubit;
  bool searchBarOpen = false;
  TextEditingController textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _noticeModelCubit = NoticeModelCubit()..fetchNotices();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent < 300) {
      _noticeModelCubit.loadMoreNotice();
    }
  }

  Future onRefresh() async {
    _noticeModelCubit = NoticeModelCubit()..fetchNotices();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<IncomingRequestCubit, IncomingRequestState>(
      listener: (context, state) {
        if (state is IncomingRequestLoaded) {
          print("IncomingRequestLoaded state triggered");
          IncomingVisitorsModel incomingVisitorsRequest =
              state.incomingVisitorsRequest;
          if (incomingVisitorsRequest.lastCheckinDetail!.status ==
              'requested') {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VisitorsIncomingRequestPage(
                  incomingVisitorsRequest: incomingVisitorsRequest,
                  setPageValue: (value) {},
                ),
              ),
            );
          }
        }
      },
      child: BlocListener<NoticeModelCubit, NoticeModelState>(
        listener: (context, state) {
          if (state is NoticeModelLogout) {
            sessionExpiredDialog(context);
          }
        },
        child: Scaffold(
          appBar: customAppbar(
              context: context,
              title: 'Notice Board',
              textController: textController,
              searchBarOpen: searchBarOpen,
              onExpansionComplete: () {
                setState(() {
                  searchBarOpen = true;
                });
              },
              onCollapseComplete: () {
                setState(() {
                  searchBarOpen = false;
                  textController.clear();
                  _noticeModelCubit.searchNotice('');
                });
              },
              onPressButton: (isSearchBarOpens) {
                setState(() {
                  searchBarOpen = true;
                });
              },
              onChanged: (value) {
                _noticeModelCubit.searchNotice(value);
              }),
          body: RefreshIndicator(
            onRefresh: onRefresh,
            child: BlocBuilder<NoticeModelCubit, NoticeModelState>(
              bloc: _noticeModelCubit,
              builder: (context, state) {
                if (state is NoticeModelLoading &&
                    _noticeModelCubit.noticeList.isEmpty) {
                  return notificationShimmerLoading();
                }

                if (state is NoticeModelFailed) {
                  return Center(
                      child: Text(state.errorMsg,
                          style:
                              const TextStyle(color: Colors.deepPurpleAccent)));
                }
                if (state is NoticeModelInternetError) {
                  return Center(
                      child: Text(state.errorMsg.toString(),
                          style: const TextStyle(color: Colors.red)));
                }

                var noticeList = _noticeModelCubit.noticeList;

                if (state is NoticeModelSearchedLoaded) {
                  noticeList = state.noticeModel;
                }

                if (noticeList.isEmpty) {
                  return emptyDataWidget('Notice Not Found!');
                }

                return ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: noticeList.length + 1,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    if (index == noticeList.length) {
                      return _noticeModelCubit.state is NoticeModelLoadMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                  child: CircularProgressIndicator.adaptive()))
                          : const SizedBox.shrink();
                    }

                    String formattedDate = DateFormat('dd MMM yyyy')
                        .format(noticeList[index].date);
                    String timeString = noticeList[index].time;
                    DateTime parsedTime =
                        DateFormat("HH:mm:ss").parse(timeString);
                    String formattedTime = DateFormat.jm().format(parsedTime);

                    Widget layoutChild() => Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Image.asset(ImageAssets.noticeBoardImage,
                                        height: 40.h),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                          Text(noticeList[index].title,
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500))),
                                          Text("$formattedDate $formattedTime",
                                              style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400)))
                                        ])),
                                    SizedBox(width: 10.w),
                                    Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: AppTheme.greyColor),
                                      child: const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          Icons.navigate_next,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(thickness: 0.3),
                                Text(
                                  noticeList[index].description,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 2,
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );

                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 3),
                      child: GestureDetector(
                        onTap: () {
                          showAlertDialog(
                            context,
                            noticeList[index].title,
                            "$formattedDate $formattedTime",
                            noticeList[index].description,
                          );
                        },
                        child: getStatus(noticeList[index].createdAt) ==
                                'newNoticed'
                            ? Banner(
                                message:
                                    getStatus(noticeList[index].createdAt) ==
                                            'newNoticed'
                                        ? "New Notice"
                                        : '',
                                location: BannerLocation.topStart,
                                child: layoutChild())
                            : layoutChild(),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  String getStatus(apiDate) {
    String apiDateString = "$apiDate"; // API से मिली डेट
    DateTime apiDateTime = DateTime.parse(apiDateString);
    DateTime currentDate = DateTime.now();

    if (apiDateTime.year == currentDate.year &&
        apiDateTime.month == currentDate.month &&
        apiDateTime.day == currentDate.day) {
      return "newNoticed";
    } else {
      return "oldNoticed";
    }
  }

  /// dialog
  showAlertDialog(BuildContext context, title, time, description) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.all(30),
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            insetPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Image.asset(ImageAssets.noticeBoardImage, height: 40.h),
                      SizedBox(width: 10.w),
                      Expanded(
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            Text(title,
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600))),
                            Text(time,
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400)))
                          ])),
                      SizedBox(width: 10.w),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(1000.r),
                              color: AppTheme.greyColor),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.close,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.3),
                  Text(description,
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w400,
                        ),
                      )),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
