import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/resident/resident_profile/resident_gatepass.dart';
import 'package:google_fonts/google_fonts.dart';

class HouseholdsViews extends StatefulWidget {
  const HouseholdsViews({super.key});

  @override
  State<HouseholdsViews> createState() => _HouseholdsViewsState();
}

class _HouseholdsViewsState extends State<HouseholdsViews> {
  late UserProfileCubit _userProfileCubit;

  @override
  void initState() {
    super.initState();
    _userProfileCubit = UserProfileCubit();
    _userProfileCubit.fetchUserProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(top: 20.h, left: 6.h, bottom: 20.h),
                child: Row(children: [
                  GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(Icons.arrow_back, color: Colors.white)),
                  SizedBox(width: 10.w),
                  Text('Households',
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600)))
                ])),
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: BlocBuilder<UserProfileCubit, UserProfileState>(
                    bloc: _userProfileCubit,
                    builder: (context, state) {
                      if (state is UserProfileLoading) {
                        return const Center(
                            child: CircularProgressIndicator.adaptive(
                                backgroundColor: Colors.deepPurpleAccent));
                      } else if (state is UserProfileLoaded) {
                        User usersData = state.userProfile.first.data!.user!;
                        return SingleChildScrollView(
                            child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Family Members",
                                        style: GoogleFonts.nunitoSans(
                                            textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w500))),
                                    const SizedBox(height: 10),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          border: Border.all(
                                              color: Colors.grey
                                                  .withOpacity(0.15))),
                                      child: ListTile(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 5),
                                        leading: CircleAvatar(
                                            radius: 30.h,
                                            backgroundImage: NetworkImage(
                                                usersData.image.toString()),
                                            onBackgroundImageError: (error,
                                                    stack) =>
                                                const AssetImage(
                                                    'assets/images/default.jpg')),
                                        title: Text(
                                            capitalizeWords(
                                                usersData.name.toString()),
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16.sp,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        subtitle: Text(
                                            capitalizeWords(
                                                usersData.status.toString()),
                                            style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                    color: Colors.green,
                                                    fontSize: 14.sp,
                                                    fontWeight:
                                                        FontWeight.w500))),
                                        trailing: GestureDetector(
                                          onTap: () => Navigator.of(context)
                                              .push(MaterialPageRoute(
                                                  builder: (builder) =>
                                                      ResidentGatePass(
                                                          residentModel: state
                                                              .userProfile
                                                              .first
                                                              .data!
                                                              .user!))),
                                          child: SizedBox(
                                              height: 100,
                                              width: 80,
                                              child: Image.asset(
                                                  'assets/images/qr-image.png')),
                                        ),
                                      ),
                                    ),
                                  ],
                                )));
                      } else if (state is UserProfileFailed) {
                        return Center(
                            child: Text(state.errorMsg.toString(),
                                style: const TextStyle(
                                    color: Colors.deepPurpleAccent)));
                      } else if (state is UserProfileInternetError) {
                        return const Center(
                            child: Text("Internet connection error",
                                style: TextStyle(color: Colors.red)));
                      } else {
                        return const SizedBox();
                      }
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
