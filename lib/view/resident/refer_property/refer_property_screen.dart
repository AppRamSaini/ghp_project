import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/refer_property/create_refer_property/create_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/delete_refer_property/delete_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/get_refer_property/get_refer_property_cubit.dart';
import 'package:ghp_society_management/controller/refer_property/update_refer_property/update_refer_property_cubit.dart';
import 'package:ghp_society_management/model/refer_property_model.dart';
import 'package:ghp_society_management/view/resident/refer_property/register_refer_property_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';

class ReferPropertyScreen extends StatefulWidget {
  const ReferPropertyScreen({super.key});

  @override
  State<ReferPropertyScreen> createState() => _ReferPropertyScreenState();
}

class _ReferPropertyScreenState extends State<ReferPropertyScreen> {
  late GetReferPropertyCubit _getReferPropertyCubit;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    _getReferPropertyCubit = GetReferPropertyCubit()..fetchGetReferProperty();
    _scrollController.addListener(_onScroll);

    super.initState();
  }

  late BuildContext dialogueContext;

  Future onRefresh() async {
    _getReferPropertyCubit.fetchGetReferProperty();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 300) {
      _getReferPropertyCubit.loadMoreReferProperty();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<GetReferPropertyCubit, GetReferPropertyState>(
            listener: (context, state) {
          if (state is GetReferPropertyLogout) {
            sessionExpiredDialog(context);
          }
        }),
        BlocListener<CreateReferPropertyCubit, CreateReferPropertyState>(
            listener: (context, state) async {
          if (state is CreateReferPropertysuccessfully) {
            onRefresh();
          }
        }),
        BlocListener<UpdateReferPropertyCubit, UpdateReferPropertyState>(
            listener: (context, state) async {
          if (state is UpdateReferPropertySuccess) {
            onRefresh();
          }
        }),
        BlocListener<DeleteReferPropertyCubit, DeleteReferPropertyState>(
            listener: (context, state) async {
          if (state is DeleteReferPropertyLoading) {
            showLoadingDialog(context, (ctx) {
              dialogueContext = ctx;
            });
          } else if (state is DeleteReferPropertySuccess) {
            snackBar(context, state.successMsg.toString(), Icons.done,
                AppTheme.guestColor);
            onRefresh();
            Navigator.of(dialogueContext).pop();
          } else if (state is DeleteReferPropertyFailed) {
            snackBar(context, state.errorMsg.toString(), Icons.warning,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is DeleteReferPropertyInternetError) {
            snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                AppTheme.redColor);
            Navigator.of(dialogueContext).pop();
          } else if (state is DeleteReferPropertyLogout) {
            Navigator.of(dialogueContext).pop();
            sessionExpiredDialog(context);
          }
        })
      ],
      child: Scaffold(

        appBar: AppBar(title:    Text('Refer Property ',
            style: GoogleFonts.nunitoSans(
                textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600)))),
        floatingActionButton: FloatingActionButton(
            elevation: 0.0,
            backgroundColor: AppTheme.primaryColor,
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => RegisterReferPropertyScreen()));
            },
            child: const Icon(Icons.add, color: Colors.white)),


        body: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<GetReferPropertyCubit,
              GetReferPropertyState>(
            bloc: _getReferPropertyCubit,
            builder: (context, state) {
              if (state is GetReferPropertyLoading &&
                  _getReferPropertyCubit.referPropertyList.isEmpty) {
                return const Center(
                    child: CircularProgressIndicator.adaptive());
              }

              if (state is GetReferPropertyFailed) {
                return Center(
                    child: Text(state.errorMsg,
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent)));
              }

              if (state is GetReferPropertyInternetError) {
                return Center(
                    child: Text(state.errorMsg.toString(),
                        style: const TextStyle(color: Colors.red)));
              }

              var getPropertyList =
                  _getReferPropertyCubit.referPropertyList;

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: getPropertyList.length + 1,
                padding: const EdgeInsets.only(bottom: 120),
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  if (index == getPropertyList.length) {
                    return _getReferPropertyCubit.state
                            is GetReferPropertyLoadingMore
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                                child: CircularProgressIndicator
                                    .adaptive()))
                        : const SizedBox.shrink();
                  }

                  final referProperty = getPropertyList[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border:
                              Border.all(color: Colors.grey[300]!)),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Image.asset(
                                    ImageAssets.noticeBoardImage,
                                    height: 40.h),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          "Looking for ${referProperty!.unitType}",
                                          style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 14,
                                                  fontWeight:
                                                      FontWeight
                                                          .w600))),
                                      Row(
                                        mainAxisSize:
                                            MainAxisSize.min,
                                        children: [
                                          Text("Refer for ",
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .black,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight
                                                              .w400))),
                                          Text(
                                              referProperty.name
                                                  .toString(),
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent,
                                                      fontSize: 13,
                                                      fontWeight:
                                                          FontWeight
                                                              .w400))),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 10.w),
                                referPropertyMenuIcons(
                                    options: optionsList,
                                    context: context,
                                    requestData: referProperty)
                              ],
                            ),
                            Divider(
                                color: Colors.grey.withOpacity(0.2)),
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        "₹ ${referProperty.maxBudget.toString()}",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .w500))),
                                    Text("Max Budget",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .w600))),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        "₹ ${referProperty.minBudget.toString()}",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .w500))),
                                    Text("Min Budget",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .w600))),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                        referProperty.unitType
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .w400))),
                                    Text("Property Type",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight
                                                    .w600))),
                                  ],
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
            },
          ),
        ),
      ),
    );
  }
}

List<Map<String, dynamic>> optionsList = [
  {"icon": Icons.edit, "menu": "Update", "menu_id": 1},
  {"icon": Icons.delete, "menu": "Delete", "menu_id": 2},
  {"icon": Icons.visibility, "menu": "View Details", "menu_id": 3},
];
Widget referPropertyMenuIcons(
    {bool isStaffSide = false,
    required List<Map<String, dynamic>> options,
    required BuildContext context,
    required ReferPropertyList requestData}) {
  return CircleAvatar(
    radius: 18,
    backgroundColor: Colors.deepPurpleAccent.withOpacity(0.3),
    child: Padding(
      padding: const EdgeInsets.all(1),
      child: CircleAvatar(
        backgroundColor: Colors.white,
        child: PopupMenuButton(
          elevation: 10,
          padding: EdgeInsets.zero,
          color: Colors.white,
          surfaceTintColor: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          icon: const Icon(Icons.more_horiz_rounded,
              color: Colors.deepPurpleAccent, size: 18.0),
          offset: const Offset(0, 50),
          itemBuilder: (BuildContext bc) {
            return options
                .map(
                  (selectedOption) => PopupMenuItem(
                    padding: EdgeInsets.zero,
                    value: selectedOption,
                    child: Padding(
                      padding: EdgeInsets.only(left: 10.w, right: 30),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(selectedOption['icon']),
                              const SizedBox(width: 10),
                              Text(selectedOption['menu'] ?? "",
                                  style: GoogleFonts.poppins(
                                      color: Colors.black,
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400))
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                )
                .toList();
          },
          onSelected: (value) async {
            if (value['menu_id'] == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (builder) => RegisterReferPropertyScreen(
                      requestData: requestData, isRefer: true)));
            } else if (value['menu_id'] == 2) {
              context
                  .read<DeleteReferPropertyCubit>()
                  .deleteReferPropertyAPI(requestData.id.toString());
            } else if (value['menu_id'] == 3) {
              referPropertyDialog(context, requestData);
            }
          },
        ),
      ),
    ),
  );
}
