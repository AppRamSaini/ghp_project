import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ghp_society_management/constants/app_theme.dart';
import 'package:ghp_society_management/constants/simmer_loading.dart';
import 'package:ghp_society_management/constants/snack_bar.dart';
import 'package:ghp_society_management/controller/notification_settings/get_notification_settings/get_notification_settings_cubit.dart';
import 'package:ghp_society_management/controller/notification_settings/update_notification_settings/update_notification_settings_cubit.dart';
import 'package:ghp_society_management/model/get_notification_settings_model.dart';
import 'package:google_fonts/google_fonts.dart';

class NotificationScreen extends StatefulWidget {
  bool isStaffSide = false;

  NotificationScreen({super.key, this.isStaffSide = false});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  Map<String, bool> toggleStates = {};
  late GetNotificationSettingsCubit _getNotificationSettingsCubit;
  String updateValue = '';
  String updatingSetting = '';

  @override
  void initState() {
    super.initState();
    _getNotificationSettingsCubit = GetNotificationSettingsCubit();
    _getNotificationSettingsCubit.fetchGetNotificationSettingsAPI();
  }

  BuildContext? dialogueContext;

  Future onRefresh() async {
    _getNotificationSettingsCubit.fetchGetNotificationSettingsAPI();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(title: 'Notification Settings'),
      body: BlocListener<UpdateNotificationSettingsCubit,
          UpdateNotificationSettingsState>(
        listener: (context, state) {
          if (state is UpdateNotificationSettingsInternetError) {
            Navigator.of(dialogueContext!).pop();
            snackBar(context, state.errorMessage.toString(), Icons.error,
                AppTheme.redColor);
          }
        },
        child: RefreshIndicator(
          onRefresh: onRefresh,
          child: BlocBuilder<GetNotificationSettingsCubit,
              GetNotificationSettingsState>(
            bloc: _getNotificationSettingsCubit,
            builder: (context, state) {
              if (state is GetNotificationSettingsLoading) {
                return notificationShimmerLoading();
              } else if (state is GetNotificationSettingsLoaded) {
                List<NotificationSetting> data = state.notificationSettings;

                // ✅ Only populate once
                if (toggleStates.isEmpty) {
                  for (var setting in data) {
                    toggleStates[setting.name] = setting.status == "enabled";
                  }
                }

                if (data.isEmpty) {
                  return emptyDataWidget('Notifications data not found!');
                }

                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  itemCount: data.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    String formattedTitle = data[index]
                        .name
                        .replaceAll('_', ' ')
                        .split(' ')
                        .map(
                            (word) => word[0].toUpperCase() + word.substring(1))
                        .join(' ');

                    return _buildSwitchRow(
                      formattedTitle,
                      toggleStates[data[index].name] ?? false,
                      (value) async {
                        final settingName = data[index].name;
                        final newValue = value ? 'enabled' : 'disabled';

                        var bodyData = {
                          "name": settingName,
                          "status": newValue,
                        };

                        // Call API
                        final cubit =
                            context.read<UpdateNotificationSettingsCubit>();
                        final isSuccess =
                            await cubit.updateNotificationSettingsAPI(bodyData);

                        print(isSuccess);

                        if (isSuccess) {
                          setState(() {
                            toggleStates[settingName] =
                                value; // ✅ Only update if success
                          });

                          snackBar(context, "Updated successfully", Icons.done,
                              AppTheme.guestColor);
                        } else {
                          snackBar(context, "Failed to update", Icons.error,
                              AppTheme.redColor);
                        }
                      },
                    );
                  },
                );
              } else if (state is GetNotificationSettingsFailed) {
                return emptyDataWidget(state.errorMessage.toString());
              } else if (state is GetNotificationSettingsInternetError) {
                return Center(
                    child: Text(state.errorMessage.toString(),
                        style: const TextStyle(color: Colors.red)));
              }
              return const SizedBox();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchRow(
      String title, bool switchValue, ValueChanged<bool> onChanged) {
    return Card(
      color: AppTheme.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Text(
                title,
                style: GoogleFonts.nunitoSans(
                  textStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Transform.scale(
              scale: 0.7,
              child: CupertinoSwitch(
                activeColor: AppTheme.primaryColor,
                value: switchValue,
                onChanged: onChanged,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
