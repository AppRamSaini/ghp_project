import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/members/members_cubit.dart';
import 'package:ghp_society_management/controller/members_element/members_element_cubit.dart';
import 'package:ghp_society_management/model/members_element_model.dart';
import 'package:ghp_society_management/model/members_model.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_profile.dart';
import 'package:google_fonts/google_fonts.dart';

class ResidentsListPage extends StatefulWidget {
  const ResidentsListPage({super.key});

  @override
  State<ResidentsListPage> createState() => _ResidentsListPageState();
}

class _ResidentsListPageState extends State<ResidentsListPage> {
  late MembersCubit _membersCubit;
  late MembersElementCubit _membersElementCubit;

  String? blockName;
  String? floorId;
  String? type;
  String? _userId;

  final TextEditingController textController = TextEditingController();
  final List types = [
    {"type": "Member", "value": "resident"},
    {"type": "Admin", "value": "admin"},
    {"type": "Staff", "value": "guard"},
  ];

  List<Block> memberBlocsList = [];
  bool searchBarOpen = false;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _membersCubit = MembersCubit();
    _membersElementCubit = MembersElementCubit();
    _membersElementCubit.fetchMembersElement();

    type = types[0]['value'];
    _userId = LocalStorage.localStorage.getString('user_id');
  }

  Future<void> fetchData(String block,
      [String floor = '', String? type]) async {
    _membersCubit.fetchMembers(block, floor, type ?? this.type!);
  }

  Future<void> onRefresh() async {
    await fetchData(blockName ?? '', '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: 'Members',
        searchBarOpen: searchBarOpen,
        textController: textController,
        onExpansionComplete: () => setState(() => searchBarOpen = true),
        onCollapseComplete: () {
          setState(() {
            searchBarOpen = false;
            textController.clear();
          });
          fetchData(blockName ?? '', '');
        },
        onPressButton: (_) {
          onRefresh();
          setState(() => searchBarOpen = true);
        },
        onChanged: (_) =>
            _membersCubit.searchMembers(textController.text.trim()),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: RefreshIndicator(
            onRefresh: onRefresh,
            child: BlocBuilder<MembersElementCubit, MembersElementState>(
              bloc: _membersElementCubit,
              builder: (context, state) {
                if (state is MembersElementLoading) {
                  return notificationShimmerLoading();
                }

                if (state is MembersElementInternetError) {
                  return _buildErrorMessage("Internet connection failed");
                }

                if (state is MembersElementLoaded) {
                  final blocks =
                      state.membersElements.first?.data?.blocks ?? [];
                  memberBlocsList = blocks;

                  // Set default blockName once
                  if (blockName == null && blocks.isNotEmpty) {
                    blockName = blocks.first.name;
                    fetchData(blockName!);
                  }
                }

                return BlocBuilder<MembersCubit, MembersState>(
                  bloc: _membersCubit,
                  builder: (context, state) {
                    if (state is MembersLoading) {
                      return notificationShimmerLoading();
                    }

                    if (state is MembersFailed) {
                      return _buildErrorMessage(state.errorMessage);
                    }

                    if (state is MembersInternetError) {
                      return _buildErrorMessage("Internet connection failed");
                    }

                    SocietyData societyData = _membersCubit.memberList.data!;
                    if (state is MembersSearchedLoaded) {
                      societyData = state.propertyMember;
                    }

                    return Column(
                      children: [
                        _buildDropdowns(context),
                        SizedBox(height: 10.h),
                        Expanded(child: _buildMembersList(societyData)),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdowns(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Select Tower/Block"),
              SizedBox(height: 5),
              DropdownButton2<String>(
                isExpanded: true,
                underline: Container(),
                value: blockName,
                hint: _dropdownHint('Select Tower'),
                items: memberBlocsList.map((block) {
                  return DropdownMenuItem<String>(
                      value: block.name,
                      child:
                          Text(block.name ?? '', style: _dropdownTextStyle()));
                }).toList(),
                onChanged: (value) {
                  blockName = value;
                  type = types[0]['value'];
                  fetchData(blockName!);
                },
                iconStyleData: _dropdownIconStyle(),
                buttonStyleData: _dropdownButtonStyle(),
                dropdownStyleData: _dropdownBoxStyle(context),
                menuItemStyleData: _dropdownItemStyle(),
              ),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text("Select Type"),
              SizedBox(height: 5),
              DropdownButton2<String>(
                isExpanded: true,
                underline: Container(),
                value: type,
                hint: _dropdownHint('Select Type'),
                items: types.map((item) {
                  return DropdownMenuItem<String>(
                      value: item['value'],
                      child: Text(item['type'], style: _dropdownTextStyle()));
                }).toList(),
                onChanged: (value) {
                  type = value;
                  fetchData(blockName ?? '', '', type);
                },
                iconStyleData: _dropdownIconStyle(),
                buttonStyleData: _dropdownButtonStyle(),
                dropdownStyleData: _dropdownBoxStyle(context),
                menuItemStyleData: _dropdownItemStyle(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMembersList(SocietyData data) {
    if (type == 'admin') {
      return _buildUserList(data.admin);
    } else if (type == 'guard') {
      return _buildUserList(data.guards);
    } else {
      return data.properties == null || data.properties!.isEmpty
          ? _buildErrorMessage("Member not found!")
          : ListView.builder(
              itemCount: data.properties!.length,
              itemBuilder: (context, index) {
                final floor = data.properties![index];
                final memberList = floor.propertyNumbers ?? [];

                return ListView.builder(
                  itemCount: memberList.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    final member = memberList[i].memberInfo;
                    if (member == null) return const SizedBox();
                    return _buildMemberCard(
                        propertyId: member.id.toString() ?? '',
                        name: member.name ?? '',
                        propertyNo: member.aprtNo ?? '',
                        userId: member.userId.toString() ?? '');
                  },
                );
              },
            );
    }
  }

  Widget _buildUserList(List<Admin>? users) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: users?.length ?? 0,
      itemBuilder: (context, index) {
        final user = users![index];
        return _buildMemberCard(
          propertyId: user.id.toString(),
          name: user.name ?? '',
          propertyNo: user.member?.aprtNo ?? '',
          userId: user.member?.userId.toString() ?? '',
        );
      },
    );
  }

  Widget _buildMemberCard(
      {required String name,
      required String propertyNo,
      required String userId,
      required String propertyId}) {
    return Card(
      child: ListTile(
        dense: true,
        contentPadding: EdgeInsets.symmetric(horizontal: 5),
        leading: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/default.jpg")),
        title: Text(name, style: const TextStyle(fontSize: 12)),
        subtitle: Text("PROPERTY NO - $propertyNo",
            style: const TextStyle(fontSize: 10)),
        trailing: (_userId == userId)
            ? const SizedBox()
            : selectBtn(() {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (_) => ResidentProfileDetails(
                            residentId: {'resident_id': userId.toString()},
                            forQRPage: false,
                            forResident: false)));
              }),
      ),
    );
  }

  Widget _buildErrorMessage(String message) {
    return Center(
        child: Text(message,
            style: const TextStyle(color: Colors.deepPurpleAccent)));
  }

  Widget _dropdownHint(String text) => Text(text,
      style: GoogleFonts.nunitoSans(
          textStyle: const TextStyle(color: Colors.grey, fontSize: 15)));

  TextStyle _dropdownTextStyle() =>
      const TextStyle(fontSize: 14, color: Colors.black);

  IconStyleData _dropdownIconStyle() => const IconStyleData(
      icon: Icon(Icons.arrow_drop_down, color: Colors.black45), iconSize: 24);

  ButtonStyleData _dropdownButtonStyle() => ButtonStyleData(
      decoration: BoxDecoration(
          color: AppTheme.greyColor, borderRadius: BorderRadius.circular(10)));

  DropdownStyleData _dropdownBoxStyle(BuildContext context) =>
      DropdownStyleData(
          maxHeight: MediaQuery.sizeOf(context).height / 2,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)));

  MenuItemStyleData _dropdownItemStyle() =>
      const MenuItemStyleData(padding: EdgeInsets.symmetric(horizontal: 10));
}

Widget selectBtn(void Function()? onTap) => GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 6),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: AppTheme.primaryColor),
        child:
            Text("SCAN", style: TextStyle(color: AppTheme.white, fontSize: 12)),
      ),
    );

