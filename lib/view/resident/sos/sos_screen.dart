import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_app/constants/app_theme.dart';
import 'package:ghp_app/controller/sos_management/sos_category/sos_category_cubit.dart';
import 'package:ghp_app/view/resident/sos/sos_detail_screen.dart';
import 'package:ghp_app/view/resident/sos/sos_history.dart';
import 'package:ghp_app/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchbar_animation/searchbar_animation.dart';

class SosScreen extends StatefulWidget {
  const SosScreen({super.key});

  @override
  State<SosScreen> createState() => _SosScreenState();
}

class _SosScreenState extends State<SosScreen> {
  TextEditingController textController = TextEditingController();
  bool searchBarOpen = false;
  @override
  void initState() {
    context.read<SosCategoryCubit>().fetchSosCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SosCategoryCubit, SosCategoryState>(
      listener: (context, state) {
        if (state is SosCategoryLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        backgroundColor: AppTheme.backgroundColor,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.deepPurpleAccent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(100)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const SosHistoryPage())),
            child: const Icon(Icons.history, color: Colors.white)),
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                  child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            searchBarOpen
                                ? const SizedBox()
                                : Row(children: [
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Icon(Icons.arrow_back,
                                            color: Colors.white)),
                                    SizedBox(width: 10.w),
                                    Text('SOS',
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 20.sp,
                                                fontWeight: FontWeight.w600)))
                                  ]),
                            Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: SearchBarAnimation(
                                    searchBoxColour: AppTheme.primaryLiteColor,
                                    buttonColour: AppTheme.primaryLiteColor,
                                    searchBoxWidth:
                                        MediaQuery.of(context).size.width / 1.1,
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
                                      });
                                      context
                                          .read<SosCategoryCubit>()
                                          .fetchSosCategory();
                                      textController.clear();
                                    },
                                    onPressButton: (isSearchBarOpens) {
                                      setState(() {
                                        searchBarOpen = true;
                                      });
                                    },
                                    onChanged: (value) {
                                      context
                                          .read<SosCategoryCubit>()
                                          .searchSos(value);
                                    },
                                    trailingWidget: const Icon(Icons.search,
                                        size: 20, color: Colors.white),
                                    secondaryButtonWidget: const Icon(
                                        Icons.close,
                                        size: 20,
                                        color: Colors.white),
                                    buttonWidget: const Icon(Icons.search,
                                        size: 20, color: Colors.white)))
                          ]))),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  width: double.infinity,
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20))),
                  child: BlocBuilder<SosCategoryCubit, SosCategoryState>(
                    builder: (context, state) {
                      if (state is SosCategorySearchLoaded) {
                        return state.sosCategory.isEmpty
                            ? const Center(
                                child: Text('Category Not Found!',
                                    style: TextStyle(
                                        color: Colors.deepPurpleAccent)))
                            : GridView.builder(
                                padding:
                                    const EdgeInsets.only(top: 15, bottom: 100),
                                itemCount: state.sosCategory.length,
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        mainAxisSpacing: 8, crossAxisCount: 3),
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (builder) =>
                                                    SosDetailScreen(
                                                        sosCategory:
                                                            state.sosCategory[
                                                                index]!)));
                                      },
                                      child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                        color: Colors.black45,
                                                        blurRadius: 5,
                                                        offset: Offset(1, 1))
                                                  ]),
                                              child: ClipOval(
                                                  child: CachedNetworkImage(
                                                      imageUrl: state
                                                          .sosCategory[index]!
                                                          .image,
                                                      width: 90.w,
                                                      height: 90.h,
                                                      fit: BoxFit.cover,
                                                      progressIndicatorBuilder:
                                                          (context, url,
                                                                  progress) =>
                                                              Center(
                                                                  child: Image
                                                                      .asset(
                                                                width: 90.w,
                                                                height: 90.h,
                                                                'assets/images/default.jpg',
                                                                fit: BoxFit
                                                                    .cover,
                                                              )),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Container(
                                                              width: 90.w,
                                                              height: 90.h,
                                                              color: Colors
                                                                  .grey[300],
                                                              child: Icon(
                                                                  Icons
                                                                      .broken_image,
                                                                  color: Colors
                                                                      .grey[600],
                                                                  size: 50)))),
                                            ),
                                            Text(state.sosCategory[index]!.name,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.nunitoSans(
                                                    textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12.sp,
                                                        fontWeight:
                                                            FontWeight.w600)))
                                          ]));
                                });
                      } else if (state is SosCategoryLoaded) {
                        return GridView.builder(
                            padding: const EdgeInsets.only(top: 15),
                            itemCount: state
                                .sosCategory.first.data!.sosCategories.length,
                            shrinkWrap: true,
                            physics: const AlwaysScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    mainAxisSpacing: 8, crossAxisCount: 3),
                            itemBuilder: (context, index) {
                              final sosCategories =
                                  state.sosCategory.first.data!.sosCategories;
                              return GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (builder) =>
                                                SosDetailScreen(
                                                    sosCategory:
                                                        sosCategories[index])));
                                  },
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(100),
                                              boxShadow: const [
                                                BoxShadow(
                                                    color: Colors.black45,
                                                    blurRadius: 5,
                                                    offset: Offset(1, 1))
                                              ]),
                                          child: ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  sosCategories[index].image,
                                              width: 90.w,
                                              height: 90.h,
                                              fit: BoxFit.fill,
                                              progressIndicatorBuilder:
                                                  (context, url, progress) =>
                                                      Center(
                                                child: Image.asset(
                                                  width: 90.w,
                                                  height: 90.h,
                                                  'assets/images/default.jpg',
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Container(
                                                width: 90.w,
                                                height: 90.h,
                                                color: Colors.grey[300],
                                                child: Icon(
                                                  Icons.broken_image,
                                                  color: Colors.grey[600],
                                                  size: 50,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(sosCategories[index].name,
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12.sp,
                                              fontWeight: FontWeight.w600,
                                            )))
                                      ]));
                            });
                      } else if (state is SosCategoryFailed) {
                        return Center(
                            child: Text(state.errorMsg.toString(),
                                style: const TextStyle(
                                    color: Colors.deepPurpleAccent)));
                      } else if (state is SosCategoryLoading) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is SosCategoryInternetError) {
                        return const Center(
                            child: Text('Internet connection error',
                                style: TextStyle(
                                    color:
                                        Colors.red))); // Handle internet error
                      } else {
                        return const SizedBox();
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
