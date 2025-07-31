import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/controller/members/search_member/search_member_cubit.dart';
import 'package:ghp_society_management/model/search_member_modal.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_profile.dart';

import '../../constants/export.dart';

class ResidentsListPage extends StatefulWidget {
  const ResidentsListPage({super.key});

  @override
  State<ResidentsListPage> createState() => _ResidentsListPageState();
}

class _ResidentsListPageState extends State<ResidentsListPage> {
  late SearchMemberCubit _searchMemberCubit;
  TextEditingController searchController = TextEditingController();
  bool searchBarOpen = false;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    _searchMemberCubit = SearchMemberCubit();
    _searchMemberCubit.fetchSearchMember('');
    super.initState();
  }

  List<SearchMemberInfo>? filteredItems;

  Future onRefresh() async {
    _searchMemberCubit.fetchSearchMember('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(
        context: context,
        searchBarOpen: searchBarOpen,
        title: 'Resident Checkouts History',
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
        },
        onPressButton: (isSearchBarOpens) {
          setState(() {
            searchBarOpen = true;
          });
        },
        onChanged: (query) {
          setState(() {
            filteredItems = _searchMemberCubit.searchMemberInfo
                .where((item) => item.name
                    .toString()
                    .toLowerCase()
                    .contains(query.toLowerCase()))
                .toList();
          });
        },
      ),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: BlocBuilder<SearchMemberCubit, SearchMemberState>(
            bloc: _searchMemberCubit,
            builder: (_, state) {
              if (state is SearchMemberLoading) {
                return notificationShimmerLoading();
              }
              if (state is SearchMemberFailed) {
                return Center(
                    child: Text(state.errorMessage.toString(),
                        style:
                            const TextStyle(color: Colors.deepPurpleAccent)));
              }

              if (state is SearchMemberLoaded && textController.text.isEmpty) {
                filteredItems = List.from(_searchMemberCubit.searchMemberInfo);
              }

              if (filteredItems == null || filteredItems!.isEmpty) {
                return const Center(
                    child: Text("Member Not Found!",
                        style: TextStyle(
                            fontSize: 14, color: Colors.deepPurpleAccent)));
              }

              return filteredItems!.isEmpty
                  ? const Center(
                      child: Text("Member Not Found!",
                          style: TextStyle(
                              fontSize: 14, color: Colors.deepPurpleAccent)))
                  : ListView.builder(
                      itemCount: filteredItems!.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 8),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.5))),
                          child: ListTile(
                            dense: true,
                            contentPadding:
                                const EdgeInsets.symmetric(horizontal: 10),
                            title: Text(
                                capitalizeWords(
                                    filteredItems![index].name.toString()),
                                style: const TextStyle(
                                    fontWeight: FontWeight.w500)),
                            subtitle: Text(
                                "Tower/Bloc: ${filteredItems![index].block!.name.toString()} - Property No : ${filteredItems![index].aprtNo.toString()} "),
                            trailing: MaterialButton(
                                height: 32,
                                onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ResidentProfileDetails(
                                                residentId: {
                                                  'resident_id':
                                                      filteredItems![index]
                                                          .userId
                                                          .toString()
                                                },
                                                forQRPage: false,
                                                forResident: false))),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)),
                                color: AppTheme.primaryColor,
                                child: const Text("SCAN",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 12))),
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
}
