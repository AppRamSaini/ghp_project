import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import '../../../model/buy_or_rent_property_model.dart';

part 'buy_or_rent_property_state.dart';

class BuyRentPropertyCubit extends Cubit<BuyRentPropertyState> {
  BuyRentPropertyCubit() : super(BuyRentPropertyInitial());

  ApiManager apiManager = ApiManager();
  List<PropertyList> propertyList = []; // Datum represents individual bills
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// FETCH MY properyies
  Future<void> fetchProperty(
      {String? propertyType, String? type, bool loadMore = false}) async {
    if (isLoadingMore || !hasMore) {
      isLoadingMore = true;
      emit(BuyRentPropertyLoadingMore());
    } else {
      currentPage = 1;
      propertyList.clear();
      emit(BuyRentPropertyLoading());
    }

    String url() {
      if (propertyType == 'myProperty') {
        return "${Config.baseURL}${Routes.myListingProperty(type.toString())}$currentPage";
      } else {
        return "${Config.baseURL}${Routes.rentOrSellProperty(type.toString())}$currentPage";
      }
    }

    try {
      // Fetching the response from the API
      var response = await apiManager.getRequest(url());

      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newProperty = (responseData['data']['properties']['data'] as List)
              .map((e) => PropertyList.fromJson(e))
              .toList();
          currentPage = responseData['data']['properties']['current_page'];
          int lastPage = responseData['data']['properties']['last_page'];
          hasMore = currentPage < lastPage;
          if (loadMore) {
            propertyList = newProperty;
          } else {
            propertyList.addAll(newProperty);
          }

          emit(BuyRentPropertyLoaded(
              list: propertyList, currentPage: currentPage, hasMore: hasMore));
        } else {
          emit(BuyRentPropertyFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(BuyRentPropertyLogout());
      } else {
        emit(BuyRentPropertyFailed(
            errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(BuyRentPropertyInternetError(
          errorMsg: "Internet connection error!")); // Handle network issues
    } catch (e) {
      emit(BuyRentPropertyFailed(
          errorMsg: e.toString())); // Handle general errors
    } finally {
      isLoadingMore = false;
    }
  }

  void loadMoreProperty(String type) {
    if (state is BuyRentPropertyLoaded && hasMore) {
      fetchProperty(type: type, loadMore: true); // Load more bills
    }
  }
}
