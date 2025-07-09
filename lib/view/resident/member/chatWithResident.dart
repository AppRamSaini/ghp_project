import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/controller/members/members_cubit.dart';
import 'package:ghp_society_management/controller/members_element/members_element_cubit.dart';
import 'package:ghp_society_management/model/members_element_model.dart';
import 'package:ghp_society_management/model/members_model.dart';
import 'package:ghp_society_management/model/user_model.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class ChatMemberScreen extends StatefulWidget {
  const ChatMemberScreen({super.key});

  @override
  State<ChatMemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<ChatMemberScreen> {
  late MembersCubit _membersCubit;
  late MembersElementCubit _membersElementCubit;
  int? lastRoomId;
  String? blockName;
  String? floorId;

  TextEditingController textController = TextEditingController();
  bool searchBarOpen = false;

  List types = ["resident", "admin", "guard"];
  int selectedIndex = 0;
  @override
  void initState() {
    _membersCubit = MembersCubit();
    _membersElementCubit = MembersElementCubit()..fetchMembersElement();
    super.initState();
  }

  fetchData(String blockName) {
    _membersCubit.fetchMembers(blockName, '', types[selectedIndex]);
  }

  Future<void> onRefresh() async {
    _membersCubit.fetchMembers('', '', types[selectedIndex]);
    setState(() {});
  }

  List<Block> memberBlocsList = [];
  UserModel? userList;

  late BuildContext dialogContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              searchBarOpen
                  ? const SizedBox()
                  : Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, left: 6.h, bottom: 10.h),
                      child: Row(
                        children: [
                          GestureDetector(
                              onTap: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back,
                                  color: Colors.white)),
                          SizedBox(width: 10.w),
                          Text('Members',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.sp,
                                      fontWeight: FontWeight.w600)))
                        ],
                      ),
                    ),
              Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: SearchBarAnimation(
                      searchBoxColour: AppTheme.primaryLiteColor,
                      buttonColour: AppTheme.primaryLiteColor,
                      searchBoxWidth: MediaQuery.of(context).size.width / 1.1,
                      isSearchBoxOnRightSide: false,
                      textEditingController: textController,
                      isOriginalAnimation: true,
                      enableKeyboardFocus: true,
                      cursorColour: Colors.grey,
                      enteredTextStyle: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600)),
                      onExpansionComplete: () {
                        setState(() {
                          searchBarOpen = true;
                        });
                      },
                      onCollapseComplete: () {
                        setState(() {
                          searchBarOpen = false;
                          textController.clear();
                        });

                        /// Fetch original members list when search is cleared
                        _membersCubit.fetchMembers(blockName.toString(),
                            floorId.toString(), types[selectedIndex]);
                      },
                      onPressButton: (isSearchBarOpens) {
                        setState(() {
                          searchBarOpen = true;
                        });
                      },
                      onChanged: (value) {
                        // if (value.isEmpty) {
                        //   _membersCubit
                        //     .searchMembers(
                        //         blockName.toString(),
                        //         floorId.toString(),
                        //         textController.text.toString());
                        // } else {
                        //   _membersCubit = MembersCubit()
                        //     ..fetchMembers(
                        //         blockName.toString(),
                        //         floorId.toString(),
                        //         textController.text.toString());
                        // }
                        _membersCubit
                            .searchMembers(textController.text.toString());
                      },
                      trailingWidget: const Icon(Icons.search,
                          size: 20, color: Colors.white),
                      secondaryButtonWidget: const Icon(Icons.close,
                          size: 20, color: Colors.white),
                      buttonWidget: const Icon(Icons.search,
                          size: 20, color: Colors.white)))
            ]),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: RefreshIndicator(
                  onRefresh: onRefresh,
                  child: BlocBuilder<MembersElementCubit, MembersElementState>(
                      bloc: _membersElementCubit,
                      builder: (context, state) {
                        if (state is MembersElementLoading) {
                          return const Center(
                              child: CircularProgressIndicator.adaptive());
                        }
                        if (state is MembersElementLoaded) {
                          memberBlocsList =
                              state.membersElements.first!.data!.blocks!;
                          final blocksList = state.membersElements.isNotEmpty
                              ? state.membersElements.first!.data!.blocks
                              : [];

                          if (blockName == null && blocksList!.isNotEmpty) {
                            blockName = blocksList.first.name;
                            fetchData(blockName.toString());
                          }

                          if (blockName != null) {
                            final floor = floorId ?? '';
                            _membersCubit.fetchMembers(blockName.toString(),
                                floor, types[selectedIndex]);
                          }
                        }

                        return BlocBuilder<MembersCubit, MembersState>(
                          bloc: _membersCubit,
                          builder: (context, state) {
                            if (state is MembersLoading) {
                              return const Center(
                                  child: CircularProgressIndicator.adaptive());
                            }
                            if (state is MembersFailed) {
                              return Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Column(children: [
                                    SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height /
                                                3),
                                    Center(
                                        child: Text(
                                            state.errorMessage.toString(),
                                            style: const TextStyle(
                                                color:
                                                    Colors.deepPurpleAccent)))
                                  ]));
                            }
                            if (state is MembersInternetError) {
                              return Column(children: [
                                SizedBox(
                                    height:
                                        MediaQuery.of(context).size.height / 3),
                                const Center(
                                    child: Text('Internet connection failed',
                                        style: TextStyle(color: Colors.red)))
                              ]);
                            }
                            SocietyData societyData =
                                _membersCubit.memberList.data!;

                            if (state is MembersSearchedLoaded) {
                              societyData = state.propertyMember;
                            }

                            return Column(
                              children: [
                                const SizedBox(height: 5),
                                Row(children: [
                                  Expanded(
                                      child: DropdownButton2<String>(
                                          underline: Container(
                                              color: Colors.transparent),
                                          isExpanded: true,
                                          value: blockName,
                                          hint: Text('Select Tower',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15.sp))),
                                          items: memberBlocsList
                                              .map((item) => DropdownMenuItem<String>(
                                                  value: item.name,
                                                  child: Text(
                                                      item.name.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.black))))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              blockName = value;
                                              floorId = null;
                                              _membersCubit = MembersCubit()
                                                ..fetchMembers(
                                                    blockName != null
                                                        ? value.toString()
                                                        : "",
                                                    "",
                                                    textController.text
                                                        .toString());
                                            });
                                          },
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(Icons.arrow_drop_down,
                                                  color: Colors.black45),
                                              iconSize: 24),
                                          buttonStyleData: ButtonStyleData(
                                              decoration: BoxDecoration(color: AppTheme.greyColor, borderRadius: BorderRadius.circular(10))),
                                          dropdownStyleData: DropdownStyleData(maxHeight: MediaQuery.sizeOf(context).height / 2, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
                                          menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)))),
                                  SizedBox(width: 10.w),
                                  Expanded(
                                      child: DropdownButton2<String>(
                                          underline: Container(
                                              color: Colors.transparent),
                                          isExpanded: true,
                                          value: floorId,
                                          hint: Text('Select Floor',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 15.sp))),
                                          items: memberBlocsList
                                              .firstWhere((block) => block.name == blockName,
                                                  orElse: () =>
                                                      memberBlocsList.first)
                                              .floors!
                                              .map((floor) => DropdownMenuItem<String>(
                                                  value: floor.name.toString(),
                                                  child: Text(
                                                      floor.name.toString(),
                                                      style: const TextStyle(
                                                          fontSize: 14,
                                                          color:
                                                              Colors.black))))
                                              .toList(),
                                          onChanged: (value) {
                                            setState(() {
                                              floorId = value;
                                              _membersCubit.fetchMembers(
                                                  blockName != null
                                                      ? blockName.toString()
                                                      : "",
                                                  floorId != null
                                                      ? floorId.toString()
                                                      : "",
                                                  textController.text
                                                      .toString());
                                            });
                                          },
                                          iconStyleData: const IconStyleData(
                                              icon: Icon(Icons.arrow_drop_down,
                                                  color: Colors.black45),
                                              iconSize: 24),
                                          buttonStyleData: ButtonStyleData(decoration: BoxDecoration(color: AppTheme.greyColor, borderRadius: BorderRadius.circular(10))),
                                          dropdownStyleData: DropdownStyleData(maxHeight: MediaQuery.sizeOf(context).height / 2, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
                                          menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16))))
                                ]),
                                SizedBox(height: 10.h),
                                Expanded(
                                  child: societyData.properties == null ||
                                          societyData.properties!.isEmpty
                                      ? Center(
                                          child: Text("Member not found!",
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: const TextStyle(
                                                      color: Colors
                                                          .deepPurpleAccent))))
                                      : ListView.builder(
                                          physics:
                                              const BouncingScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount:
                                              societyData.properties!.length,
                                          itemBuilder: (context, index) {
                                            List<PropertyNumber> memberList =
                                                societyData.properties![index]
                                                        .propertyNumbers ??
                                                    [];

                                            return Column(
                                              children: [
                                                Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            12.0),
                                                    child:
                                                        Row(children: <Widget>[
                                                      const Expanded(
                                                          child: Divider()),
                                                      SizedBox(width: 10.w),
                                                      Text(
                                                          "FLOOR ${societyData.properties![index].floor.toString()}",
                                                          style: GoogleFonts.nunitoSans(
                                                              textStyle: TextStyle(
                                                                  color: AppTheme
                                                                      .primaryColor,
                                                                  fontSize:
                                                                      13.sp,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600))),
                                                      SizedBox(width: 10.w),
                                                      const Expanded(
                                                          child: Divider())
                                                    ])),
                                                GridView.builder(
                                                  itemCount: memberList.length,
                                                  shrinkWrap: true,
                                                  physics:
                                                      const NeverScrollableScrollPhysics(),
                                                  gridDelegate:
                                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                                          mainAxisSpacing: 10,
                                                          crossAxisCount: 3),
                                                  itemBuilder:
                                                      (context, _index) {
                                                    if (memberList[_index]
                                                            .memberInfo !=
                                                        null) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          memberDetailsDialog(
                                                              context,
                                                              memberList[
                                                                  _index]);
                                                        },
                                                        child: Container(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                                  horizontal:
                                                                      3),
                                                          decoration: BoxDecoration(
                                                              color: AppTheme
                                                                  .handoverColor,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          4)),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            2.0),
                                                                child: Text(
                                                                  "${memberList[_index].propertyNumber!}      F - ${memberList[_index].floor}",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      GoogleFonts
                                                                          .ptSans(
                                                                    textStyle:
                                                                        TextStyle(
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          16.sp,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                              Expanded(
                                                                child: Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                          .all(
                                                                          4.0),
                                                                  child:
                                                                      Container(
                                                                    decoration: BoxDecoration(
                                                                        color: Colors
                                                                            .white,
                                                                        borderRadius:
                                                                            BorderRadius.circular(4)),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        memberList[_index]
                                                                            .memberInfo!
                                                                            .name
                                                                            .toString(),
                                                                        textAlign:
                                                                            TextAlign.center,
                                                                        style: GoogleFonts
                                                                            .ptSans(
                                                                          textStyle:
                                                                              TextStyle(
                                                                            color:
                                                                                Colors.black,
                                                                            fontSize:
                                                                                15.sp,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    } else {
                                                      return Container(
                                                        margin: const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 3),
                                                        decoration: BoxDecoration(
                                                            color: AppTheme
                                                                .remainingColor,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        4)),
                                                        child: Column(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            2.0),
                                                                child: Text(
                                                                    "${memberList[_index].propertyNumber.toString()}    F - ${memberList[_index].floor.toString()}",
                                                                    textAlign:
                                                                        TextAlign
                                                                            .center,
                                                                    style: GoogleFonts.nunitoSans(
                                                                        textStyle: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 16.sp,
                                                                            fontWeight: FontWeight.w600)))),
                                                            Expanded(
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .all(
                                                                        4.0),
                                                                child:
                                                                    Container(
                                                                  decoration: BoxDecoration(
                                                                      color: Colors
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              4)),
                                                                  child:
                                                                      const Center(
                                                                    child: Icon(
                                                                        Icons
                                                                            .hourglass_empty_outlined), // Placeholder icon for vacant
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      );
                                                    }
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        ),
                                ),
                                SizedBox(height: 30.h)
                              ],
                            );
                          },
                        );
                      }),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

/*






showLoadingDialog(context, (ctx) {
dialogContext = ctx;
});

var uuid = const Uuid();
String groupId = uuid.v6();

userList = UserModel(
userImage: staffList[index].image,
uid: staffList[index].userId.toString(),
userName: staffList[index].name,
serviceCategory: staffList[index]
    .staffCategory!
    .name
    .isNotEmpty
? staffList[index].staffCategory!.name
    : staffList[index].role.toString());


context.read<GroupCubit>().createGroup(
userList!,
groupId,
context,
widget.userId,
widget.userName,
widget.userImage,
staffList[index]
    .staffCategory!
    .name
    .isNotEmpty
? staffList[index].staffCategory!.name
    : staffList[index].role.toString());*/
