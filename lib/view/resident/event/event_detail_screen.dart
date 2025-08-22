import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class EventDetailScreen extends StatefulWidget {
  final String title;
  final String description;
  final String date;
  final String time;
  final String image;
  final String subTitle;

  const EventDetailScreen(
      {super.key,
      required this.title,
      required this.description,
      required this.date,
      required this.time,
      required this.subTitle,
      required this.image});

  @override
  State<EventDetailScreen> createState() => _EventDetailScreenState();
}

class _EventDetailScreenState extends State<EventDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Events Details'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CachedNetworkImage(
                imageUrl: widget.image.toString(),
                height: 200.h,
                width: double.infinity,
                fit: BoxFit.cover,
                progressIndicatorBuilder: (context, url, progress) => Center(
                        child: Image.asset(
                      height: 180.h,
                      width: double.infinity,
                      'assets/images/default.jpg',
                      fit: BoxFit.cover,
                    )),
                errorWidget: (context, url, error) => Container(
                    height: 200.h,
                    width: double.infinity,
                    color: Colors.grey[300],
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey[600],
                      size: 50,
                    ))),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Text(widget.title,
                      style: GoogleFonts.nunitoSans(
                          textStyle: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                              fontWeight: FontWeight.w600))),
                  SizedBox(height: 2.h),
                  Text(widget.subTitle,
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black54,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  SizedBox(height: 10.h),
                  const Divider(thickness: 0.5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Image.asset(ImageAssets.calendarImage,
                                height: 15.h),
                            SizedBox(width: 5.w),
                            Text('Date',
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black54,
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600)))
                          ]),
                          Text(widget.date,
                              style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)))
                        ],
                      ),
                      SizedBox(
                          height: 50,
                          child: VerticalDivider(color: Colors.grey[300])),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(children: [
                            Image.asset(ImageAssets.calendarImage,
                                height: 15.h),
                            SizedBox(width: 5.w),
                            Text('Time',
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                )))
                          ]),
                          Text(widget.time,
                              style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                  color: AppTheme.primaryColor,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                        ],
                      ),
                    ],
                  ),
                  const Divider(thickness: 0.5),
                  Text('Description :',
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      )),
                  SizedBox(
                    height: 2.h,
                  ),
                  Text(widget.description,
                      textAlign: TextAlign.justify,
                      style: GoogleFonts.nunitoSans(
                        textStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      )),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
