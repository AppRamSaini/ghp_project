import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/visitors_listing_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:meta/meta.dart';
part 'visitors_state.dart';

class VisitorsListingCubit extends Cubit<VisitorsListingState> {
  VisitorsListingCubit() : super(VisitorsListingInitial());

  ApiManager apiManager = ApiManager();

  List<VisitorsListing> visitorsListing = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;
  String message = '';
  int todayVisitors = 0;
  int pastVisitors = 0;

  /// Fetch Visitors Listing
  Future<void> fetchVisitorsListing({
    required BuildContext context,
    required String search,
    required String toDate,
    required String fromDate,
    String? filterTypes,
    bool loadMore = false,
  }) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return; // Prevent duplicate calls
      isLoadingMore = true;
      emit(ViewVisitorsLoadingMore());
    } else {
      currentPage = 1; // Reset page when fetching new data
      visitorsListing.clear(); // Clear list on fresh load
      emit(VisitorsListingLoading());
    }

    try {
      var response = await apiManager.getRequest(
        "${Config.baseURL}${Routes.visitorsListing(search, toDate, fromDate)}$filterTypes&page=$currentPage",
      );

      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          pastVisitors = responseData['data']['past_visitors_count'] ?? 0;
          todayVisitors = responseData['data']['today_visitors_count'] ?? 0;

          // Process visitor listing data
          var newVisitors = (responseData['data']['visitors']['data'] as List)
              .map((e) => VisitorsListing.fromJson(e))
              .toList();

          final int lastPage = responseData['data']['visitors']['last_page'];
          hasMore = currentPage < lastPage; // Check if more pages exist

          if (loadMore) {
            visitorsListing.addAll(newVisitors); // Append new data
          } else {
            visitorsListing = newVisitors; // Reset data on fresh load
          }

          currentPage++; // Move to next page only after successful fetch

          print("Checking hasMore: $hasMore | Current Page: $currentPage");

          emit(VisitorsListingLoaded(
            visitorsListingModel: visitorsListing,
            currentPage: currentPage,
            pastVisitors: pastVisitors,
            todayVisitors: todayVisitors,
            hasMore: hasMore,
          ));
        } else {
          pastVisitors = responseData['data']['past_visitors_count'] ?? 0;
          todayVisitors = responseData['data']['today_visitors_count'] ?? 0;
          visitorsListing = []; // Reset data if no visitors found
          emit(VisitorsListingLoaded(
            visitorsListingModel: visitorsListing,
            currentPage: currentPage,
            pastVisitors: pastVisitors,
            todayVisitors: todayVisitors,
            hasMore: hasMore,
          ));
        }
      } else if (response.statusCode == 401) {
        sessionExpiredDialog(context);
      } else {
        emit(VisitorsListingFailed(errorMsg: responseData['message']));
      }
    } on SocketException {
      emit(
          VisitorsListingInternetError(errorMsg: 'Internet connection error!'));
    } catch (e) {
      emit(VisitorsListingFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load more visitors
  void loadMoreVisitorsUsers(BuildContext context, String types, String search,
      String fromDate, String toDate) {
    if (state is VisitorsListingLoaded && hasMore) {
      fetchVisitorsListing(
        toDate: toDate,
        fromDate: fromDate,
        search: search,
        context: context,
        filterTypes: types,
        loadMore: true,
      );
    }
  }

  /// search visitors
  searchVisitors(String query) {
    if (query.isEmpty) {
      emit(VisitorsListingLoaded(
          visitorsListingModel: visitorsListing,
          currentPage: currentPage,
          hasMore: hasMore,
          pastVisitors: pastVisitors,
          todayVisitors: todayVisitors));
      return;
    }

    final List<VisitorsListing> filteredList = visitorsListing.where((event) {
      return event.visitorName.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(SearchVisitorLoaded(visitorsListing: filteredList));
  }
}
