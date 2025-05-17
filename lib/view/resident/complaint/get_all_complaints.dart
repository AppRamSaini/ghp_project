import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/complants/cancel_complaints_cubit/cancel_complaints_cubit.dart';
import 'package:ghp_society_management/controller/complants/get_all_complaints/get_all_complaints_cubit.dart';
import 'package:ghp_society_management/controller/done_service/done_service_cubit.dart';
import 'package:ghp_society_management/controller/start_service/start_service_cubit.dart';
import 'package:ghp_society_management/model/complaints_model.dart';
import 'package:ghp_society_management/model/user_model.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:ghp_society_management/view/staff/home_screen.dart';
import 'package:intl/intl.dart';

class GetAllComplaintScreen extends StatefulWidget {
  const GetAllComplaintScreen({super.key});

  @override
  State<GetAllComplaintScreen> createState() => GetAllComplaintScreenState();
}

class GetAllComplaintScreenState extends State<GetAllComplaintScreen> {
  final ScrollController _scrollController = ScrollController();
  late GetAllComplaintsCubit _complaintsCubit;
  late StreamSubscription serviceSubscription;

  @override
  void initState() {
    super.initState();
    _complaintsCubit = GetAllComplaintsCubit()..fetchComplaintsAPI();
    serviceSubscription =
        context.read<DoneServiceCubit>().stream.listen((state) {
      if (state is DoneServiceSuccess) {
        onRefresh();
        snackBar(context, state.successMsg.toString(), Icons.done,
            AppTheme.guestColor);
      }
    });

    serviceSubscription =
        context.read<StartServiceCubit>().stream.listen((state) {
      if (state is StartServiceSuccess) {
        onRefresh();
        snackBar(context, state.successMsg.toString(), Icons.done,
            AppTheme.guestColor);
      }
    });
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    serviceSubscription.cancel();

    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent - 200) {
      _complaintsCubit.fetchComplaintsAPI(loadMore: true);
    }
  }

  int selectedIndex = 0;
  BuildContext? dialogueContext;

  Future<void> onRefresh() async {
    _complaintsCubit.fetchComplaintsAPI();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MultiBlocListener(
        listeners: [
          BlocListener<StartServiceCubit, StartServiceState>(
              listener: (context, state) {
            if (state is StartServiceSuccess) {
              onRefresh();
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
            }
          }),
          BlocListener<DoneServiceCubit, DoneServiceState>(
              listener: (context, state) {
            if (state is DoneServiceSuccess) {
              onRefresh();
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
            }
          }),
          BlocListener<CancelComplaintsCubit, CancelComplaintsState>(
            listener: (context, state) async {
              if (state is CancelComplaintsLoading) {
                showLoadingDialog(context, (ctx) {
                  dialogueContext = ctx;
                });
              } else if (state is CancelComplaintsSuccessfully) {
                snackBar(context, 'Complaints cancel successfully', Icons.done,
                    AppTheme.guestColor);
                _complaintsCubit.fetchComplaintsAPI();

                Navigator.of(dialogueContext!).pop();
              } else if (state is CancelComplaintsFailed) {
                snackBar(context, 'Failed to Complaints cancel ', Icons.warning,
                    AppTheme.redColor);
                Navigator.of(dialogueContext!).pop();
              } else if (state is CancelComplaintsInternetError) {
                snackBar(context, 'Internet connection failed', Icons.wifi_off,
                    AppTheme.redColor);

                Navigator.of(dialogueContext!).pop();
              } else if (state is CancelComplaintsLogout) {
                Navigator.of(dialogueContext!).pop();
                sessionExpiredDialog(context);
              }
            },
          )
        ],
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<GetAllComplaintsCubit, GetAllComplaintsState>(
            bloc: _complaintsCubit,
            builder: (_, state) {
              if (state is GetAllComplaintsLoading &&
                  _complaintsCubit.complaintsLIst.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (state is GetAllComplaintsFailed) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style:
                            const TextStyle(color: Colors.deepPurpleAccent)));
              }

              if (state is GetAllComplaintsEmpty) {
                return const Center(
                    child: Text("No incoming documents found",
                        style: TextStyle(color: Colors.deepPurpleAccent)));
              }
              if (state is GetAllComplaintsInternetError) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style: const TextStyle(color: Colors.red)));
              }
              var documentsList = _complaintsCubit.complaintsLIst;
              return ListView.builder(
                shrinkWrap: true,
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: documentsList.length + 1,
                itemBuilder: (context, index) {
                  if (index == documentsList.length) {
                    return _complaintsCubit.state
                            is IncomingDocumentsLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()))
                        : const SizedBox.shrink();
                  }
                  return Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10, top: 8),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          border:
                              Border.all(color: Colors.grey.withOpacity(0.2))),
                      child: extendedWidget(
                        context: context,
                        index: index,
                        lst: documentsList,
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  /// EXPONENTIAL TILE  WIDGETS
  Widget extendedWidget(
      {required BuildContext context,
      required int index,
      required List<ComplaintList> lst}) {
    UserModel? userList;
    date() {
      if (lst[index].assignedAt != null) {
        DateTime parsedDate = DateTime.parse(lst[index].assignedAt.toString());
        return DateFormat('dd MMMM yyyy, hh:mm a').format(parsedDate);
      }

      return 'N/A';
    }

    return Theme(
      data: ThemeData(
          hoverColor: Colors.transparent,
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent),
      child: ExpansionTile(
        key: Key(index.toString()),
        initiallyExpanded: selectedIndex == index,
        childrenPadding: EdgeInsets.zero,
        collapsedBackgroundColor: Colors.transparent,
        iconColor: Colors.black,
        collapsedIconColor: Colors.deepOrange,
        expandedAlignment: Alignment.centerLeft,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        onExpansionChanged: ((newState) {
          if (newState) {
            setState(() {
              const Duration(seconds: 20000);
              selectedIndex = index;
            });
          } else {
            setState(() {
              selectedIndex = -1;
            });
          }
        }),
        leading: Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Image.asset(ImageAssets.noticeBoardImage, height: 35.h)),
        trailing: lst[index].status == 'requested'
            ? GestureDetector(
                onTap: () {
                  deleteComplaintPermissionDialog(context, () {
                    context.read<CancelComplaintsCubit>().cancelComplaints(
                        complaintsId: lst[index].id.toString());
                    Navigator.pop(context);
                  });
                },
                child: Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(30)),
                    child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text('CANCEL',
                            style:
                                TextStyle(color: Colors.white, fontSize: 10)))))
            : Container(
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                    color: lst[index].status.toString() == 'done'
                        ? Colors.green.withOpacity(1)
                        : lst[index].status.toString() == "in_progress"
                            ? Colors.blue
                            : Colors.deepPurpleAccent.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(30)),
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text(
                        lst[index].status.toString() == 'done'
                            ? "Completed".toUpperCase()
                            : lst[index]
                                .status
                                .toString()
                                .replaceAll("_", " ")
                                .toUpperCase(),
                        style: TextStyle(
                            color: lst[index].status == 'done' ||
                                    lst[index].status == "in_progress"
                                ? Colors.white
                                : Colors.black,
                            fontSize: 10)))),
        tilePadding: EdgeInsets.zero,
        subtitle: Text(date().toString(),style: TextStyle(fontSize: 12),),
        title: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(lst[index].area.toString(),
                style: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500))),
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4)),
                border: Border.all(color: Colors.blueGrey.withOpacity(0.1))),
            child: Column(
              children: [
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('OTP : ${lst[index].otp.toString()}',
                          style: const TextStyle(
                              color: Colors.deepPurpleAccent,
                              fontSize: 18,
                              fontWeight: FontWeight.w500)),
                      lst[index].status == 'in_progress' ||
                              lst[index].status == 'assigned' ||
                              lst[index].status == 'done'
                          ? actionButton(
                              onTap: () async {
                                await phoneCallLauncher(
                                    lst[index].assignedTo!.phone.toString());
                              },
                              icon: Icons.phone,
                              text: "Call",
                              color: Colors.deepPurpleAccent)
                          : const SizedBox.shrink()
                    ],
                  ),
                ),
                Divider(color: Colors.grey.withOpacity(0.2)),
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                          child: ListTile(
                              dense: true,
                              title: const Text('Assignee',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              subtitle: Text(
                                  lst[index].assignedTo == null
                                      ? "N/A"
                                      : lst[index].assignedTo!.name.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)))),
                      Expanded(
                          child: ListTile(
                              dense: true,
                              title: const Text('Contact ',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              subtitle: Text(
                                  '+91 ${lst[index].assignedTo == null ? '**********' : lst[index].assignedTo!.phone.toString()}',
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))))
                    ],
                  ),
                ),
                const SizedBox(height: 5),
                Row(children: [
                  Expanded(
                      child: SizedBox(
                          height: 50,
                          child: ListTile(
                              dense: true,
                              title: const Text('Assigned Date',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              subtitle: Text(date(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500))))),
                  Expanded(
                      child: SizedBox(
                          height: 50,
                          child: ListTile(
                              dense: true,
                              title: const Text('Area',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 14)),
                              subtitle: Text(lst[index].area.toString(),
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)))))
                ]),
                const SizedBox(height: 15),
                ListTile(
                  dense: true,
                  title: const Text('Description',
                      style: TextStyle(color: Colors.grey, fontSize: 14)),
                  subtitle: Text(
                    lst[index].description == 'null'
                        ? ''
                        : lst[index].description.toString(),
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
                  ),
                ),
                /*lst[index].status == 'in_progress' ||
                        lst[index].status == 'assigned' ||
                        lst[index].status == 'done'
                    ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                              child: actionButton(
                                  onTap: () {
                                    var uuid = const Uuid();
                                    String groupId = uuid.v6();
                                    userList = UserModel(
                                        userImage:
                                            lst[index].assignedTo!.image ?? '',
                                        uid: lst[index]
                                            .assignedTo!
                                            .id
                                            .toString(),
                                        userName: lst[index]
                                            .assignedTo!
                                            .name
                                            .toString(),
                                        serviceCategory: 'Plumber');
                                    context.read<GroupCubit>().createGroup(
                                          userList!,
                                          groupId,
                                          context,
                                          lst[index]
                                              .complaintBy!
                                              .member!
                                              .id
                                              .toString(),
                                          lst[index]
                                              .complaintBy!
                                              .member!
                                              .name
                                              .toString(),
                                          lst[index]
                                              .complaintBy!
                                              .image
                                              .toString()
                                              .toString(),
                                          'Plumber',
                                        );

                                    print(
                                        'user--------->>>>>>${userList!.uid.toString()} ${userList!.userName.toString()}');
                                    print(
                                        'use------>>>>>>${lst[index].complaintBy!.member!.userId} ${lst[index].complaintBy!.member!.name}');
                                  },
                                  icon: Icons.chat,
                                  text: "Chat",
                                  color: Colors.teal)),
                          Expanded(
                            child: actionButton(
                                onTap: () async {
                                  await phoneCallLauncher(
                                      lst[index].assignedTo!.phone.toString());
                                },
                                icon: Icons.phone,
                                text: "Call",
                                color: Colors.deepPurpleAccent),
                          )
                        ],
                      )
                    : const SizedBox.shrink()*/
              ],
            ),
          ),
        ],
      ),
    );
  }
}
