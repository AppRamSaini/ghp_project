import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/model/daily_help_members_modal.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'daily_help_state.dart';

class DailyHelpListingCubit extends Cubit<DailyHelpListingState> {
  DailyHelpListingCubit() : super(DailyHelpListingInitial());

  final ApiManager apiManager = ApiManager();

  List<DailyHelp> dailyHelpMemberList = [];

  /// Fetch residents checkouts history
  Future<void> fetchDailyHelpsApi({bool forStaffSide = false}) async {
    final propertyId = LocalStorage.localStorage.getString('property_id');

    emit(DailyHelpListingLoading());
    try {
      final response = await apiManager.getRequest(forStaffSide
          ? "${Config.baseURL}${Routes.dailyHelpsStaffSide}"
          : "${Config.baseURL}${Routes.dailyHelpsMembers(propertyId.toString())}");

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          final List<DailyHelp> newCheckoutsHistoryLogs =
              (responseData['data']['daily_help'] as List)
                  .map((e) => DailyHelp.fromJson(e))
                  .toList();
          dailyHelpMemberList = newCheckoutsHistoryLogs;

          emit(
              DailyHelpListingLoaded(dailyHelpMemberList: dailyHelpMemberList));
        } else {
          emit(DailyHelpListingError(errorMsg: responseData['message']));
        }
      } else {
        emit(DailyHelpListingError(errorMsg: responseData['message']));
      }
    } on SocketException {
      emit(DailyHelpListingError(errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(DailyHelpListingError(errorMsg: "Error - ${e.toString()}"));
    }
  }

  searchQueryData(String query) {
    emit(DailyHelpListingLoaded(dailyHelpMemberList: dailyHelpMemberList));
    final List<DailyHelp> filteredList = dailyHelpMemberList.where((event) {
      return event.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(DailyHelpListingSearchLoaded(dailyHelpMemberList: filteredList));
  }
}
