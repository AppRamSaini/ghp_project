import 'dart:async';

import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/sliders_model.dart';

class SlidersManagement extends StatefulWidget {
  const SlidersManagement({super.key});

  @override
  State<SlidersManagement> createState() => _SlidersManagementState();
}

class _SlidersManagementState extends State<SlidersManagement> {
  int _currentPage = 1;
  late PageController _pageController;
  Timer? _autoScrollTimer;

  @override
  void initState() {
    super.initState();
    context.read<SlidersCubit>().fetchSlidersAPI();
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
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: FadeInImage(
        placeholder: const AssetImage('assets/images/default.jpg'),
        image: NetworkImage(imageUrl ?? ''),
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

  Widget _buildSliderItem(SliderList item) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Stack(
        alignment: Alignment.center,
        children: [
          _buildSliderImage(item.image),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.location?.toUpperCase() ?? "",
                  style: GoogleFonts.roboto(
                    color: Colors.deepPurpleAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  item.title ?? "",
                  style: GoogleFonts.roboto(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  item.subTitle ?? "",
                  style: GoogleFonts.roboto(
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
          return Column(
            children: [
              _buildDefaultSlider(),
              SizedBox(height: 5.h),
              _buildDotIndicator(4),
            ],
          );
        } else if (state is SlidersLoaded) {
          final originalList = state.sliders;
          if (originalList.isEmpty) return _buildDefaultSlider();

          final sliders = _getLoopedList(originalList);

          return Column(
            children: [
              SizedBox(
                height: MediaQuery.sizeOf(context).height * 0.2,
                width: MediaQuery.sizeOf(context).width * 0.98,
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: sliders.length,
                  onPageChanged: (index) {
                    setState(() {
                      _currentPage = index;
                    });

                    // ✅ Handle infinite loop jump
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
                      _buildSliderItem(sliders[index]),
                ),
              ),
              SizedBox(height: 5.h),
              _buildDotIndicator(originalList.length),
            ],
          );
        } else {
          return _buildDefaultSlider();
        }
      },
    );
  }
}
