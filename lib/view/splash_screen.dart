import 'dart:async';

import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/parcel/parcel_element/parcel_element_cubit.dart';
import 'package:ghp_society_management/controller/parcel/parcel_pending_counts/parcel_counts_cubit.dart';
import 'package:ghp_society_management/controller/sos_management/sos_element/sos_element_cubit.dart';
import 'package:ghp_society_management/controller/visitors/incoming_request/incoming_request_cubit.dart';
import 'package:ghp_society_management/model/incoming_visitors_request_model.dart';
import 'package:ghp_society_management/view/dashboard/bottom_nav_screen.dart';
import 'package:ghp_society_management/view/maintenance_staff/bottom_nav_screen.dart';
import 'package:ghp_society_management/view/resident/onboarding/onboarding_screen.dart';
import 'package:ghp_society_management/view/resident/visitors/incomming_request.dart';
import 'package:ghp_society_management/view/security_staff/dashboard/bottom_navigation.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _loadInitialData();
    _startTimer();
  }

  void _loadInitialData() {
    context.read<SlidersCubit>().fetchSlidersAPI();
    context.read<SosElementCubit>().fetchSosElement();
    context.read<ParcelCountsCubit>().fetchParcelCounts();
    context.read<VisitorsElementCubit>().fetchVisitorsElement();
    context.read<ParcelElementsCubit>().fetchParcelElement();
  }

  void _startTimer() {
    Future.delayed(const Duration(seconds: 2), () {
      _decideNextScreen();
    });
  }

  void _decideNextScreen() {
    final societyId = LocalStorage.localStorage.getString('societyId');
    final role = LocalStorage.localStorage.getString('role');

    Widget nextScreen;

    if (societyId != null) {
      switch (role) {
        case 'resident':
        case 'admin':
          nextScreen = const Dashboard();
          break;
        case 'staff':
          nextScreen = const StaffDashboard();
          break;
        case 'staff_security_guard':
          nextScreen = SecurityGuardDashboard();
          break;
        default:
          nextScreen = const OnboardingScreen();
      }
    } else {
      nextScreen = const OnboardingScreen();
    }

    if (mounted) {
      _navigateToNextScreen(nextScreen);
    }
  }

  void _navigateToNextScreen(Widget nextScreen) {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => nextScreen),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<IncomingRequestCubit, IncomingRequestState>(
          listener: (context, state) {
            if (state is IncomingRequestLoaded) {
              IncomingVisitorsModel incomingVisitorsRequest =
                  state.incomingVisitorsRequest;
              if (incomingVisitorsRequest.lastCheckinDetail?.status ==
                  'requested') {
                if (ModalRoute.of(context)?.isCurrent ?? false) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VisitorsIncomingRequestPage(
                        incomingVisitorsRequest: incomingVisitorsRequest,
                        fromForegroundMsg: true,
                        setPageValue: (value) {},
                      ),
                    ),
                  );
                }
              }
            }
          },
        ),
      ],
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(8.w),
            child: Image.asset(
              ImageAssets.appLogo,
              height: 120.h,
            ),
          ),
        ),
      ),
    );
  }
}
