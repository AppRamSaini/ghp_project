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
      final url = forStaffSide
          ? "${Config.baseURL}${Routes.dailyHelpsStaffSide}"
          : "${Config.baseURL}${Routes.dailyHelpsMembers(propertyId.toString())}";

      final response = await apiManager.getRequest(url);
      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          final List<DailyHelp> newDailyHelpList =
              (responseData['data']['daily_help'] as List)
                  .map((e) => DailyHelp.fromJson(e))
                  .toList();

          dailyHelpMemberList = newDailyHelpList;
          emit(
              DailyHelpListingLoaded(dailyHelpMemberList: dailyHelpMemberList));
        } else {
          // Server returned false status
          emit(DailyHelpListingError(
              errorMsg: responseData['message'] ??
                  "Something went wrong, please try again."));
        }
      } else if (response.statusCode == 401) {
        emit(UnAuthenticatedUser());
      } else {
        // Other status codes
        emit(DailyHelpListingError(
            errorMsg: responseData['message'] ??
                "Server error (${response.statusCode})"));
      }
    } on SocketException {
      emit(DailyHelpListingError(
          errorMsg:
              "No Internet connection. Please check your network and try again."));
    } on FormatException {
      emit(DailyHelpListingError(
          errorMsg:
              "Data parsing error. Please try again later or contact support."));
    } catch (e) {
      emit(DailyHelpListingError(
          errorMsg:
              "An unexpected error occurred. Please try again later.\nError: ${e.toString()}"));
    }
  }

  /// Search functionality
  void searchQueryData(String query) {
    if (query.isEmpty) {
      emit(DailyHelpListingLoaded(dailyHelpMemberList: dailyHelpMemberList));
      return;
    }

    final List<DailyHelp> filteredList = dailyHelpMemberList.where((event) {
      return event.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(DailyHelpListingSearchLoaded(dailyHelpMemberList: filteredList));
  }
}
