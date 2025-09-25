import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/view/resident/rent/property_detail_screen.dart';

class BuyPropertyScreen extends StatefulWidget {
  const BuyPropertyScreen({super.key});

  @override
  State<BuyPropertyScreen> createState() => _BuyPropertyScreenState();
}

class _BuyPropertyScreenState extends State<BuyPropertyScreen> {
  int selectedValue = 0;
  final ScrollController _scrollController = ScrollController();
  late BuyRentPropertyCubit _buyRentPropertyCubit;

  @override
  void initState() {
    super.initState();
    _buyRentPropertyCubit = BuyRentPropertyCubit()
      ..fetchProperty(propertyType: 'buyRentProperty', type: 'rent');
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List types = ['rent', 'sell'];

  void _onScroll() {
    // If scrolled to the bottom, attempt to load more bills
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _buyRentPropertyCubit.loadMoreProperty(
          types[selectedValue]); // Load more bills based on current type
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BuyRentPropertyCubit, BuyRentPropertyState>(
      listener: (context, state) {
        if (state is BuyRentPropertyLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: appbarWidget(title: 'Buy/Rent Property'),
        body: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = 0;
                        _buyRentPropertyCubit = BuyRentPropertyCubit()
                          ..fetchProperty(
                              propertyType: 'buyRentProperty', type: 'rent');
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: selectedValue == 0
                                ? AppTheme.primaryColor
                                : Colors.white,
                            border: Border.all(color: AppTheme.primaryColor)),
                        child: Center(
                          child: Text('Rent Property ',
                              style: TextStyle(
                                color: selectedValue == 0
                                    ? Colors.white
                                    : AppTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = 1;
                        _buyRentPropertyCubit = BuyRentPropertyCubit()
                          ..fetchProperty(
                              propertyType: 'buyRentProperty', type: 'sell');
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Container(
                        height: 40,
                        decoration: BoxDecoration(
                          color: selectedValue == 1
                              ? AppTheme.primaryColor
                              : Colors.white,
                          border: Border.all(color: AppTheme.primaryColor),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text('Buy Property ',
                              style: TextStyle(
                                color: selectedValue == 1
                                    ? Colors.white
                                    : AppTheme.primaryColor,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              )),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: BlocBuilder<BuyRentPropertyCubit, BuyRentPropertyState>(
                  bloc: _buyRentPropertyCubit,
                  builder: (context, state) {
                    if (state is BuyRentPropertyLoading &&
                        _buyRentPropertyCubit.propertyList.isEmpty) {
                      return notificationShimmerLoading();
                    }
                    if (state is BuyRentPropertyFailed) {
                      return emptyDataWidget(state.errorMsg);
                    }
                    if (state is BuyRentPropertyInternetError) {
                      return emptyDataWidget(state.errorMsg);
                    }

                    var properyListing = _buyRentPropertyCubit.propertyList;

                    if (properyListing.isEmpty) {
                      return emptyDataWidget('Property Not Found!');
                    }

                    return ListView.builder(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: properyListing.length + 1,
                      shrinkWrap: true,
                      itemBuilder: ((context, index) {
                        if (index == properyListing.length) {
                          return _buyRentPropertyCubit.state
                                  is BuyRentPropertyLoadingMore
                              ? const Padding(
                                  padding: EdgeInsets.all(16.0),
                                  child: Center(
                                      child:
                                          CircularProgressIndicator.adaptive()))
                              : const SizedBox.shrink();
                        }

                        final propertyList = properyListing[index];
                        List imageList = propertyList.files!;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (builder) => BuyPropertyDetailScreen(
                                      propertyId: propertyList.id.toString())));
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.black.withOpacity(0.1)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            child: FadeInImage(
                                              height: 70.h,
                                              width: 70.w,
                                              fit: BoxFit.cover,
                                              imageErrorBuilder: (_, child,
                                                      stackTrack) =>
                                                  Image.asset(
                                                      'assets/images/default.jpg',
                                                      height: 70.h,
                                                      width: 70.w,
                                                      fit: BoxFit.cover),
                                              image: NetworkImage(
                                                  imageList.isNotEmpty
                                                      ? imageList.first.file
                                                          .toString()
                                                      : ''),
                                              placeholder: const AssetImage(
                                                  'assets/images/default.jpg'),
                                            )),
                                        SizedBox(width: 10.w),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          capitalizeWords(
                                                              propertyList
                                                                  .unitType
                                                                  .toString()),
                                                          style: GoogleFonts
                                                              .nunitoSans(
                                                            textStyle:
                                                                TextStyle(
                                                              color:
                                                                  Colors.black,
                                                              fontSize: 14,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          )),
                                                      SizedBox(height: 2.h),
                                                      Row(
                                                        children: [
                                                          Text(
                                                              'TOWER :  ${propertyList.blockName.toString()}   |   FLOOR :  ${propertyList.floor.toString()}',
                                                              style: GoogleFonts
                                                                  .ptSans(
                                                                textStyle:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                ),
                                                              )),
                                                        ],
                                                      ),
                                                      SizedBox(height: 2.h),
                                                    ],
                                                  ),
                                                  GestureDetector(
                                                    onTap: () =>
                                                        phoneCallLauncher(
                                                            propertyList.phone
                                                                .toString()),
                                                    child: const CircleAvatar(
                                                      backgroundColor:
                                                          Colors.blue,
                                                      radius: 18,
                                                      child: Icon(
                                                        Icons.call,
                                                        color: Colors.white,
                                                        size: 16,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Image.asset(
                                                      ImageAssets.bedImage,
                                                      height: 20.h),
                                                  const SizedBox(width: 8),
                                                  Text(
                                                      propertyList.bhk
                                                          .toString(),
                                                      style: GoogleFonts.ptSans(
                                                        textStyle: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                        ),
                                                      )),
                                                  const SizedBox(width: 12),
                                                  Text(
                                                      selectedValue == 0
                                                          ? '₹${double.parse(propertyList.rentPerMonth.toString()).toInt()}/month'
                                                          : '₹${double.parse(propertyList.housePrice.toString()).toInt()}/month',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                      )),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Divider(
                                        color: Colors.grey.withOpacity(0.2)),
                                    Text(
                                        'Owner Info :  ${propertyList.name.toString()}     📞 +91 ${propertyList.phone.toString()}',
                                        style: GoogleFonts.ptSans(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
