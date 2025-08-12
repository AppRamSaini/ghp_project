import 'dart:async';

import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/sliders_model.dart';
import 'package:ghp_society_management/view/select_society/select_society_screen.dart';

class OnboardingSlidersManagement extends StatefulWidget {
  const OnboardingSlidersManagement({super.key});

  @override
  State<OnboardingSlidersManagement> createState() =>
      _OnboardingSlidersManagementState();
}

class _OnboardingSlidersManagementState
    extends State<OnboardingSlidersManagement> {
  // int _currentPage = 0;
  // late PageController _pageController;
  // Timer? _autoScrollTimer;
  //
  // @override
  // void initState() {
  //   super.initState();
  //   _pageController = PageController(initialPage: _currentPage);
  //   _startAutoScroll();
  // }
  //
  // void _startAutoScroll() {
  //   _autoScrollTimer?.cancel();
  //   _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
  //     if (!mounted) return;
  //
  //     List<SliderList> slidersList = context.read<SlidersCubit>().slidersList;
  //
  //     if (slidersList.isEmpty || !_pageController.hasClients) return;
  //
  //     int nextPage = _currentPage + 1;
  //     if (nextPage >= slidersList.length) {
  //       nextPage = 0;
  //     }
  //
  //     _pageController.animateToPage(
  //       nextPage,
  //       duration: const Duration(milliseconds: 1200),
  //       curve: Curves.easeInOut,
  //     );
  //
  //     setState(() {
  //       _currentPage = nextPage;
  //     });
  //   });
  // }
  //
  // @override
  // void dispose() {
  //   _autoScrollTimer?.cancel();
  //   _pageController.dispose();
  //   super.dispose();
  // }

  int _currentPage = 1;
  late PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    // context.read<SlidersCubit>().fetchSlidersAPI();
    _pageController = PageController(initialPage: _currentPage);
    WidgetsBinding.instance.addPostFrameCallback((_) => _startAutoScroll());
  }

  void _startAutoScroll() {
    _autoScrollTimer?.cancel();
    _autoScrollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      if (!mounted || !_pageController.hasClients) return;
      final sliders = context.read<SlidersCubit>().slidersList;
      if (sliders.isEmpty) return;

      _pageController.nextPage(
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoScrollTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  List<SliderList> _getLoopedList(List<SliderList> original) {
    if (original.length < 2) return original;
    final List<SliderList> looped = [];
    looped.add(original.last); // fake first
    looped.addAll(original);
    looped.add(original.first); // fake last
    return looped;
  }

  Widget _buildSliderImage(String? imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: FadeInImage(
          placeholder: const AssetImage('assets/images/default.jpg'),
          image: NetworkImage(imageUrl ?? ''),
          fit: BoxFit.cover,
          height: size.height * 0.4,
          width: double.infinity,
          imageErrorBuilder: (_, __, ___) => Image.asset(
            'assets/images/default.jpg',
            fit: BoxFit.cover,
            height: size.height * 0.4,
            width: double.infinity,
          ),
        ),
      ),
    );
  }

  Widget _buildDotIndicator(int count) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (index) => AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          margin: const EdgeInsets.symmetric(horizontal: 4.0),
          width: _currentPage - 1 == index ? 20.0 : 8.0,
          height: 8.0,
          decoration: BoxDecoration(
            color: _currentPage - 1 == index
                ? AppTheme.blueColor
                : const Color(0xFF34306F),
            borderRadius: BorderRadius.circular(30),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultSlider() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(10.0)),
        child: Image.asset(
          'assets/images/default.jpg',
          height: MediaQuery.sizeOf(context).height * 0.2,
          width: MediaQuery.sizeOf(context).width * 0.98,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlidersCubit, SlidersState>(
      builder: (context, state) {
        if (state is SlidersLoading) {
          return dummy();
        } else if (state is SlidersLoaded) {
          List<SliderList> slidersList = state.sliders;
          if (slidersList.isEmpty) return _buildDefaultSlider();

          final sliders = _getLoopedList(slidersList);
          return Column(
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
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        sliders[_currentPage].location.toString().toUpperCase(),
                        key: ValueKey(sliders[_currentPage].location),
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        sliders[_currentPage].title.toString(),
                        key: ValueKey(sliders[_currentPage].title),
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const SizedBox(height: 5),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 500),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        sliders[_currentPage].subTitle.toString(),
                        key: ValueKey(sliders[_currentPage].subTitle),
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
                  itemCount: sliders.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });
                    if (index == sliders.length - 1) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _pageController.jumpToPage(1);
                      });
                    } else if (index == 0) {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        _pageController.jumpToPage(sliders.length - 2);
                      });
                    }
                  },
                  itemBuilder: (context, index) =>
                      _buildSliderImage(sliders[index].image),
                ),
              ),
              SizedBox(height: 5.h),
              _buildDotIndicator(slidersList.length),
              // SizedBox(
              //   height: size.height * 0.38,
              //   child: PageView.builder(
              //     controller: _pageController,
              //     itemCount: slidersList.length,
              //     onPageChanged: (index) {
              //       setState(() {
              //         _currentPage = index;
              //       });
              //     },
              //     itemBuilder: (context, index) {
              //       return Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 25),
              //         child: ClipRRect(
              //             borderRadius: BorderRadius.circular(50),
              //             child: FadeInImage(
              //                 height: size.height * 0.4,
              //                 width: double.infinity,
              //                 fit: BoxFit.cover,
              //                 imageErrorBuilder: (_, child, stackTrack) =>
              //                     Image.asset('assets/images/default.jpg',
              //                         height: size.height * 0.4,
              //                         width: double.infinity,
              //                         fit: BoxFit.cover),
              //                 image: NetworkImage(
              //                     slidersList[index].image.toString()),
              //                 placeholder: const AssetImage(
              //                     'assets/images/default.jpg'))),
              //       );
              //     },
              //   ),
              // ),
              // SizedBox(height: 10.h),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: List.generate(
              //     slidersList.length,
              //     (index) => AnimatedContainer(
              //       duration: const Duration(milliseconds: 500),
              //       margin: const EdgeInsets.symmetric(horizontal: 4.0),
              //       width: _currentPage == index ? 20.0 : 8.0,
              //       height: _currentPage == index ? 8.0 : 8.0,
              //       decoration: BoxDecoration(
              //           color: _currentPage == index
              //               ? AppTheme.primaryColor
              //               : const Color(0xFF34306F),
              //           borderRadius: BorderRadius.circular(30)
              //           // shape: BoxShape.circle,
              //           ),
              //     ),
              //   ),
              // ),
              SizedBox(height: 20.h),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    LocalStorage.localStorage.setString('onboarding', 'true');
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (builder) => const SelectSocietyScreen()));
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 15),
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
          );
        } else if (state is SlidersFailed) {
          return dummy();
        } else if (state is SlidersInternetError) {
          return dummy();
        }
        return dummy();
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
                Image.asset(ImageAssets.roundLogo, height: size.height * 0.13),
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
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 14,
                      fontWeight: FontWeight.w500),
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
                    child: Text(
                      'Skip To Main Content ',
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: AppTheme.primaryColor,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.h),
        ],
      );
}
