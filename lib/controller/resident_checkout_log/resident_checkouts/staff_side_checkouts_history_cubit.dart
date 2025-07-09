import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/resident_checkouts_history_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'staff_side_checkouts_history_state.dart';

class StaffSideResidentCheckoutsHistoryCubit
    extends Cubit<StaffSideResidentCheckoutsHistoryState> {
  StaffSideResidentCheckoutsHistoryCubit()
      : super(StaffSideResidentCheckoutsHistoryInitial());

  final ApiManager apiManager = ApiManager();

  List<ResidentCheckoutsHistoryList> checkoutsHistoryLogs = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// Fetch residents checkouts history
  Future<void> fetchResidentsCheckoutsHistoryApi(
      {bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(StaffSideResidentCheckoutsHistoryLoadingMore());
    } else {
      currentPage = 1;
      checkoutsHistoryLogs.clear();
      emit(StaffSideResidentCheckoutsHistoryLoading());
    }
    try {
      final response = await apiManager.getRequest(
          "${Config.baseURL}${Routes.residentCheckoutsHistory}?page=$currentPage");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          final List<ResidentCheckoutsHistoryList> newCheckoutsHistoryLogs =
              (responseData['data']['checkin_logs']['data'] as List)
                  .map((e) => ResidentCheckoutsHistoryList.fromJson(e))
                  .toList();

          final int lastPage =
              responseData['data']['checkin_logs']['last_page'];
          hasMore = currentPage < lastPage;

          if (loadMore) {
            for (var item in newCheckoutsHistoryLogs) {
              if (!checkoutsHistoryLogs.contains(item)) {
                checkoutsHistoryLogs.add(item);
              }
            }
          } else {
            checkoutsHistoryLogs = newCheckoutsHistoryLogs;
          }
          currentPage++;
          emit(StaffSideResidentCheckoutsHistoryLoaded(
              residentCheckoutsHistoryList: checkoutsHistoryLogs));
        } else {
          emit(StaffSideResidentCheckoutsHistoryError(
              errorMsg: responseData['message']));
        }
      } else {
        emit(StaffSideResidentCheckoutsHistoryError(
            errorMsg: responseData['message']));
      }
    } on SocketException {
      emit(StaffSideResidentCheckoutsHistoryError(
          errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(StaffSideResidentCheckoutsHistoryError(
          errorMsg: "Error - ${e.toString()}"));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load More Notifications
  void loadMoreResidentsCheckoutsHistory() {
    if (state is StaffSideResidentCheckoutsHistoryLoaded && hasMore) {
      fetchResidentsCheckoutsHistoryApi(loadMore: true);
    }
  }

  searchQueryData(String query) {
    emit(StaffSideResidentCheckoutsHistoryLoaded(
        residentCheckoutsHistoryList: checkoutsHistoryLogs));
    final List<ResidentCheckoutsHistoryList> filteredList =
        checkoutsHistoryLogs.where((event) {
      return event.resident!.name!.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(StaffSideResidentCheckoutsHistorySearchLoaded(
        residentCheckoutsHistoryList: filteredList));
  }
}
