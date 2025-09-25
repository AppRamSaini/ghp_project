import 'package:carousel_slider/carousel_slider.dart';
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
  int _currentPage = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    // context.read<SlidersCubit>().fetchSlidersAPI();
    _pageController = PageController(initialPage: _currentPage);
  }

  final CarouselSliderController _controller = CarouselSliderController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() => _currentPage = index);
  }

  List<Widget> imageSlide(List<SliderList> imgList) => imgList
      .map(
        (item) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/default.jpg'),
              image: NetworkImage(item.image ?? ''),
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
        ),
      )
      .toList();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlidersCubit, SlidersState>(
      builder: (context, state) {
        if (state is SlidersLoading) {
          return dummy();
        } else if (state is SlidersLoaded) {
          List<SliderList> slidersList = state.sliders;
          if (slidersList.isEmpty) return dummy();
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
                      duration: Duration(milliseconds: 100),
                      transitionBuilder: (child, animation) =>
                          FadeTransition(opacity: animation, child: child),
                      child: Text(
                        slidersList[_currentPage]
                            .location
                            .toString()
                            .toUpperCase(),
                        key: ValueKey(slidersList[_currentPage].location),
                        style: const TextStyle(
                            color: Colors.deepPurpleAccent, fontSize: 16),
                      ),
                    ),
                    SizedBox(height: 8),
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 100),
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
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 100),
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
              CarouselSlider(
                items: imageSlide(slidersList),
                options: CarouselOptions(
                    height: size.height * 0.38,
                    viewportFraction: 0.99,
                    enlargeCenterPage: true,
                    onPageChanged: onPageChange,
                    autoPlay: true),
                carouselController: _controller,
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
