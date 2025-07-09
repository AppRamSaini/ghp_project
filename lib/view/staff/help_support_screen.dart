import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/controller/contact/contact_cubit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  List<String> getInTouchTitle = ['Phone Number', 'Email Address'];
  List<String> getInTouchSubTitle = ['+91 809 343 5045', 'dummy2@gmail.com'];

  List<String> getInTouchImages = [
    'assets/images/dial.png',
    'assets/images/mail.png'
  ];

  List<ItemModel> itemData = <ItemModel>[
    ItemModel(
      headerItem: "How do I register for the app?",
      description:
          "Contact your society admin for registration details and download instructions.",
    ),
    ItemModel(
      headerItem: "How will I know if my complaint is resolved?",
      description:
          'You’ll get a notification when it’s resolved, or you can check the complaint status in the "Complaints" section.',
    ),
    ItemModel(
      headerItem: "What should I do if I face technical issues?",
      description:
          'Go to "Help" or "Support" in the app to contact the support team for assistance.',
    ),
  ];

  @override
  void initState() {
    context.read<ContactCubit>().contact(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Help & Support',
              style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600)))),
      body: Expanded(
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
              color: Color(0xFFFBFBFB),
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          child: Padding(
            padding: EdgeInsets.all(12.w),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text('Get In Touch',
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  BlocBuilder<ContactCubit, ContactState>(
                    builder: (context, state) {
                      if (state is Contactsuccessfully) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10.h, bottom: 0.h),
                              child: GestureDetector(
                                onTap: () async {
                                  final call = Uri.parse(
                                      'tel:${state.contact.first.data.contact.phone}');
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    throw 'Could not launch $call';
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.r),
                                      border:
                                          Border.all(color: Colors.grey[300]!)),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    dense: true,
                                    leading: Image.asset(getInTouchImages[0]),
                                    title: Text(
                                      getInTouchTitle[0],
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      state.contact.first.data.contact.phone,
                                      style: GoogleFonts.nunitoSans(
                                        color: const Color(0XFF404040),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: 10.h, bottom: 0.h),
                              child: GestureDetector(
                                onTap: () async {
                                  final call = Uri.parse(
                                      'mailto:${state.contact.first.data.contact.email}');
                                  if (await canLaunchUrl(call)) {
                                    launchUrl(call);
                                  } else {
                                    throw 'Could not launch $call';
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.r),
                                    border:
                                        Border.all(color: Colors.grey[300]!),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    dense: true,
                                    leading: Image.asset(getInTouchImages[1]),
                                    title: Text(
                                      getInTouchTitle[1],
                                      style: GoogleFonts.nunitoSans(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    subtitle: Text(
                                      state.contact.first.data.contact.email,
                                      style: GoogleFonts.nunitoSans(
                                        color: const Color(0XFF404040),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (state is ContactLoading) {
                        return const SizedBox(
                          width: double.infinity,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(),
                            ],
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(child: Text('Contacts not found!')),
                        );
                      }
                    },
                  ),
                  SizedBox(height: 20.h),
                  Text('FAQs',
                      style: GoogleFonts.nunitoSans(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w600)),
                  SizedBox(height: 10.h),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemData.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Theme(
                            data: Theme.of(context)
                                .copyWith(dividerColor: Colors.transparent),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                      color: Colors.blueGrey.withOpacity(0.2))),
                              child: ExpansionTile(
                                collapsedBackgroundColor: Colors.transparent,
                                backgroundColor: Colors.transparent,
                                childrenPadding: EdgeInsets.zero,
                                trailing: Icon(
                                    itemData[index].expanded
                                        ? Icons.expand_less
                                        : Icons.expand_more,
                                    color: Colors.black,
                                    size: 20.sp),
                                title: Text(
                                  itemData[index].headerItem,
                                  style: GoogleFonts.nunitoSans(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                onExpansionChanged: (bool expanded) {
                                  setState(() {
                                    itemData[index].expanded = expanded;
                                  });
                                },
                                initiallyExpanded: itemData[index].expanded,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        bottom: 15, left: 10, right: 10),
                                    child: Text(
                                      itemData[index].description,
                                      style: GoogleFonts.nunitoSans(
                                        color: const Color(0XFF404040),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ItemModel {
  bool expanded;
  String headerItem;
  String description;

  ItemModel({
    this.expanded = false,
    required this.headerItem,
    required this.description,
  });
}
