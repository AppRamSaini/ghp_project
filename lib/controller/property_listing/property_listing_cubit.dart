import 'dart:convert';
import 'dart:io';

import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/property_listing_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'property_listing_state.dart';

class PropertyListingCubit extends Cubit<PropertyListingState> {
  PropertyListingCubit() : super(PropertyListingInitial());

  final ApiManager _apiManager = ApiManager();

  Future<void> fetchPropertyList() async {
    final societyId = LocalStorage.localStorage.getString('societyId');

    emit(PropertyListingLoading());

    try {
      final response =
          await _apiManager.getRequest("${Routes.propertyListing}/$societyId");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final propertyData = PropertyListingModel.fromJson(jsonResponse);

        debugPrint('Property Data Fetched: $propertyData');

        if (propertyData.status == true) {
          emit(PropertyListingLoaded(propertyList: propertyData));
        } else {
          emit(PropertyListingError(
              errorMsg: propertyData.message ?? 'Unknown error occurred'));
        }
      } else {
        emit(PropertyListingError(
            errorMsg: "Something went wrong! [${response.statusCode}]"));
      }
    } on SocketException {
      emit(PropertyListingError(errorMsg: "No Internet Connection."));
    } catch (e) {
      emit(PropertyListingError(errorMsg: "Unexpected Error: ${e.toString()}"));
    }
  }
}
