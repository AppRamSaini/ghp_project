import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_images.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/dialog.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/complants/cancel_complaints_cubit/cancel_complaints_cubit.dart';
import 'package:ghp_society_management/controller/complants/get_complaints/get_complaints_cubit.dart';
import 'package:ghp_society_management/controller/user_profile/user_profile_cubit.dart';
import 'package:ghp_society_management/model/complaint_service_provider_model.dart';
import 'package:ghp_society_management/model/user_profile_model.dart';
import 'package:ghp_society_management/view/resident/bills/home_bill_section.dart';
import 'package:ghp_society_management/view/resident/complaint/register_complain_screen.dart';
import 'package:ghp_society_management/view/resident/setting/log_out_dialog.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';

class ComplaintCategoryPage extends StatefulWidget {
  const ComplaintCategoryPage({super.key});

  @override
  State<ComplaintCategoryPage> createState() => _ComplaintCategoryPageState();
}

class _ComplaintCategoryPageState extends State<ComplaintCategoryPage> {
  late ComplaintsCubit _complaintsCubit;
  late UserProfileCubit _userProfileCubit;

  @override
  void initState() {
    super.initState();
    _complaintsCubit = ComplaintsCubit()..fetchComplaintsAPI();
    _userProfileCubit = UserProfileCubit();
    _userProfileCubit.fetchUserProfile();
  }

  int selectedIndex = -1;
  BuildContext? dialogueContext;
  List<String> filterTypes = ["All Category", "Complaint History"];
  int selectedFilter = 0;

  void _navigateToRegisterComplaint(BuildContext context, String categoryId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => RegisterComplaintScreen(categoryId: categoryId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ComplaintsCubit, ComplaintsState>(
        listener: (context, state) {
          if (state is ComplaintsLogout) {
            Navigator.of(dialogueContext!).pop();
            sessionExpiredDialog(context);
          }
        },
        child: BlocListener<CancelComplaintsCubit, CancelComplaintsState>(
          listener: (context, state) async {
            if (state is CancelComplaintsLoading) {
              showLoadingDialog(context, (ctx) {
                dialogueContext = ctx;
              });
            } else if (state is CancelComplaintsSuccessfully) {
              snackBar(context, 'Complaints cancel successfully', Icons.done,
                  AppTheme.guestColor);
              _complaintsCubit = ComplaintsCubit()..fetchComplaintsAPI();
              setState(() {});

              Navigator.of(dialogueContext!).pop();
            } else if (state is CancelComplaintsFailed) {
              snackBar(context, 'Failed to Complaints cancel ', Icons.warning,
                  AppTheme.redColor);

              Navigator.of(dialogueContext!).pop();
            } else if (state is CancelComplaintsInternetError) {
              snackBar(context, 'Internet connection failed', Icons.wifi_off,
                  AppTheme.redColor);

              Navigator.of(dialogueContext!).pop();
            } else if (state is CancelComplaintsLogout) {
              Navigator.of(dialogueContext!).pop();
              sessionExpiredDialog(context);
            }
          },
          child: Expanded(
            child: BlocBuilder<ComplaintsCubit, ComplaintsState>(
              bloc: _complaintsCubit,
              builder: (context, state) {
                if (state is ComplaintsLoading) {
                  return notificationShimmerLoading();
                } else if (state is ComplaintsLoaded) {
                  return BlocBuilder<UserProfileCubit, UserProfileState>(
                    bloc: _userProfileCubit,
                    builder: (context, profileState) {
                      if (profileState is UserProfileLoaded) {
                        Future.delayed(const Duration(milliseconds: 5), () {
                          List<UnpaidBill> billData =
                              profileState.userProfile.first.data!.unpaidBills!;
                          if (billData.isNotEmpty) {
                            checkPaymentReminder(
                                context: context,
                                myUnpaidBill: profileState.userProfile.first
                                    .data!.unpaidBills!.first);
                          }
                        });
                      }

                      if (state.complaints.isEmpty) {
                        return emptyDataWidget("Category not found! ");
                      }

                      return ListView.builder(
                        key: Key(selectedIndex.toString()),
                        shrinkWrap: true,
                        itemCount: state.complaints.length,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          List<ComplaintCategory> list = state.complaints;
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, top: 8),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.2))),
                              child: ListTile(
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                leading: Image.asset(
                                    ImageAssets.noticeBoardImage,
                                    height: 40.h),
                                title: Padding(
                                    padding: const EdgeInsets.only(right: 8),
                                    child: Text(list[index].name.toString(),
                                        style: const TextStyle(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500))),
                                trailing: GestureDetector(
                                  onTap: () {
                                    if (profileState is UserProfileLoaded) {
                                      final billData = profileState.userProfile
                                              .first.data?.unpaidBills ??
                                          [];

                                      if (billData.isNotEmpty) {
                                        final status = checkBillStatus(
                                            context, billData.first);

                                        if (status == 'overdue') {
                                          overDueBillAlertDialog(
                                              context, billData.first);
                                        } else {
                                          _navigateToRegisterComplaint(context,
                                              list[index].id.toString());
                                        }
                                      } else {
                                        _navigateToRegisterComplaint(
                                            context, list[index].id.toString());
                                      }
                                    }
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: const Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      child: Text(
                                        'Request',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 12),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                } else if (state is ComplaintsFailed) {
                  return emptyDataWidget(state.errorMsg.toString());
                } else if (state is ComplaintsInternetError) {
                  return const Center(
                      child: Text('Internet connection error',
                          style: TextStyle(color: Colors.red)));
                }
                return Container(); // Default case, return empty container
              },
            ),
          ),
        ));
  }
}
