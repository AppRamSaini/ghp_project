import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/controller/society_contacts/society_contacts_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class EmergencyContactScreen extends StatefulWidget {
  const EmergencyContactScreen({super.key});
  @override
  State<EmergencyContactScreen> createState() => _EmergencyContactScreenState();
}

class _EmergencyContactScreenState extends State<EmergencyContactScreen> {
  int selectedValue = 0;
  @override
  void initState() {
    context.read<SocietyContactsCubit>().fetchSocietyContacts();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emergency Contacts',
          style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600)))),
      body: BlocBuilder<SocietyContactsCubit, SocietyContactsState>(
                  builder: (context, state) {
      if (state is SocietyContactsLoading) {
        return const Center(
            child: CircularProgressIndicator.adaptive(
                backgroundColor: Colors.deepPurpleAccent));
      } else if (state is SocietyContactsLoaded) {
        return ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            itemCount: state
                .societyContacts.first.data.contacts.length,
            shrinkWrap: true,
            itemBuilder: ((context, index) {
              return Padding(
                padding: const EdgeInsets.all(12),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border:
                          Border.all(color: Colors.grey[300]!)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Image.asset(ImageAssets.settingLogo,
                                height: 45.h),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      state
                                          .societyContacts
                                          .first
                                          .data
                                          .contacts[index]
                                          .name,
                                      style: GoogleFonts
                                          .nunitoSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 15.sp,
                                          fontWeight:
                                              FontWeight.w600,
                                        ),
                                      )),
                                  Text(
                                      'Occupation: ${state.societyContacts.first.data.contacts[index].designation}',
                                      style: GoogleFonts
                                          .nunitoSans(
                                        textStyle: TextStyle(
                                          color: Colors.black,
                                          fontSize: 12.sp,
                                          fontWeight:
                                              FontWeight.w400,
                                        ),
                                      )),
                                ],
                              ),
                            ),
                            SizedBox(width: 10.w),
                            GestureDetector(
                              onTap: () async {
                                final call = Uri.parse(
                                    'tel:${state.societyContacts.first.data.contacts[index].phone}');
                                if (await canLaunchUrl(call)) {
                                  launchUrl(call);
                                } else {
                                  throw 'Could not launch $call';
                                }
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: AppTheme.primaryColor,
                                  borderRadius:
                                      BorderRadius.circular(
                                          1000.r),
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.call,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
      } else if (state is SocietyContactsFailed) {
        return Center(
            child: Text(state.errorMsg.toString(),
                style: const TextStyle(
                    color: Colors.deepPurpleAccent)));
      } else if (state is SocietyContactsInternetError) {
        return const Center(
            child: Text('Internet connection failed',
                style: TextStyle(color: Colors.red)));
      }
      return Container();
                  },
                ),
    );
  }
}
