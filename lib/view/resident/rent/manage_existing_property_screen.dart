import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/rent_or_sell_property/delete_property/delete_property_cubit.dart';
import 'package:ghp_society_management/model/buy_or_rent_property_model.dart';
import 'package:ghp_society_management/view/resident/rent/property_detail_screen.dart';
import 'package:ghp_society_management/view/resident/rent/update_rent_property.dart';
import 'package:ghp_society_management/view/resident/rent/update_sell_property.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';

class ManagePropertyScreen extends StatefulWidget {
  const ManagePropertyScreen({super.key});

  @override
  State<ManagePropertyScreen> createState() => _ManagePropertyScreenState();
}

class _ManagePropertyScreenState extends State<ManagePropertyScreen> {
  int selectedValue = 0;
  final ScrollController _scrollController = ScrollController();
  late BuyRentPropertyCubit _buyRentPropertyCubit;

  @override
  void initState() {
    super.initState();
    _buyRentPropertyCubit = BuyRentPropertyCubit()
      ..fetchProperty(propertyType: 'myProperty', type: 'rent');
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  List types = ['rent', 'sell'];

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent < 300) {
      _buyRentPropertyCubit.loadMoreProperty(types[selectedValue]);
    }
  }

  late BuildContext dialogueContext;

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<BuyRentPropertyCubit, BuyRentPropertyState>(
          listener: (context, state) {
            if (state is BuyRentPropertyLogout) {
              sessionExpiredDialog(context);
            }
          },
        ),
        BlocListener<DeletePropertyCubit, DeletePropertyState>(
          listener: (context, state) async {
            if (state is DeletePropertyLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is DeletePropertySuccessfully) {
              snackBar(context, state.successMsg.toString(), Icons.done,
                  AppTheme.guestColor);
              Navigator.of(dialogueContext).pop();
              _buyRentPropertyCubit.fetchProperty(
                  propertyType: 'myProperty',
                  type: types[selectedValue].toString());
            } else if (state is DeletePropertyFailed) {
              snackBar(context, state.errorMsg.toString(), Icons.warning,
                  AppTheme.redColor);

              Navigator.of(dialogueContext).pop();
            } else if (state is DeletePropertyInternetError) {
              snackBar(context, state.errorMsg.toString(), Icons.wifi_off,
                  AppTheme.redColor);

              Navigator.of(dialogueContext).pop();
            }
          },
        )
      ],
      child: Scaffold(
        appBar: AppBar(
            title: Text('View/Manage Existing Property',
                style: GoogleFonts.nunitoSans(
                    textStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600)))),
        body: Column(
          children: [
            SizedBox(height: 10.h),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedValue = 0;
                        _buyRentPropertyCubit = BuyRentPropertyCubit()
                          ..fetchProperty(
                              propertyType: 'myProperty', type: 'rent');
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
                          child: Text('Rent My Property ',
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
                              propertyType: 'myProperty', type: 'sell');
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
                            borderRadius: BorderRadius.circular(20)),
                        child: Center(
                          child: Text('Sell My Property ',
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
                      return const Center(
                          child: CircularProgressIndicator.adaptive());
                    }
                    if (state is BuyRentPropertyFailed) {
                      return Center(
                          child: Text(state.errorMsg,
                              style: const TextStyle(
                                  color: Colors.deepPurpleAccent)));
                    }
                    if (state is BuyRentPropertyInternetError) {
                      return Center(
                          child: Text(state.errorMsg.toString(),
                              style: const TextStyle(color: Colors.red)));
                    }

                    var properyListing = _buyRentPropertyCubit.propertyList;

                    if (properyListing.isEmpty) {
                      return const Center(
                          child: Text('Property Not Found!',
                              style:
                                  TextStyle(color: Colors.deepPurpleAccent)));
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

                        List fileList = propertyList.files!;

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black.withOpacity(0.1)),
                                borderRadius: BorderRadius.circular(10)),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
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
                                        image: NetworkImage(fileList.isNotEmpty
                                            ? propertyList.files!.first.file
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
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                    capitalizeWords(propertyList
                                                        .unitType
                                                        .toString()),
                                                    style: GoogleFonts.ptSans(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    )),
                                                SizedBox(height: 5.h),
                                                Row(
                                                  children: [
                                                    Text(
                                                        'TOWER : ${propertyList.blockName.toString()}   |   FLOOR :  ${propertyList.floor.toString()}',
                                                        style:
                                                            GoogleFonts.ptSans(
                                                          textStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 12,
                                                            fontWeight:
                                                                FontWeight.w500,
                                                          ),
                                                        )),
                                                  ],
                                                ),
                                              ],
                                            ),
                                            actionMenuButtons(
                                                options: optionsList,
                                                propertyList: propertyList,
                                                context: context)
                                          ],
                                        ),
                                        SizedBox(height: 5.h),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Image.asset(ImageAssets.bedImage,
                                                height: 20.h),
                                            const SizedBox(width: 8),
                                            Text(
                                                "${propertyList.bhk.toString()} BHK",
                                                style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                )),
                                            const SizedBox(width: 8),
                                            Flexible(
                                              child: Text(
                                                  selectedValue == 0
                                                      ? '₹${double.parse(propertyList.rentPerMonth.toString()).toInt()}/month'
                                                      : '₹${double.parse(propertyList.housePrice.toString()).toInt()}/month',
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  maxLines: 1,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w500,
                                                  )),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ],
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

  List<Map<String, dynamic>> optionsList = [
    {"icon": Icons.delete, "menu": "Delete", "menu_id": 1},
    {"icon": Icons.edit, "menu": "Update", "menu_id": 2},
    {"icon": Icons.visibility, "menu": "View Details", "menu_id": 3},
  ];

  Widget actionMenuButtons(
      {required List<Map<String, dynamic>> options,
      required BuildContext context,
      required PropertyList propertyList}) {
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.deepPurpleAccent.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: PopupMenuButton(
            elevation: 10,
            padding: EdgeInsets.zero,
            color: Colors.white,
            surfaceTintColor: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0)),
            icon: const Icon(Icons.more_horiz_rounded,
                color: Colors.deepPurpleAccent, size: 18.0),
            offset: const Offset(0, 50),
            itemBuilder: (BuildContext bc) {
              return options
                  .map(
                    (selectedOption) => PopupMenuItem(
                      padding: EdgeInsets.zero,
                      value: selectedOption,
                      child: Padding(
                        padding: EdgeInsets.only(left: 10.w, right: 30),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(selectedOption['icon']),
                                const SizedBox(width: 10),
                                Text(selectedOption['menu'] ?? "",
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontSize: 12.sp,
                                        fontWeight: FontWeight.w400))
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList();
            },
            onSelected: (value) async {
              if (value['menu_id'] == 1) {
                deleteRentSellPropertyDialog(context, () {
                  Navigator.pop(context);
                  context
                      .read<DeletePropertyCubit>()
                      .deletePropertyAPI(propertyList.id.toString());
                });
              } else if (value['menu_id'] == 2) {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => selectedValue == 0
                            ? UpdateRentPropertyScreen(
                                propertyLis: propertyList)
                            : UpdateSellPropertyScreen(
                                propertyLis: propertyList)));
              } else if (value['menu_id'] == 3) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (builder) => BuyPropertyDetailScreen(
                      propertyId: propertyList.id.toString(),
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
