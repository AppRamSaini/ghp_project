import 'dart:convert';
import 'dart:io';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/property_listing_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'property_listing_state.dart';

class PropertyListingCubit extends Cubit<PropertyListingState> {
  PropertyListingCubit() : super(PropertyListingInitial());

  final ApiManager apiManager = ApiManager();
  Future<void> propertyListApi() async {
    final societyId = LocalStorage.localStorage.getString('societyId');

    emit(PropertyListingLoading());
    try {
      final response = await apiManager.getRequest("${Routes.propertyListing}/$societyId");

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final propertyData = PropertyListingModel.fromJson(jsonResponse);


        print('-------->>>>>>>>>$propertyData');
        if (propertyData.status == true) {
          emit(PropertyListingLoaded(propertyList: propertyData));
        } else {
          emit(PropertyListingError(errorMsg: propertyData.message.toString()));
        }
      } else {
        emit(PropertyListingError(errorMsg: "Something went wrong!"));
      }
    } on SocketException {
      emit(PropertyListingError(errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(PropertyListingError(errorMsg: "Error - ${e.toString()}"));
    }
  }

  // searchQueryData(String query) {
  //   emit(PropertyListingLoaded(dailyHelpMemberList: dailyHelpMemberList));
  //   final List<DailyHelp> filteredList = dailyHelpMemberList.where((event) {
  //     return event.name!.toLowerCase().contains(query.toLowerCase());
  //   }).toList();
  //   emit(PropertyListingSearchLoaded(dailyHelpMemberList: filteredList));
  // }
}
