import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/controller/sliders/sliders_cubit.dart';
import 'package:ghp_society_management/main.dart';
import 'package:ghp_society_management/view/silder_management/onboarding_sliders.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
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
        height: size.height,
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage(ImageAssets.bg), fit: BoxFit.fill),
            borderRadius: BorderRadius.circular(20)),
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<SlidersCubit>().fetchSlidersAPI();
            setState(() {});
          },
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(height: size.height * 0.06),
              OnboardingSlidersManagement(),
            ],
          ),
        ),
      ),
    );
  }
}
