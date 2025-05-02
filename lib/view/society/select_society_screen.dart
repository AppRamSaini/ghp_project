import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/controller/select_society/select_society_cubit.dart';
import 'package:ghp_society_management/view/resident/authentication/login_screen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class SelectSocietyScreen extends StatefulWidget {
  const SelectSocietyScreen({super.key});

  @override
  State<SelectSocietyScreen> createState() => _SelectSocietyScreenState();
}

class _SelectSocietyScreenState extends State<SelectSocietyScreen> {
  TextEditingController textController = TextEditingController();
  bool searchBarOpen = false;
  final ScrollController _scrollController = ScrollController();
  late SelectSocietyCubit _selectSocietyCubit;

  @override
  void initState() {
    _selectSocietyCubit = SelectSocietyCubit()..fetchSocietyList();
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent < 300) {
      _selectSocietyCubit.loadMoreNotice();
    }
  }

  Future onRefresh() async {
    _selectSocietyCubit = SelectSocietyCubit()..fetchSocietyList();
    setState(() {});
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: searchBarOpen
            ? const SizedBox()
            : Text('Select Society',
                style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w600))),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: SearchBarAnimation(
              searchBoxColour: AppTheme.white,
              buttonColour: AppTheme.primaryColor,
              searchBoxWidth: MediaQuery.of(context).size.width / 1.1,
              isSearchBoxOnRightSide: false,
              textEditingController: textController,
              isOriginalAnimation: true,
              enableKeyboardFocus: true,
              hintTextColour:  AppTheme.primaryColor,
              hintText: "Search society name...",
              cursorColour: AppTheme.primaryColor,
              enteredTextStyle: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      color: AppTheme.primaryColor,
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
                  _selectSocietyCubit.fetchSocietyList();
                  textController.clear();
                });
              },
              onPressButton: (isSearchBarOpens) {
                setState(() {
                  searchBarOpen = true;
                });
              },
              onChanged: (value) {
                _selectSocietyCubit.searchSociety(value);
              },
              trailingWidget:

                   Icon(Icons.search, size: 20, color: AppTheme.primaryColor),
              secondaryButtonWidget:
                  const Icon(Icons.close, size: 20, color: Colors.white),
              buttonWidget:
                   Icon(Icons.search, size: 20, color: AppTheme.white),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<SelectSocietyCubit, SelectSocietyState>(
              bloc: _selectSocietyCubit,
              builder: (context, state) {
                if (state is SelectSocietyLoading &&
                    _selectSocietyCubit.societyList.isEmpty) {
                  return const Center(
                      child: CircularProgressIndicator.adaptive());
                }
                if (state is SelectSocietyFailed) {
                  return Center(
                      child: Text(state.errorMsg,
                          style: const TextStyle(
                              color: Colors.deepPurpleAccent)));
                }
                if (state is SelectSocietyInternetError) {
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 12.h, top: 12.h),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Internet connection error!',
                              style: GoogleFonts.nunitoSans(
                                  textStyle: const TextStyle(
                                      color: Colors.red, fontSize: 16))),
                          const SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => onRefresh,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 10),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color:
                                      AppTheme.primaryColor.withOpacity(0.15)),
                              child: Text('Retry!',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: AppTheme.primaryColor,
                                        fontSize: 16),
                                  )),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                }

                var societyList = _selectSocietyCubit.societyList;

                if (state is SelectSocietySearchedLoaded) {
                  societyList = state.selectedSociety;
                }
                if (societyList.isEmpty) {
                  return const Center(
                      child: Text('Society Not Found!',
                          style: TextStyle(color: Colors.deepPurpleAccent)));
                }

                List<Color> bgColors = [
                  Color(0xFF4900FF), // Purple
                  Color(0xFF57C8E8), // Blue
                  Color(0xFFFFA1A1), // Pink
                ];
                return ListView.builder(

                  padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 5),
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: societyList.length + 1,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    if (index == societyList.length) {
                      return _selectSocietyCubit.state
                              is SelectSocietyLoadMore
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                  child:
                                      CircularProgressIndicator.adaptive()))
                          : const SizedBox.shrink();
                    }

                    // Calculate background color based on index
                    Color backgroundColor = bgColors[index % bgColors.length];
                    return GestureDetector(
                      onTap: () async {
                        LocalStorage.localStorage.setString(
                            'societyId', '${societyList[index].id}');
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (builder) => LoginScreen(
                                societyId:
                                    societyList[index].id.toString())));
                      },
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                            color: backgroundColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Row(
                            children: [
                              Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Image.asset(
                                      ImageAssets.societyImage,
                                      height: 35.h,
                                      width: 35.h,color:  backgroundColor.withOpacity(0.5)
                                  )),
                              SizedBox(width: 10.w),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    Text(societyList[index].name.toString(),
                                        style: GoogleFonts.ptSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15.sp,
                                                fontWeight:
                                                    FontWeight.w500))),
                                    Text(
                                        '${societyList[index].totalTowers} Towers, ${societyList[index].location}',
                                        style: GoogleFonts.ptSans(
                                            textStyle: TextStyle(
                                                color:
                                                Colors.black87,
                                                fontSize: 12.sp,
                                                fontWeight:
                                                    FontWeight.w500)))
                                  ])),
                              Icon(
                                Icons.navigate_next,
                                color: backgroundColor.withOpacity(0.8),
                                size: 30,
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                );
              }),
        ),
      ),
    );
  }
}
