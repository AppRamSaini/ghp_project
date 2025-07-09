import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/parcel_listing_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'parcel_listing_state.dart';

class ParcelListingCubit extends Cubit<ParcelListingState> {
  ParcelListingCubit() : super(ParcelListingInitial());
  ApiManager apiManager = ApiManager();
  List<ParcelListing> parcelListing = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// for get all parcels
  fetchParcelListingApi(String type, {bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return; // Prevent duplicate calls
      isLoadingMore = true;
      emit(NotificationListingLoadingMore());
    } else {
      currentPage = 1;
      parcelListing.clear();
      emit(ParcelListingLoading());
    }

    try {
      var response = await apiManager
          .getRequest("${Config.baseURL + Routes.getAllParcel}$type");
      var responseData = jsonDecode(response.body);

      print(response.statusCode);

      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newParcels = (responseData['data']['parcels']['data'] as List)
              .map((e) => ParcelListing.fromJson(e))
              .toList();

          currentPage = responseData['data']['parcels']['current_page'];
          final int lastPage = responseData['data']['parcels']['last_page'];

          hasMore = currentPage < lastPage;

          if (loadMore) {
            parcelListing.addAll(newParcels);
          } else {
            parcelListing = newParcels;
          }

          emit(ParcelListingLoaded(
              parcelListing: parcelListing,
              currentPage: currentPage,
              hasMore: hasMore));
        } else {
          emit(ParcelListingFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(ParcelListingLogout());
      } else {
        emit(ParcelListingFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(ParcelListingInternetError(errorMsg: "Internet connection Failed!"));
    } catch (e) {
      emit(ParcelListingFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load More Notifications
  void loadMoreParcels(String type) {
    if (state is ParcelListingLoaded && hasMore) {
      fetchParcelListingApi(type, loadMore: true);
    }
  }
}
