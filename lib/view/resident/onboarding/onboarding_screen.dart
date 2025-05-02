import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/controller/sliders/sliders_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/silder_management/sliders.dart';
import 'package:ghp_society_management/view/society/select_society_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  late SlidersCubit _slidersCubit;

  @override
  void initState() {
    super.initState();
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
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(toolbarHeight: 0),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImageAssets.bg), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(20)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height*0.085),
            SlidersManagement(forOnBoarding: true),
          ],
        ),
      ),
    );
  }
}
