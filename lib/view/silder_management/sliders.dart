import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/controller/sliders/sliders_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/sliders_model.dart';
import 'package:ghp_society_management/view/society/select_society_screen.dart';

class SlidersManagement extends StatefulWidget {
  final bool forOnBoarding;

  const SlidersManagement({super.key, this.forOnBoarding = false});

  @override
  State<SlidersManagement> createState() => _SlidersManagementState();
}

class _SlidersManagementState extends State<SlidersManagement> {
  late PageController _pageController;
  int _currentPage = 0;
  late SlidersCubit _slidersCubit;

  @override
  void initState() {
    super.initState();
    context.read<UserProfileCubit>().fetchUserProfile();
    _slidersCubit = SlidersCubit()..fetchSlidersAPI();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlidersCubit, SlidersState>(
      bloc: _slidersCubit,
      builder: (context, state) {
        if (state is SlidersLoading) {
          return widget.forOnBoarding
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Image.asset(ImageAssets.appLogo,
                                  height: size.height * 0.06)),
                          SizedBox(height: size.height * 0.01),
                          Text("LOCATION",
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 16)),
                          Text("Ghp Society management",
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          Text(
                            "Invest in our upcoming projects for better futuure",
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                    SizedBox(
                      height: size.height * 0.32,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 1,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image.asset('assets/images/default.jpg',
                                    height: size.height * 0.3,
                                    width: double.infinity,
                                    fit: BoxFit.cover)),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        1,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 20.0 : 8.0,
                          height: _currentPage == index ? 8.0 : 8.0,
                          decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppTheme.blueColor
                                  : const Color(0xFF34306F),
                              borderRadius: BorderRadius.circular(30)
                              // shape: BoxShape.circle,
                              ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          LocalStorage.localStorage
                              .setString('onboarding', 'true');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) =>
                                  const SelectSocietyScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: AppTheme.primaryColor)),
                            child: Center(
                              child: Text('Skip To Main Content ',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                )
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(10.0)),
                      child: Image.asset('assets/images/default.jpg',
                          height: 180.h,
                          width: double.infinity,
                          fit: BoxFit.cover)));
        } else if (state is SlidersLoaded) {
          List<SliderList> slidersList = state.sliders;
          return widget.forOnBoarding
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                              padding: EdgeInsets.all(8.w),
                              child: Image.asset(ImageAssets.appLogo,
                                  height: size.height * 0.06)),
                          SizedBox(height: size.height * 0.02),
                          Text(
                              slidersList[_currentPage]
                                  .location
                                  .toString()
                                  .toUpperCase(),
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent,
                                  fontSize: 16)),
                          Text(slidersList[_currentPage].title.toString(),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 5),
                          Text(
                            slidersList[_currentPage].subTitle.toString(),
                            style: const TextStyle(
                                color: Colors.black87, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                      height: size.height * 0.32,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: slidersList.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 25),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: FadeInImage(
                                    height: size.height * 0.32,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (_, child, stackTrack) =>
                                        Image.asset('assets/images/default.jpg',
                                            height: size.height * 0.32,
                                            width: double.infinity,
                                            fit: BoxFit.cover),
                                    image: NetworkImage(
                                        slidersList[index].image.toString()),
                                    placeholder: const AssetImage(
                                        'assets/images/default.jpg'))),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        slidersList.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 20.0 : 8.0,
                          height: _currentPage == index ? 8.0 : 8.0,
                          decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppTheme.primaryColor
                                  : const Color(0xFF34306F),
                              borderRadius: BorderRadius.circular(30)
                              // shape: BoxShape.circle,
                              ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: GestureDetector(
                        onTap: () {
                          LocalStorage.localStorage
                              .setString('onboarding', 'true');
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (builder) =>
                                  const SelectSocietyScreen()));
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 15),
                          child: Container(
                            width: double.infinity,
                            height: 50.h,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                border:
                                    Border.all(color: AppTheme.primaryColor)),
                            child: Center(
                              child: Text('Skip To Main Content ',
                                  style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                  ],
                )
              : Column(
                  children: [
                    SizedBox(
                      height: 180.h,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: slidersList.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Stack(
                              alignment: Alignment.centerLeft,
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                        height: 180.h,
                                        width: double.infinity,
                                        fit: BoxFit.fill,
                                        imageErrorBuilder: (_, child,
                                                stackTrack) =>
                                            Image.asset(
                                                'assets/images/default.jpg',
                                                height: 180.h,
                                                width: double.infinity,
                                                fit: BoxFit.cover),
                                        image: NetworkImage(slidersList[index]
                                            .image
                                            .toString()),
                                        placeholder: const AssetImage(
                                            'assets/images/default.jpg'))),
                                Container(
                                    height: 180.h,
                                    width: MediaQuery.sizeOf(context).width,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        gradient: LinearGradient(colors: [
                                          Color(0xFF000000),
                                          Color(0xFFBDE0FF).withOpacity(0.05),
                                        ]))),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          slidersList[index]
                                              .location
                                              .toString()
                                              .toUpperCase(),
                                          style: const TextStyle(
                                              color: Colors.deepPurpleAccent,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500)),
                                      Text(slidersList[index].title.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600)),
                                      const SizedBox(height: 5),
                                      Text(
                                        slidersList[index].subTitle.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        slidersList.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          margin: const EdgeInsets.symmetric(horizontal: 4.0),
                          width: _currentPage == index ? 20.0 : 8.0,
                          height: _currentPage == index ? 8.0 : 8.0,
                          decoration: BoxDecoration(
                              color: _currentPage == index
                                  ? AppTheme.blueColor
                                  : const Color(0xFF34306F),
                              borderRadius: BorderRadius.circular(30)
                              // shape: BoxShape.circle,
                              ),
                        ),
                      ),
                    ),
                  ],
                );
        } else if (state is SlidersFailed) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Image.asset('assets/images/default.jpg',
                  height: 180.h, width: double.infinity, fit: BoxFit.cover),
            ),
          );
        } else if (state is SlidersInternetError) {
          return Container(
            margin: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
              child: Image.asset('assets/images/default.jpg',
                  height: 180.h, width: double.infinity, fit: BoxFit.cover),
            ),
          );
        }
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 8.0),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            child: Image.asset('assets/images/default.jpg',
                height: 180.h, width: double.infinity, fit: BoxFit.cover),
          ),
        ); // Default case, return empty container
      },
    );
  }
}