// class ResidentsListPage extends StatefulWidget {
//   const ResidentsListPage({super.key});
//
//   @override
//   State<ResidentsListPage> createState() => _ResidentsListPageState();
// }
//
// class _ResidentsListPageState extends State<ResidentsListPage> {
//   late SearchMemberCubit _searchMemberCubit;
//   TextEditingController searchController = TextEditingController();
//   bool searchBarOpen = false;
//   TextEditingController textController = TextEditingController();
//
//   @override
//   void initState() {
//     _searchMemberCubit = SearchMemberCubit();
//     _searchMemberCubit.fetchSearchMember('');
//     super.initState();
//   }
//
//   List<SearchMemberInfo>? filteredItems;
//
//   Future onRefresh() async {
//     _searchMemberCubit.fetchSearchMember('');
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: customAppbar(
//         context: context,
//         searchBarOpen: searchBarOpen,
//         title: 'Resident Checkouts History',
//         textController: textController,
//         onExpansionComplete: () {
//           setState(() {
//             searchBarOpen = true;
//           });
//         },
//         onCollapseComplete: () {
//           setState(() {
//             searchBarOpen = false;
//             textController.clear();
//           });
//         },
//         onPressButton: (isSearchBarOpens) {
//           setState(() {
//             searchBarOpen = true;
//           });
//         },
//         onChanged: (query) {
//           setState(() {
//             filteredItems = _searchMemberCubit.searchMemberInfo
//                 .where((item) => item.name
//                     .toString()
//                     .toLowerCase()
//                     .contains(query.toLowerCase()))
//                 .toList();
//           });
//         },
//       ),
//       body: RefreshIndicator(
//         onRefresh: onRefresh,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: BlocBuilder<SearchMemberCubit, SearchMemberState>(
//             bloc: _searchMemberCubit,
//             builder: (_, state) {
//               if (state is SearchMemberLoading) {
//                 return notificationShimmerLoading();
//               }
//               if (state is SearchMemberFailed) {
//                 return Center(
//                     child: Text(state.errorMessage.toString(),
//                         style:
//                             const TextStyle(color: Colors.deepPurpleAccent)));
//               }
//
//               if (state is SearchMemberLoaded && textController.text.isEmpty) {
//                 filteredItems = List.from(_searchMemberCubit.searchMemberInfo);
//               }
//
//               if (filteredItems == null || filteredItems!.isEmpty) {
//                 return const Center(
//                     child: Text("Member Not Found!",
//                         style: TextStyle(
//                             fontSize: 14, color: Colors.deepPurpleAccent)));
//               }
//
//               return filteredItems!.isEmpty
//                   ? const Center(
//                       child: Text("Member Not Found!",
//                           style: TextStyle(
//                               fontSize: 14, color: Colors.deepPurpleAccent)))
//                   : ListView.builder(
//                       itemCount: filteredItems!.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.only(bottom: 8),
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(4),
//                               border: Border.all(
//                                   color: Colors.grey.withOpacity(0.5))),
//                           child: ListTile(
//                             dense: true,
//                             contentPadding:
//                                 const EdgeInsets.symmetric(horizontal: 10),
//                             title: Text(
//                                 capitalizeWords(
//                                     filteredItems![index].name.toString()),
//                                 style: const TextStyle(
//                                     fontWeight: FontWeight.w500)),
//                             subtitle: Text(
//                                 "Tower/Bloc: ${filteredItems![index].block!.name.toString()} - Property No : ${filteredItems![index].aprtNo.toString()} "),
//                             trailing: MaterialButton(
//                                 height: 32,
//                                 onPressed: () => Navigator.pushReplacement(
//                                     context,
//                                     MaterialPageRoute(
//                                         builder: (_) => ResidentProfileDetails(
//                                                 residentId: {
//                                                   'resident_id':
//                                                       filteredItems![index]
//                                                           .userId
//                                                           .toString()
//                                                 },
//                                                 forQRPage: false,
//                                                 forResident: false))),
//                                 shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30)),
//                                 color: AppTheme.primaryColor,
//                                 child: const Text("SCAN",
//                                     style: TextStyle(
//                                         color: Colors.white, fontSize: 12))),
//                           ),
//                         );
//                       },
//                     );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
