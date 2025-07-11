import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/view/resident/rent/buy_rent_property_screen.dart';
import 'package:ghp_society_management/view/resident/rent/create_rent_property_screen.dart';
import 'package:ghp_society_management/view/resident/rent/create_sell_property_screen.dart';
import 'package:ghp_society_management/view/resident/rent/manage_existing_property_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class RentScreen extends StatefulWidget {
  const RentScreen({super.key});

  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  List<String> rentCategories = [
    'Rent My Property',
    'Sell My Property',
    'Buy/Rent Property',
    'View/Manage Existing Property'
  ];

  List<String> imagesList = [
    'assets/images/img1.webp',
    'assets/images/img2.webp',
    'assets/images/img3.webp',
    'assets/images/img4.webp',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Rent/Sell Property',
          style: GoogleFonts.nunitoSans(
              textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600)))),
      body: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          itemCount: rentCategories.length,
          shrinkWrap: true,
          itemBuilder: ((context, index) {
            return GestureDetector(
              onTap: () {
                if (index == 0) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) =>
                          const RentPropertyScreen()));
                }
                if (index == 1) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) =>
                          const CreateSellPropertyScreen()));
                }
                if (index == 2) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) =>
                          const BuyPropertyScreen()));
                }
                if (index == 3) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (builder) =>
                          const ManagePropertyScreen()));
                }
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: FadeInImage(
                            height: 160.h,
                            width: double.infinity,
                            fit: BoxFit.fill,
                            imageErrorBuilder:
                                (_, child, stackTrack) => Image.asset(
                                    'assets/images/default.jpg',
                                    height: 160.h,
                                    width: double.infinity,
                                    fit: BoxFit.cover),
                            image: AssetImage(
                                imagesList[index].toString()),
                            placeholder: const AssetImage(
                                'assets/images/default.jpg'))),
                    Container(
                      decoration: BoxDecoration(
                          color: AppTheme.backgroundColor
                              .withOpacity(0.4),
                          borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(10),
                              bottomLeft: Radius.circular(10))),
                      child: ListTile(
                        dense: true,
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 5),
                        title: Text(rentCategories[index],
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        trailing: CircleAvatar(
                          backgroundColor:
                              AppTheme.primaryColor.withOpacity(0.8),
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          })),
    );
  }
}
