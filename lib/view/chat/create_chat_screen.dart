import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/model/user_model.dart';
import 'package:uuid/uuid.dart';

import '../../model/staff_model.dart';

class CreateChatScreen extends StatefulWidget {
  final String userId;
  final String userName;
  final String userImage;

  const CreateChatScreen({
    super.key,
    required this.userId,
    required this.userName,
    required this.userImage,
  });

  @override
  State<CreateChatScreen> createState() => _CreateChatScreenState();
}

class _CreateChatScreenState extends State<CreateChatScreen> {
  bool searchBarOpen = false;
  final TextEditingController textController = TextEditingController();
  UserModel? userList;
  late BuildContext dialogContext;

  @override
  void initState() {
    super.initState();
    context.read<GetStaffCubit>().fetchStaffList();
  }

  Future<void> onRefresh() async {
    context.read<GetStaffCubit>().fetchStaffList();
  }

  void _handleStaffTap(Datum staff) {
    final uuid = const Uuid();
    final String groupId = uuid.v6();

    userList = UserModel(
        userImage: staff.image,
        uid: staff.userId.toString(),
        userName: staff.name,
        serviceCategory: staff.staffCategory?.name.isNotEmpty == true
            ? staff.staffCategory!.name
            : staff.role.toString());

    context.read<GroupCubit>().createGroup(
        userList!,
        groupId,
        context,
        widget.userId,
        widget.userName,
        widget.userImage,
        userList!.serviceCategory ?? '');
  }

  Widget _buildStaffTile(Datum staff) {
    return InkWell(
      onTap: () => _handleStaffTap(staff),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
        dense: true,
        leading: Card(
            elevation: 1,
            shape: const CircleBorder(),
            child: CircleAvatar(
                radius: 25.r,
                backgroundImage: staff.image != null
                    ? NetworkImage(staff.image!)
                    : const AssetImage(ImageAssets.chatImage)
                        as ImageProvider)),
        title: Text(
          capitalizeWords(staff.name),
          style: GoogleFonts.nunitoSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          staff.staffCategory?.name.isNotEmpty == true
              ? staff.staffCategory!.name
              : capitalizeWords(staff.role.replaceAll("_", ' ')),
          style: GoogleFonts.nunitoSans(
            fontSize: 12,
            fontWeight: FontWeight.w400,
          ),
        ),
        trailing: const CircleAvatar(
          child: Icon(Icons.send_rounded, size: 18),
        ),
      ),
    );
  }

  Widget _buildSearchList(List<Datum?> staffList) {
    return ListView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: staffList.length,
      itemBuilder: (context, index) {
        final staff = staffList[index];
        if (staff == null) return const SizedBox();
        return _buildStaffTile(staff);
      },
    );
  }

  Widget _buildStaffList(List<Datum> staffList) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (_, __) =>
          Divider(height: 0.6, color: Colors.grey[300]),
      itemCount: staffList.length,
      itemBuilder: (context, index) => _buildStaffTile(staffList[index]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: 'Society Staff',
        textController: textController,
        searchBarOpen: searchBarOpen,
        onExpansionComplete: () => setState(() => searchBarOpen = true),
        onCollapseComplete: () {
          setState(() {
            searchBarOpen = false;
            context.read<GetStaffCubit>().searchStaff('');
            context.read<GetStaffCubit>().fetchStaffList();
          });
        },
        onPressButton: (_) => setState(() => searchBarOpen = true),
        onChanged: (value) {
          context.read<GetStaffCubit>().searchStaff(value);
        },
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: BlocBuilder<GetStaffCubit, GetStaffState>(
          builder: (context, state) {
            if (state is GetStaffLoading) {
              return notificationShimmerLoading();
            } else if (state is GetStaffFailed) {
              return Center(
                child: Text(state.errorMsg,
                    style: const TextStyle(color: Colors.deepPurpleAccent)),
              );
            } else if (state is GetStaffInternetError) {
              return const Center(
                child: Text("Internet connection error",
                    style: TextStyle(color: Colors.red)),
              );
            } else if (state is GetStaffSearchedLoaded) {
              return state.staffList.isEmpty
                  ? const Center(
                      child: Text("Service Provider Not Found!",
                          style: TextStyle(color: Colors.deepPurpleAccent)))
                  : _buildSearchList(state.staffList);
            } else if (state is GetStaffLoaded) {
              final staffList = state.staffList.first.data.staffs.data;
              return staffList.isEmpty
                  ? const Center(
                      child: Text("Service Provider Not Found!",
                          style: TextStyle(color: Colors.deepPurpleAccent)))
                  : _buildStaffList(staffList);
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
