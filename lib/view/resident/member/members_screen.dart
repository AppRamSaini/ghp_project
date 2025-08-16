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
import 'package:google_fonts/google_fonts.dart';

class MemberScreen extends StatefulWidget {
  const MemberScreen({super.key});

  @override
  State<MemberScreen> createState() => _MemberScreenState();
}

class _MemberScreenState extends State<MemberScreen> {
  late final MembersCubit _membersCubit;
  late final MembersElementCubit _membersElementCubit;

  final TextEditingController _textController = TextEditingController();
  final List<Map<String, String>> _types = [
    {"type": "Member", "value": "resident"},
    {"type": "Admin", "value": "admin"},
    {"type": "Staff", "value": "guard"},
  ];

  bool _searchBarOpen = false;

  String? _userId;
  String? _selectedType;
  String? _blockName;
  String? _floorId;

  List<Block> _blocks = [];

  @override
  void initState() {
    super.initState();
    _membersCubit = MembersCubit();
    _membersElementCubit = MembersElementCubit();

    _initializeData();
  }

  void _initializeData() {
    _selectedType = _types[0]['value'];
    _userId = LocalStorage.localStorage.getString('user_id');
    _membersElementCubit.fetchMembersElement();
  }

  void _fetchMembers(String block, {String floor = ''}) {
    _membersCubit.fetchMembers(block, floor, _selectedType!);
  }

  Future<void> _onRefresh() async {
    if (_blockName != null && _selectedType != null) {
      _fetchMembers(_blockName!);
    }
  }

  void _onSearch(String query) {
    _membersCubit.searchMembers(query);
  }

  void _onSearchBarExpanded() {
    setState(() => _searchBarOpen = true);
  }

  void _onSearchBarCollapsed() {
    setState(() {
      _searchBarOpen = false;
      _textController.clear();
    });

    // if (_blockName != null) {
    //   _membersCubit.fetchMembers(_blockName!, _floorId ?? '', '');
    // }
  }

  void _onBlockChanged(String? newBlock) {
    setState(() {
      _blockName = newBlock;
      _selectedType = _types[0]['value'];
    });
    _fetchMembers(_blockName!);
  }

