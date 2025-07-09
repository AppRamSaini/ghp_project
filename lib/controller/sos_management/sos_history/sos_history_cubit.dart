import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/sos_history_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';

part 'sos_history_state.dart';

class SosHistoryCubit extends Cubit<SosHistoryState> {
  SosHistoryCubit() : super(SosHistoryInitial());

  ApiManager apiManager = ApiManager();
  List<SosHistoryList> sosHistory = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// Fetch SOS History List
  Future<void> fetchSosHistory(
      {required BuildContext context, bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return; // Prevent duplicate calls
      isLoadingMore = true;
      emit(SosHistoryLoadingMore());
    } else {
      // Start fresh: reset the current page and clear previous data.
      currentPage = 1;
      sosHistory.clear();
      emit(SosHistoryLoading());
    }

    // Calculate the page to request: for load more, use next page.
    int requestedPage = loadMore ? currentPage + 1 : 1;

    try {
      // Make the API call with the requested page.
      var response = await apiManager.getRequest(
        "${Config.baseURL}${Routes.sosHistory}?page=$requestedPage",
      );
      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] ?? false) {
          // Parse the new data.
          var newSosHistory = (responseData['data']['sos']['data'] as List)
              .map((e) => SosHistoryList.fromJson(e))
              .toList();
          print(newSosHistory);

          // Update the current page. If your API returns the current page,
          // you can use that. Otherwise, simply set it to the requestedPage.
          currentPage =
              responseData['data']['sos']['current_page'] ?? requestedPage;

          final int lastPage = responseData['data']['sos']['last_page'];
          hasMore = currentPage < lastPage;

          // Merge data based on whether it's a load more or initial load.
          if (loadMore) {
            sosHistory.addAll(newSosHistory);
          } else {
            sosHistory = newSosHistory;
          }

          emit(SosHistoryLoaded(sosHistoryModel: sosHistory));
        } else {
          emit(SosHistoryFailed(
              errorMsg: responseData['message'] ?? 'Unknown Error'));
        }
      } else if (response.statusCode == 401) {
        sessionExpiredDialog(context);
      } else {
        emit(SosHistoryFailed(
            errorMsg: responseData['message'] ?? 'Unknown Server Error'));
      }
    } on SocketException {
      emit(SosHistoryInternetError(errorMsg: 'No internet connection!'));
    } catch (e) {
      emit(SosHistoryFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load More SOS History
  void loadMoreSosHistory(BuildContext context) {
    if (state is SosHistoryLoaded && hasMore) {
      fetchSosHistory(
        context: context,
        loadMore: true,
      );
    }
  }
}
