import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/controller/service_providers/service_providers_cubit.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:searchbar_animation/searchbar_animation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'service_request_screen.dart';

class ServiceProviderDetailScreen extends StatefulWidget {
  final String categoryId;

  const ServiceProviderDetailScreen({super.key, required this.categoryId});

  @override
  State<ServiceProviderDetailScreen> createState() =>
      _ServiceProviderDetailScreenState();
}

class _ServiceProviderDetailScreenState
    extends State<ServiceProviderDetailScreen> {
  TextEditingController textController = TextEditingController();
  bool searchBarOpen = false;

  @override
  void initState() {
    context
        .read<ServiceProvidersCubit>()
        .fetchServiceProviders(widget.categoryId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ServiceProvidersCubit, ServiceProvidersState>(
      listener: (context, state) {
        if (state is ServiceProvidersLogout) {
          sessionExpiredDialog(context);
        }
      },
      child: Scaffold(
        appBar: customAppbar(
          context: context,
          title: 'Service providers',
          textController: textController,
          searchBarOpen: searchBarOpen,
          onExpansionComplete: () {
            setState(() {
              searchBarOpen = true;
            });
          },
          onCollapseComplete: () {
            setState(() {
              searchBarOpen = false;
              context
                  .read<ServiceProvidersCubit>()
                  .fetchServiceProviders(widget.categoryId);
              textController.clear();
            });
          },
          onPressButton: (isSearchBarOpens) {
            setState(() {
              searchBarOpen = true;
            });
          },
          onChanged: (value) {
            context.read<ServiceProvidersCubit>().searchServiceProvider(value);
          },
        ),
        body: BlocBuilder<ServiceProvidersCubit, ServiceProvidersState>(
          builder: (context, state) {
            if (state is ServiceProvidersLoaded) {
              List listData = state.serviceProviders;
              if (listData.isEmpty) {
                return const Center(
                    child: Text('Service Provider Not Found!',
                        style: TextStyle(color: Colors.deepPurpleAccent)));
              }

              return ListView.builder(
                  padding: const EdgeInsets.only(top: 10),
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: state
                      .serviceProviders.first.data.serviceProviders.data.length,
                  shrinkWrap: true,
                  itemBuilder: ((context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () {
                          // Navigator.of(context).push(
                          //     MaterialPageRoute(
                          //         builder: (builder) =>
                          //             ServiceRequestScreen(
                          //               categoryId: widget.categoryId,
                          //               serviceProviderUserId: state
                          //                   .serviceProviders
                          //                   .first
                          //                   .data
                          //                   .serviceProviders
                          //                   .data[index]
                          //                   .userId
                          //                   .toString(),
                          //             )));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.grey[300]!)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Image.asset(ImageAssets.serviceDetailImage,
                                        height: 60.h),
                                    SizedBox(width: 10.w),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                              state
                                                  .serviceProviders
                                                  .first
                                                  .data
                                                  .serviceProviders
                                                  .data[index]
                                                  .name,
                                              style: GoogleFonts.nunitoSans(
                                                textStyle: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              )),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 3),
                                            child: Row(
                                              children: [
                                                Icon(Icons.call_outlined,
                                                    size: 15,
                                                    color:
                                                        AppTheme.primaryColor),
                                                Text(
                                                    state
                                                        .serviceProviders
                                                        .first
                                                        .data
                                                        .serviceProviders
                                                        .data[index]
                                                        .phone,
                                                    style: GoogleFonts.ptSans(
                                                      textStyle: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w400,
                                                      ),
                                                    )),
                                              ],
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              Icon(Icons.email_outlined,
                                                  size: 15,
                                                  color: AppTheme.primaryColor),
                                              Text(
                                                  state
                                                      .serviceProviders
                                                      .first
                                                      .data
                                                      .serviceProviders
                                                      .data[index]
                                                      .email,
                                                  style: GoogleFonts.ptSans(
                                                    textStyle: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 10.w),
                                    GestureDetector(
                                      onTap: () async {
                                        final call = Uri.parse(
                                            'tel:${state.serviceProviders.first.data.serviceProviders.data[index].phone}');
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
                                              BorderRadius.circular(1000.r),
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
                                const Divider(thickness: 0.3),
                                Row(
                                  children: [
                                    const Text("Location : ",
                                        style: TextStyle(color: Colors.black)),
                                    Text(
                                        state
                                            .serviceProviders
                                            .first
                                            .data
                                            .serviceProviders
                                            .data[index]
                                            .address,
                                        maxLines: 2,
                                        style: GoogleFonts.nunitoSans(
                                          textStyle: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12.sp,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        )),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }));
            } else if (state is ServiceProvidersSearchLoaded) {
              if (state.serviceProviders.isEmpty) {
                return const Center(
                    child: Text('Service Provider Not Found!',
                        style: TextStyle(color: Colors.deepPurpleAccent)));
              }

              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.serviceProviders.length,
                shrinkWrap: true,
                itemBuilder: ((context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        // Navigator.of(context).push(
                        //     MaterialPageRoute(
                        //         builder: (builder) =>
                        //             ServiceRequestScreen(
                        //               categoryId: widget.categoryId,
                        //               serviceProviderUserId: state
                        //                   .serviceProviders[index]
                        //                   .userId
                        //                   .toString(),
                        //             )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.grey[300]!)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Image.asset(
                                    ImageAssets.serviceDetailImage,
                                    height: 60.h,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(state.serviceProviders[index].name,
                                            style: GoogleFonts.nunitoSans(
                                              textStyle: TextStyle(
                                                color: Colors.black,
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            )),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 3),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.call_outlined,
                                                size: 15.sp,
                                                color: AppTheme.primaryColor,
                                              ),
                                              Text(
                                                  state.serviceProviders[index]
                                                      .phone,
                                                  style: GoogleFonts.ptSans(
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
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.email_outlined,
                                              size: 15.sp,
                                              color: AppTheme.primaryColor,
                                            ),
                                            Text(
                                                state.serviceProviders[index]
                                                    .email,
                                                style: GoogleFonts.ptSans(
                                                  textStyle: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12.sp,
                                                    fontWeight: FontWeight.w400,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final call = Uri.parse(
                                          'tel:${state.serviceProviders[index].phone}');
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
                                            BorderRadius.circular(1000.r),
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
                              const Divider(
                                thickness: 0.3,
                              ),
                              Row(
                                children: [
                                  const Text("Location : ",
                                      style: TextStyle(color: Colors.black)),
                                  Text(
                                    state.serviceProviders[index].address,
                                    maxLines: 2,
                                    style: GoogleFonts.nunitoSans(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              );
            } else if (state is ServiceProvidersFailed) {
              return Padding(
                  padding: const EdgeInsets.all(15),
                  child: Center(
                      child: Text(state.errorMsg.toString(),
                          style: const TextStyle(
                              color: Colors
                                  .deepPurpleAccent)))); // Handle error state
            } else if (state is ServiceProvidersLoading) {
              return const Center(
                  child: CircularProgressIndicator.adaptive(
                      backgroundColor:
                          Colors.deepPurpleAccent)); // Handle error state
            } else if (state is ServiceProvidersInternetError) {
              return const Center(
                  child: Text('Internet connection error',
                      style: TextStyle(
                          color: Colors.red))); // Handle internet error
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
