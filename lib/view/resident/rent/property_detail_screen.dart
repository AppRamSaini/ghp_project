import 'package:ghp_society_management/constants/export.dart';
import 'package:intl/intl.dart';

class BuyPropertyDetailScreen extends StatefulWidget {
  final String propertyId;

  const BuyPropertyDetailScreen({super.key, required this.propertyId});

  @override
  State<BuyPropertyDetailScreen> createState() =>
      _BuyPropertyDetailScreenState();
}

class _BuyPropertyDetailScreenState extends State<BuyPropertyDetailScreen> {
  late PropertyDetailsCubit _propertyDetailsCubit;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _propertyDetailsCubit = PropertyDetailsCubit()
      ..fetchProperty(id: widget.propertyId.toString());
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Property Details'),
      bottomNavigationBar:
          BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
              bloc: _propertyDetailsCubit, // Attach cubit
              builder: (context, state) {
                if (state is PropertyDetailsLoaded) {
                  var propertyDetails = state.detailsList.first;
                  return Container(
                    color: Colors.white,
                    child: GestureDetector(
                      onTap: () =>
                          phoneCallLauncher(propertyDetails.phone.toString()),
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        width: double.infinity,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppTheme.primaryColor),
                        child: Center(
                          child: Text('Contact Owner ',
                              style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              )),
                        ),
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }),
      body: BlocBuilder<PropertyDetailsCubit, PropertyDetailsState>(
        bloc: _propertyDetailsCubit, // Attach cubit
        builder: (context, state) {
          if (state is PropertyDetailsLoading) {
            return const Center(
                child: CircularProgressIndicator.adaptive(
                    backgroundColor: Colors.deepPurpleAccent));
          } else if (state is PropertyDetailsLoaded) {
            var propertyDetails = state.detailsList.first;
            List fileList = propertyDetails.files!;

            String newFormattedDate = DateFormat('d-MMMM-yyyy').format(
                DateTime.parse(propertyDetails.availableFromDate.toString()));

            return SingleChildScrollView(
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.bottomCenter,
                    children: [
                      SizedBox(
                        height: 250.h,
                        child: propertyDetails.files!.isNotEmpty
                            ? PageView.builder(
                                controller: _pageController,
                                itemCount: propertyDetails.files!.length,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                itemBuilder: (context, index) {
                                  return FadeInImage(
                                      height: 180.h,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      imageErrorBuilder:
                                          (_, child, stackTrack) => Image.asset(
                                              'assets/images/default.jpg',
                                              height: 180.h,
                                              width: double.infinity,
                                              fit: BoxFit.cover),
                                      image: NetworkImage(fileList.isNotEmpty
                                          ? propertyDetails.files![index].file
                                              .toString()
                                          : ''),
                                      placeholder: const AssetImage(
                                          'assets/images/default.jpg'));
                                },
                              )
                            : FadeInImage(
                                height: 180.h,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                imageErrorBuilder: (_, child, stackTrack) =>
                                    Image.asset('assets/images/default.jpg',
                                        height: 180.h,
                                        width: double.infinity,
                                        fit: BoxFit.cover),
                                image: const NetworkImage(''),
                                placeholder: const AssetImage(
                                    'assets/images/default.jpg')),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            propertyDetails.files!.length,
                            (index) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 4.0),
                              width: _currentPage == index ? 20.0 : 10.0,
                              height: _currentPage == index ? 8.0 : 8.0,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: _currentPage == index
                                    ? AppTheme.primaryColor
                                    : const Color(0xFF34306F),
                                shape: BoxShape.rectangle,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(propertyDetails.unitType.toString(),
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )),
                                Text(
                                    'TOWER :  ${propertyDetails.blockName.toString()}   |   FLOOR ${propertyDetails.floor.toString()}',
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    )),
                              ],
                            ),
                            Container(
                              decoration: BoxDecoration(
                                  color: const Color(0xFFF2F1FE),
                                  borderRadius: BorderRadius.circular(10),
                                  border:
                                      Border.all(color: AppTheme.primaryColor)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(propertyDetails.area.toString(),
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )),
                                    Text('Sq.ft',
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: AppTheme.primaryColor,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const Divider(thickness: 0.5),
                        Text('Amenities :',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600))),
                        GridView.builder(
                            itemCount: propertyDetails.amenities!.length ?? 0,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3, mainAxisExtent: 40.h),
                            itemBuilder: (_, index) => Row(
                                  children: [
                                    Image.asset(ImageAssets.bedImage,
                                        height: 20.h),
                                    const SizedBox(width: 8),
                                    Text(
                                        propertyDetails.amenities![index].name
                                            .toString(),
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                  ],
                                )),
                        const Divider(thickness: 0.5),
                        Text('Property Information :',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600))),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Property Type : ",
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500))),
                            Text(propertyDetails.unitType.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("BHK : ",
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500))),
                            Text(propertyDetails.bhk.toString(),
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Rent Breakdown :',
                            style: GoogleFonts.nunitoSans(
                                textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600))),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                propertyDetails.type.toString() == 'rent'
                                    ? 'Monthly Rent'
                                    : "House price",
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500))),
                            Text(
                                propertyDetails.type.toString() == 'rent'
                                    ? '₹${double.parse(propertyDetails.rentPerMonth.toString()).toInt()}'
                                    : '₹${double.parse(propertyDetails.housePrice.toString()).toInt()}',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                propertyDetails.type.toString() == 'rent'
                                    ? 'Security Deposit'
                                    : 'UpFront Price',
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500))),
                            Text(
                                propertyDetails.type.toString() == 'rent'
                                    ? '₹${double.parse(propertyDetails.securityDeposit.toString()).toInt()}'
                                    : '₹${double.parse(propertyDetails.upfront.toString()).toInt()}',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 13.sp,
                                  fontWeight: FontWeight.w600,
                                )),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Available from date",
                                style: GoogleFonts.nunitoSans(
                                    textStyle: TextStyle(
                                        color: Colors.black,
                                        fontSize: 13.sp,
                                        fontWeight: FontWeight.w500))),
                            Text(newFormattedDate,
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                        SizedBox(height: 20.h),
                        Text('Owner’s Information :',
                            style: GoogleFonts.nunitoSans(
                              textStyle: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            )),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Owner Name',
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Text(propertyDetails.name.toString(),
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phone Number ',
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Text('+91 ${propertyDetails.phone.toString()}',
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                        SizedBox(height: 10.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Email',
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w500,
                                  ),
                                )),
                            Text(propertyDetails.email.toString(),
                                style: GoogleFonts.nunitoSans(
                                  textStyle: TextStyle(
                                    color: Colors.black,
                                    fontSize: 13.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (state is PropertyDetailsFailed) {
            return Center(
                child: Text(state.errorMdg.toString(),
                    style: const TextStyle(
                        color: Colors.deepPurpleAccent))); // Handle error state
          } else if (state is PropertyDetailsInternetError) {
            return Center(
                child: Text(state.errorMdg.toString(),
                    style: const TextStyle(
                        color: Colors.red))); // Handle internet error
          }
          return Container(); // Return empty container if no state matches
        },
      ),
    );
  }
}