  void _onTypeChanged(String? newType) {
    setState(() => _selectedType = newType);
    if (_blockName != null) {
      _fetchMembers(_blockName!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: 'Members',
        searchBarOpen: _searchBarOpen,
        textController: _textController,
        onExpansionComplete: _onSearchBarExpanded,
        onCollapseComplete: _onSearchBarCollapsed,
        onPressButton: (_) {
          setState(() => _searchBarOpen = true);
        },
        onChanged: (_) => _onSearch(_textController.text),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: BlocBuilder<MembersElementCubit, MembersElementState>(
            bloc: _membersElementCubit,
            builder: (context, state) {
              if (state is MembersElementLoading)
                return notificationShimmerLoading();

              if (state is MembersElementInternetError) {
                return const Center(
                  child: Text('Internet connection failed',
                      style: TextStyle(color: Colors.red)),
                );
              }

              if (state is MembersElementLoaded) {
                _blocks = state.membersElements.first?.data?.blocks ?? [];

                if (_blockName == null && _blocks.isNotEmpty) {
                  _blockName = _blocks.first.name;
                  _fetchMembers(_blockName!);
                }

                // if (_blockName != null) {
                //   _fetchMembers(_blockName!);
                // }
              }

              return BlocBuilder<MembersCubit, MembersState>(
                bloc: _membersCubit,
                builder: (context, state) {
                  if (state is MembersLoading)
                    return notificationShimmerLoading();

                  if (state is MembersFailed) {
                    return _buildError(state.errorMessage);
                  }

                  if (state is MembersInternetError) {
                    return _buildError("Internet connection failed");
                  }

                  SocietyData societyData = _membersCubit.memberList.data!;
                  if (state is MembersSearchedLoaded) {
                    societyData = state.propertyMember;
                  }

                  return _buildMainContent(context, societyData);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildError(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 100),
        child: Text(message,
            style: const TextStyle(color: Colors.deepPurpleAccent)),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, SocietyData societyData) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          _buildSummaryBar(societyData),
          const SizedBox(height: 10),
          _buildFilterRow(context),
          const SizedBox(height: 10),
          Expanded(child: _buildList(societyData)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSummaryBar(SocietyData data) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: AppTheme.greyColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _summaryTile(
              "TOTAL UNIT", data.totalUnits.toString(), AppTheme.primaryColor),
          _summaryTile(
              "VACANT", data.vacant.toString(), AppTheme.remainingColor),
          _summaryTile(
              "OCCUPIED", data.occupied.toString(), AppTheme.handoverColor),
        ],
      ),
    );
  }

  Widget _summaryTile(String label, String value, Color dotColor) {
    return Row(
      children: [
        Container(
            height: 10,
            width: 10,
            decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text("$label: ",
            style: GoogleFonts.nunitoSans(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: AppTheme.darkgreyColor)),
        Text(value,
            style: GoogleFonts.nunitoSans(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.black)),
      ],
    );
  }

  Widget _buildFilterRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: DropdownButton2<String>(
            isExpanded: true,
            underline: Container(),
            value: _blockName,
            hint: Text('Select Tower',
                style: GoogleFonts.nunitoSans(
                    fontSize: 15.sp, color: Colors.grey)),
            items: _blocks
                .map((item) => DropdownMenuItem<String>(
                    value: item.name,
                    child: Text(item.name.toString(),
                        style: const TextStyle(fontSize: 14))))
                .toList(),
            onChanged: _onBlockChanged,
            buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(10))),
            dropdownStyleData: DropdownStyleData(
              maxHeight: MediaQuery.sizeOf(context).height / 2,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: DropdownButton2<String>(
            value: _selectedType,
            isExpanded: true,
            underline: Container(),
            hint: Text('Select Type',
                style: GoogleFonts.nunitoSans(
                    fontSize: 15.sp, color: Colors.grey)),
            items: _types
                .map((value) => DropdownMenuItem<String>(
                    value: value['value'],
                    child: Text(value['type']!,
                        style: const TextStyle(fontSize: 14))))
                .toList(),
            onChanged: _onTypeChanged,
            buttonStyleData: ButtonStyleData(
                decoration: BoxDecoration(
                    color: AppTheme.greyColor,
                    borderRadius: BorderRadius.circular(10))),
            dropdownStyleData: DropdownStyleData(
              maxHeight: MediaQuery.sizeOf(context).height / 2,
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildList(SocietyData data) {
    if (_selectedType == "admin") {
      return _buildAdminList(data.admin ?? []);
    } else if (_selectedType == "guard") {
      return _buildGuardList(data.guards ?? []);
    } else {
      return _buildPropertyList(data.properties ?? []);
    }
  }

  Widget _buildAdminList(List<Admin> admins) => ListView.builder(
        itemCount: admins.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final admin = admins[index];
          return _buildMemberTile(
            email: admin.email,
            highlight: true,
            name: admin.name,
            phone: admin.phone,
            userId: admin.member?.userId.toString(),
            aptNo: admin.member?.aprtNo,
          );
        },
      );

  Widget _buildGuardList(List<Admin> guards) => ListView.builder(
        itemCount: guards.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          final guard = guards[index];
          return _buildMemberTile(
              name: guard.name,
              email: guard.email,
              phone: guard.phone,
              userId: guard.staff?.userId.toString(),
              aptNo: guard.member?.aprtNo,
              highlight: true);
        },
      );

  Widget _buildPropertyList(List<Property> properties) {
    if (properties.isEmpty) {
      return const Center(
          child: Text("Member not found!",
              style: TextStyle(color: Colors.deepPurpleAccent)));
    }

    return ListView.builder(
      itemCount: properties.length,
      shrinkWrap: true,
      itemBuilder: (context, i) {
        final units = properties[i].propertyNumbers ?? [];
        return Column(
          children: units.map((unit) {
            final member = unit.memberInfo;
            if (member != null) {
              return _buildMemberTile(
                email: member.email,
                name: member.name,
                phone: member.phone,
                userId: member.userId.toString(),
                aptNo: member.aprtNo,
                highlight: true,
              );
            } else {
              return _buildVacantTile();
            }
          }).toList(),
        );
      },
    );
  }

  Widget _buildMemberTile(
      {required String? name,
      required String? phone,
      required String? userId,
      String? aptNo,
      String? email,
      bool highlight = false,
      bool showChat = false}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      decoration: BoxDecoration(
          color: highlight ? Colors.green.withOpacity(0.1) : null,
          border: Border.all(color: Colors.grey.withOpacity(0.2)),
          borderRadius: BorderRadius.circular(6)),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 8),
        leading: const CircleAvatar(
            backgroundImage: AssetImage("assets/images/default.jpg")),
        title: Text(name ?? '',
            style: TextStyle(color: Colors.black, fontSize: 14)),
        subtitle: Text(
            aptNo != null ? "Property No : ${aptNo ?? ''}" : " ${email ?? ''}",
            style: TextStyle(color: Colors.black87, fontSize: 12)),
        trailing: _userId == userId
            ? const SizedBox()
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showChat)
                    const CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.chat, color: Colors.white, size: 16)),
                  if (showChat) const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () => phoneCallLauncher(phone ?? ''),
                    child: const CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.blue,
                        child: Icon(Icons.call, color: Colors.white, size: 16)),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildVacantTile() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
          color: AppTheme.remainingColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(6)),
      child: Text("VACANT",
          style: TextStyle(color: AppTheme.remainingColor, fontSize: 20)),
    );
  }
}
