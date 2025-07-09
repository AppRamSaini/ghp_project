import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/get_notification_settings_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'get_notification_settings_state.dart';

class GetNotificationSettingsCubit extends Cubit<GetNotificationSettingsState> {
  GetNotificationSettingsCubit() : super(InitialGetNotificationSettings());
  ApiManager apiManager = ApiManager();
  List<NotificationSetting> notificationSettingsList = [];

  /// FETCH MY BILLS
  Future<void> fetchGetNotificationSettingsAPI() async {
    if (state is GetNotificationSettingsLoading) return;
    emit(GetNotificationSettingsLoading());
    try {
      // Fetching the response from the API
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.getNotificationSettings}");

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Parse the bills data from the response
        var newGetNotificationSettings = (responseData['data']['notification_settings'] as List)
            .map((e) => NotificationSetting.fromJson(e))
            .toList();
        notificationSettingsList
            .addAll(newGetNotificationSettings); // For subsequent pages, append new bills
        // Emit the loaded state with updated bills
        emit(GetNotificationSettingsLoaded(notificationSettings: notificationSettingsList));
      }

      else {
        emit(GetNotificationSettingsFailed(errorMessage: 'Failed to load Notification settings')); // Handle failure response
      }
    } on SocketException {
      emit(GetNotificationSettingsInternetError(errorMessage: "No internet connection.")); // Handle network issues
    } catch (e) {
      emit(GetNotificationSettingsFailed(errorMessage: 'Notification settings Not Found!')); // Handle general errors
    }
  }
}
