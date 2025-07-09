import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/members/members_cubit.dart';
import 'package:ghp_society_management/controller/members_element/members_element_cubit.dart';
import 'package:ghp_society_management/model/members_element_model.dart';
import 'package:ghp_society_management/model/members_model.dart';
import 'package:ghp_society_management/model/user_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});
  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  late MembersCubit _membersCubit;
  late MembersElementCubit _membersElementCubit;
  int? lastRoomId;
  String? blockName;
  String? floorId;
  String? type;

  TextEditingController textController = TextEditingController();
  bool searchBarOpen = false;
  List types = [
    {"type": "Member", "value": "resident"},
    {"type": "Admin", "value": "admin"},
    {"type": "Staff", "value": "guard"},
  ];

  int selectedIndex = 0;

  String? _userId;
  @override
  void initState() {
    _membersCubit = MembersCubit();
    _membersElementCubit = MembersElementCubit();
    _membersElementCubit.fetchMembersElement();
    setValue();
    super.initState();
  }

  setValue() {
    type = types[0]['value'].toString();

    var userId = LocalStorage.localStorage.getString('user_id');

    _userId = userId;

    setState(() {});
  }

  fetchData(String blockName) {
    _membersCubit.fetchMembers(
        blockName, '', types[selectedIndex]['value'].toString());
  }

  Future<void> onRefresh() async {
    type = types[0]['value'].toString();
    _membersCubit.fetchMembers(
        blockName.toString(), "", types[0]['value'].toString());
  }

  List<Block> memberBlocsList = [];
  UserModel? userList;

  late BuildContext dialogContext;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
          context: context,
          title: 'Members',
          searchBarOpen: searchBarOpen,
          textController: textController,
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
            _membersCubit.fetchMembers(
                blockName.toString(), floorId.toString(), '');
          },
          onPressButton: (isSearchBarOpens) {
            onRefresh();
            setState(() {
              searchBarOpen = true;
            });
          },
          onChanged: (value) {
            _membersCubit.searchMembers(textController.text.toString());
          }),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: BlocBuilder<MembersElementCubit, MembersElementState>(
                bloc: _membersElementCubit,
                builder: (context, state) {
                  if (state is MembersElementLoading) {
                    return const Center(
                        child: CircularProgressIndicator.adaptive());
                  }

                  if (state is MembersElementInternetError) {
                    return const Center(
                        child: Text('Internet connection failed',
                            style: TextStyle(color: Colors.red)));
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
                      _membersCubit.fetchMembers(blockName.toString(), floor,
                          types[selectedIndex]['value'].toString());
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
                                      MediaQuery.of(context).size.height / 3),
                              Center(
                                  child: Text(state.errorMessage.toString(),
                                      style: const TextStyle(
                                          color: Colors.deepPurpleAccent)))
                            ]));
                      }
                      if (state is MembersInternetError) {
                        return Column(children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height / 3),
                          const Center(
                              child: Text('Internet connection failed',
                                  style: TextStyle(color: Colors.red)))
                        ]);
                      }
                      SocietyData societyData = _membersCubit.memberList.data!;

                      if (state is MembersSearchedLoaded) {
                        societyData = state.propertyMember;
                      }

                      return Column(
                        children: [
                          const SizedBox(height: 5),
                          Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                  color: AppTheme.greyColor,
                                  borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10))),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      children: [
                                        Text('TOTAL UNIT: ',
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color:
                                                        AppTheme.primaryColor,
                                                    fontSize: 12.sp,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        Text(societyData.totalUnits.toString(),
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w600)))
                                      ],
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                  color:
                                                      AppTheme.remainingColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000))),
                                          SizedBox(width: 5.w),
                                          Text('VACANT: ',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: AppTheme
                                                          .darkgreyColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Text(societyData.vacant.toString(),
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600)))
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      child: Row(
                                        children: [
                                          Container(
                                              height: 10,
                                              width: 10,
                                              decoration: BoxDecoration(
                                                  color: AppTheme.handoverColor,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          1000))),
                                          SizedBox(width: 2.w),
                                          Text(' OCCUPIED: ',
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: AppTheme
                                                          .darkgreyColor,
                                                      fontSize: 12.sp,
                                                      fontWeight:
                                                          FontWeight.w600))),
                                          Text(societyData.occupied.toString(),
                                              style: GoogleFonts.nunitoSans(
                                                  textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 14.sp,
                                                      fontWeight:
                                                          FontWeight.w600)))
                                        ],
                                      ),
                                    )
                                  ])),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: DropdownButton2<String>(
                                    underline:
                                        Container(color: Colors.transparent),
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
                                            child: Text(item.name.toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black))))
                                        .toList(),
                                    onChanged: (value) {
                                      blockName = value;
                                      type = types[0]['value'].toString();
                                      _membersCubit.fetchMembers(
                                          blockName != null
                                              ? value.toString()
                                              : "",
                                          "",
                                          types[0]['value'].toString());
                                    },
                                    iconStyleData: const IconStyleData(
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black45),
                                        iconSize: 24),
                                    buttonStyleData: ButtonStyleData(
                                        decoration: BoxDecoration(
                                            color: AppTheme.greyColor,
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    dropdownStyleData: DropdownStyleData(
                                        maxHeight: MediaQuery.sizeOf(context).height / 2,
                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
                                    menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16)))),
                            SizedBox(width: 10.w),
                            Expanded(
                                child: DropdownButton2<String>(
                                    underline:
                                        Container(color: Colors.transparent),
                                    isExpanded: true,
                                    value: type,
                                    hint: Text('Select Types',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 15.sp))),
                                    items: types
                                        .map((value) => DropdownMenuItem<String>(
                                            value: value['value'],
                                            child: Text(
                                                value['type'].toString(),
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black))))
                                        .toList(),
                                    onChanged: (value) {
                                      type = value;
                                      _membersCubit.fetchMembers(
                                          blockName != null
                                              ? blockName.toString()
                                              : "",
                                          "",
                                          type.toString());
                                    },
                                    iconStyleData: const IconStyleData(
                                        icon: Icon(Icons.arrow_drop_down,
                                            color: Colors.black45),
                                        iconSize: 24),
                                    buttonStyleData: ButtonStyleData(
                                        decoration: BoxDecoration(
                                            color: AppTheme.greyColor,
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                    dropdownStyleData:
                                        DropdownStyleData(maxHeight: MediaQuery.sizeOf(context).height / 2, decoration: BoxDecoration(borderRadius: BorderRadius.circular(10))),
                                    menuItemStyleData: const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 16))))
                          ]),
                          SizedBox(height: 10.h),
                          type == 'admin'
                              ? ListView.builder(
                                  itemCount: societyData.admin!.length,
                                  shrinkWrap: true,
                                  physics:
                                      const AlwaysScrollableScrollPhysics(),
                                  itemBuilder: (context, _index) {
                                    Admin data = societyData.admin![_index];
                                    return Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 5),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                          borderRadius:
                                              BorderRadius.circular(6)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ListTile(
                                            contentPadding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 5),
                                            leading: const CircleAvatar(
                                                backgroundImage: AssetImage(
                                                    "assets/images/default.jpg")),
                                            title: Text(data.name.toString()),
                                            subtitle: Text(
                                                "+91 ${data.phone.toString()}"),
                                            trailing: _userId ==
                                                    data.member!.userId
                                                        .toString()
                                                ? const SizedBox()
                                                : Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      const CircleAvatar(
                                                        radius: 17,
                                                        backgroundColor:
                                                            Colors.blue,
                                                        child: Icon(
                                                          Icons.chat,
                                                          color: Colors.white,
                                                          size: 16,
                                                        ),
                                                      ),
                                                      const SizedBox(width: 10),
                                                      GestureDetector(
                                                        onTap: () =>
                                                            phoneCallLauncher(
                                                                data.phone
                                                                    .toString()),
                                                        child:
                                                            const CircleAvatar(
                                                          radius: 17,
                                                          backgroundColor:
                                                              Colors.blue,
                                                          child: Icon(
                                                            Icons.call,
                                                            color: Colors.white,
                                                            size: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                          Divider(
                                              height: 0,
                                              color:
                                                  Colors.grey.withOpacity(0.2)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 10, vertical: 10),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Row(
                                                  children: [
                                                    const Text("Floor No : ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    Text(data
                                                        .member!.floorNumber
                                                        .toString()),
                                                  ],
                                                ),
                                                Row(
                                                  children: [
                                                    const Text("Property No : ",
                                                        style: TextStyle(
                                                            color:
                                                                Colors.grey)),
                                                    Text(data.member!.aprtNo
                                                        .toString()),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                )
                              : type == 'guard'
                                  ? ListView.builder(
                                      itemCount: societyData.guards!.length,
                                      shrinkWrap: true,
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      itemBuilder: (context, _index) {
                                        Admin data =
                                            societyData.guards![_index];

                                        return GestureDetector(
                                          onTap: () {
                                            // memberDetailsDialog(
                                            //     context,
                                            //     memberList[
                                            //     _index]);
                                          },
                                          child: Container(
                                            margin: const EdgeInsets.symmetric(
                                                horizontal: 3, vertical: 5),
                                            decoration: BoxDecoration(
                                                // color: AppTheme
                                                //     .handoverColor,
                                                border: Border.all(
                                                    color: Colors.grey
                                                        .withOpacity(0.2)),
                                                borderRadius:
                                                    BorderRadius.circular(6)),
                                            child: ListTile(
                                              contentPadding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 5),
                                              leading: const CircleAvatar(
                                                  backgroundImage: AssetImage(
                                                      "assets/images/default.jpg")),
                                              title: Text(data.name.toString()),
                                              subtitle: Text(
                                                  "+91 ${data.phone.toString()}"),
                                              trailing: _userId ==
                                                      data.staff!.userId
                                                          .toString()
                                                  ? const SizedBox()
                                                  : Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        const CircleAvatar(
                                                          radius: 17,
                                                          backgroundColor:
                                                              Colors.blue,
                                                          child: Icon(
                                                            Icons.chat,
                                                            color: Colors.white,
                                                            size: 16,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                            width: 10),
                                                        GestureDetector(
                                                          onTap: () =>
                                                              phoneCallLauncher(
                                                                  data.phone
                                                                      .toString()),
                                                          child:
                                                              const CircleAvatar(
                                                            radius: 17,
                                                            backgroundColor:
                                                                Colors.blue,
                                                            child: Icon(
                                                              Icons.call,
                                                              color:
                                                                  Colors.white,
                                                              size: 16,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                  : Expanded(
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
                                                  const AlwaysScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: societyData
                                                  .properties!.length,
                                              itemBuilder: (context, index) {
                                                List<PropertyNumber>
                                                    memberList = societyData
                                                            .properties![index]
                                                            .propertyNumbers ??
                                                        [];

                                                return Column(
                                                  children: [
                                                    Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Row(
                                                            children: <Widget>[
                                                              const Expanded(
                                                                  child:
                                                                      Divider()),
                                                              SizedBox(
                                                                  width: 10.w),
                                                              Text(
                                                                  "FLOOR ${societyData.properties![index].floor.toString()}",
                                                                  style: GoogleFonts.nunitoSans(
                                                                      textStyle: TextStyle(
                                                                          color: AppTheme
                                                                              .primaryColor,
                                                                          fontSize: 13
                                                                              .sp,
                                                                          fontWeight:
                                                                              FontWeight.w600))),
                                                              SizedBox(
                                                                  width: 10.w),
                                                              const Expanded(
                                                                  child:
                                                                      Divider())
                                                            ])),
                                                    ListView.builder(
                                                      itemCount:
                                                          memberList.length,
                                                      shrinkWrap: true,

                                                      physics:
                                                          const BouncingScrollPhysics(),

                                                      // gridDelegate:
                                                      //     const SliverGridDelegateWithFixedCrossAxisCount(
                                                      //         mainAxisSpacing: 10,
                                                      //         crossAxisCount: 3),
                                                      itemBuilder:
                                                          (context, _index) {
                                                        if (memberList[_index]
                                                                .memberInfo !=
                                                            null) {
                                                          return GestureDetector(
                                                            onTap: () {
                                                              // memberDetailsDialog(
                                                              //     context,
                                                              //     memberList[
                                                              //         _index]);
                                                            },
                                                            child: Container(
                                                              margin:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                      horizontal:
                                                                          3,
                                                                      vertical:
                                                                          5),
                                                              decoration: BoxDecoration(
                                                                  color: Colors
                                                                      .green
                                                                      .withOpacity(
                                                                          0.1),
                                                                  border: Border.all(
                                                                      color: Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.5)),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              6)),
                                                              child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  ListTile(
                                                                    contentPadding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            5),
                                                                    leading: const CircleAvatar(
                                                                        backgroundImage:
                                                                            AssetImage("assets/images/default.jpg")),
                                                                    title: Text(memberList[
                                                                            _index]
                                                                        .memberInfo!
                                                                        .name
                                                                        .toString()),
                                                                    subtitle: Text(
                                                                        "+91 ${memberList[_index].memberInfo!.phone.toString()}"),
                                                                    trailing: _userId ==
                                                                            memberList[_index].memberInfo!.userId.toString()
                                                                        ? const SizedBox()
                                                                        : Row(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            children: [
                                                                              const CircleAvatar(
                                                                                radius: 17,
                                                                                backgroundColor: Colors.blue,
                                                                                child: Icon(
                                                                                  Icons.chat,
                                                                                  color: Colors.white,
                                                                                  size: 16,
                                                                                ),
                                                                              ),
                                                                              const SizedBox(width: 10),
                                                                              GestureDetector(
                                                                                onTap: () => phoneCallLauncher(memberList[_index].memberInfo!.phone.toString()),
                                                                                child: const CircleAvatar(
                                                                                  radius: 17,
                                                                                  backgroundColor: Colors.blue,
                                                                                  child: Icon(
                                                                                    Icons.call,
                                                                                    color: Colors.white,
                                                                                    size: 16,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                  ),
                                                                  Divider(
                                                                      height: 0,
                                                                      color: Colors
                                                                          .grey
                                                                          .withOpacity(
                                                                              0.2)),
                                                                  Padding(
                                                                    padding: const EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                            5,
                                                                        vertical:
                                                                            5),
                                                                    child: Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceBetween,
                                                                      children: [
                                                                        Row(
                                                                          children: [
                                                                            const Text("Floor No : ",
                                                                                style: TextStyle(color: Colors.grey)),
                                                                            Text(memberList[_index].memberInfo!.floorNumber.toString()),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            const Text("Property No : ",
                                                                                style: TextStyle(color: Colors.grey)),
                                                                            Text(memberList[_index].memberInfo!.aprtNo.toString()),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          );
                                                        } else {
                                                          return Container(
                                                            alignment: Alignment
                                                                .center,
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                        3,
                                                                    vertical:
                                                                        5),
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(22),
                                                            decoration: BoxDecoration(
                                                                color: AppTheme
                                                                    .remainingColor
                                                                    .withOpacity(
                                                                        0.1),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            6)),
                                                            child: Text(
                                                              "VACANT",
                                                              style: TextStyle(
                                                                  color: AppTheme
                                                                      .remainingColor,
                                                                  fontSize: 20),
                                                            ),
                                                          );
                                                        }
                                                      },
                                                    )
                                                  ],
                                                );
                                              },
                                            )),
                          SizedBox(height: 30.h)
                        ],
                      );
                    },
                  );
                }),
          ),
        ),
      ),
    );
  }
}
