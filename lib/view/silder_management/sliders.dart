import 'package:carousel_slider/carousel_slider.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/model/sliders_model.dart';

class SlidersManagement extends StatefulWidget {
  const SlidersManagement({super.key});

  @override
  State<SlidersManagement> createState() => _SlidersManagementState();
}

class _SlidersManagementState extends State<SlidersManagement> {
  int _currentPage = 1;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    context.read<SlidersCubit>().fetchSlidersAPI();
    _pageController = PageController(initialPage: _currentPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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

  final CarouselSliderController _controller = CarouselSliderController();

  void onPageChange(int index, CarouselPageChangedReason changeReason) {
    setState(() => _currentPage = index);
  }

  List<Widget> imageSlide(List<SliderList> imgList) => imgList
      .map(
        (item) => Stack(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/default.jpg'),
                image: NetworkImage(item.image ?? ''),
                fit: BoxFit.cover,
                height: MediaQuery.sizeOf(context).height * 0.2,
                width: MediaQuery.sizeOf(context).width * 0.98,
                imageErrorBuilder: (_, __, ___) => Image.asset(
                  'assets/images/default.jpg',
                  fit: BoxFit.cover,
                  height: MediaQuery.sizeOf(context).height * 0.2,
                  width: MediaQuery.sizeOf(context).width * 0.98,
                ),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                  colors: [
                    const Color(0xFF000000),
                    const Color(0xFFBDE0FF).withOpacity(0.05),
                  ],
                ),
              ),
            ),
            titleWidget(imgList)
          ],
        ),
      )
      .toList();

  Widget titleWidget(List<SliderList> imgList) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              imgList[_currentPage].location?.toUpperCase() ?? "",
              style: GoogleFonts.roboto(
                color: Colors.deepPurpleAccent,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              imgList[_currentPage].title ?? "",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              imgList[_currentPage].subTitle ?? "",
              style: GoogleFonts.roboto(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SlidersCubit, SlidersState>(
      builder: (context, state) {
        if (state is SlidersLoading) {
          return Column(
            children: [
              _buildDefaultSlider(),
              SizedBox(height: 5.h),
              _buildDotIndicator(4),
            ],
          );
        } else if (state is SlidersLoaded) {
          final slidersList = state.sliders;
          if (slidersList.isEmpty) return _buildDefaultSlider();

          return Column(
            children: [
              CarouselSlider(
                  items: imageSlide(slidersList),
                  options: CarouselOptions(
                      height: size.height * 0.2,
                      viewportFraction: 0.95,
                      enlargeCenterPage: true,
                      onPageChanged: onPageChange,
                      autoPlay: true),
                  carouselController: _controller),
              SizedBox(height: 5.h),
              _buildDotIndicator(slidersList.length),
            ],
          );
        } else {
          return _buildDefaultSlider();
        }
      },
    );
  }
}
