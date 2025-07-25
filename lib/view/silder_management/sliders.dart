import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/sliders_model.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';

class SlidersManagement extends StatefulWidget {
  final bool forOnBoarding;

  const SlidersManagement({super.key, this.forOnBoarding = false});

  @override
  State<SlidersManagement> createState() => _SlidersManagementState();
}

class _SlidersManagementState extends State<SlidersManagement> {
  int _currentPage = 0;
  late PageController _pageController;
  Timer? _autoScrollTimer;

  late SlidersCubit _slidersCubit;

  @override
  void initState() {
    super.initState();
    _slidersCubit = SlidersCubit()..fetchSlidersAPI();
    _pageController = PageController(initialPage: _currentPage);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;

      List<SliderList> slidersList = _slidersCubit.slidersList;

      if (slidersList.isEmpty || !_pageController.hasClients) return;

      int nextPage = _currentPage + 1;
      if (nextPage >= slidersList.length) {
        nextPage = 0;
      }

      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 1200),
        curve: Curves.easeInOut,
      );

      setState(() {
        _currentPage = nextPage;
      });
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
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
              ? dummy()
              : Column(
                  children: [
                    Container(
                        height: MediaQuery.sizeOf(context).height * 0.2,
                        width: MediaQuery.sizeOf(context).width * 0.98,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                            child: Image.asset('assets/images/default.jpg',
                                height: MediaQuery.sizeOf(context).height * 0.2,
                                width: MediaQuery.sizeOf(context).width * 0.98,
                                fit: BoxFit.cover))),
                    SizedBox(height: 5.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        4,
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
        } else if (state is SlidersLoaded) {
          List<SliderList> slidersList = state.sliders;
          return widget.forOnBoarding
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(ImageAssets.roundLogo,
                              height: size.height * 0.13, fit: BoxFit.fill),
                          SizedBox(height: size.height * 0.02),

                          // Location - animated
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(opacity: animation, child: child),
                            child: Text(
                              slidersList[_currentPage].location.toString().toUpperCase(),
                              key: ValueKey(slidersList[_currentPage].location),
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent, fontSize: 16),
                            ),
                          ),

                          SizedBox(height: 8),

                          // Title - animated
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(opacity: animation, child: child),
                            child: Text(
                              slidersList[_currentPage].title.toString(),
                              key: ValueKey(slidersList[_currentPage].title),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),

                          const SizedBox(height: 5),

                          // SubTitle - animated
                          AnimatedSwitcher(
                            duration: Duration(milliseconds: 500),
                            transitionBuilder: (child, animation) =>
                                FadeTransition(opacity: animation, child: child),
                            child: Text(
                              slidersList[_currentPage].subTitle.toString(),
                              key: ValueKey(slidersList[_currentPage].subTitle),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.black87,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: size.height * 0.03),
                    SizedBox(
                      height: size.height * 0.38,
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
                                    height: size.height * 0.4,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    imageErrorBuilder: (_, child, stackTrack) =>
                                        Image.asset('assets/images/default.jpg',
                                            height: size.height * 0.4,
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
                            height: 50,
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
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.sizeOf(context).height * 0.2,
                      width: MediaQuery.sizeOf(context).width * 0.98,
                      child: PageView.builder(
                        dragStartBehavior: DragStartBehavior.down,
                        controller: _pageController,
                        itemCount: slidersList.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPage = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            child: SizedBox(
                              height: MediaQuery.sizeOf(context).height * 0.2,
                              width: MediaQuery.sizeOf(context).width * 0.98,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                              0.2,
                                      width: MediaQuery.sizeOf(context).width *
                                          0.98,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder: (_, __, ___) =>
                                          Image.asset(
                                        'assets/images/default.jpg',
                                        height: double.infinity,
                                        width: double.infinity,
                                        fit: BoxFit.cover,
                                      ),
                                      image: NetworkImage(
                                          slidersList[index].image.toString()),
                                      placeholder: const AssetImage(
                                          'assets/images/default.jpg'),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFF000000),
                                          const Color(0xFFBDE0FF)
                                              .withOpacity(0.05),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          slidersList[index]
                                              .location
                                              .toString()
                                              .toUpperCase(),
                                          style:  GoogleFonts.roboto(
                                            color: Colors.deepPurpleAccent,
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          slidersList[index].title.toString(),
                                          style:  GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 5),
                                        Text(
                                          slidersList[index]
                                              .subTitle
                                              .toString(),
                                          style:  GoogleFonts.roboto(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
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
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
        } else if (state is SlidersFailed) {
          return widget.forOnBoarding
              ? dummy()
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.asset('assets/images/default.jpg',
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover),
                  ),
                );
        } else if (state is SlidersInternetError) {
          return widget.forOnBoarding
              ? dummy()
              : Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    child: Image.asset('assets/images/default.jpg',
                        height: 180.h,
                        width: double.infinity,
                        fit: BoxFit.cover),
                  ),
                );
        }
        return widget.forOnBoarding
            ? dummy()
            : Container(
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

  Widget dummy() => Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(ImageAssets.roundLogo,
                    height: size.height * 0.13),
                SizedBox(height: size.height * 0.02),
                Text("LOCATION",
                    style: const TextStyle(
                        color: Colors.deepPurpleAccent, fontSize: 16)),
                Text("GHP Society management",
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.w600)),
                const SizedBox(height: 5),
                Text(
                  "Invest in our upcoming projects for better future",
                  style:  TextStyle(color: Colors.black87, fontSize: 14,fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
          SizedBox(height: size.height * 0.02),
          SizedBox(
            height: size.height * 0.4,
            child: PageView.builder(
              controller: _pageController,
              itemCount: 3,
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
                          height: size.height * 0.4,
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
              3,
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
                LocalStorage.localStorage.setString('onboarding', 'true');
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (builder) => const SelectSocietyScreen()));
              },
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
                child: Container(
                  width: double.infinity,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: AppTheme.primaryColor)),
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
      );
}
