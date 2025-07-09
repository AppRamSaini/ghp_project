import 'dart:convert';
import 'dart:io';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/property_details_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'property_details_state.dart';

class PropertyDetailsCubit extends Cubit<PropertyDetailsState> {
  PropertyDetailsCubit() : super(PropertyDetailsInitial());

  ApiManager apiManager = ApiManager();
  List<Property> propertyDetailsList = []; // Datum represents individual bills

  /// FETCH MY BILLS
  Future<void> fetchProperty({String? id}) async {
    if (state is PropertyDetailsLoading) return;
    emit(PropertyDetailsLoading());
    try {
      // Fetching the response from the API
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.propertyDetails}$id");
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newProperty = (responseData['data']['property'] as List)
              .map((e) => Property.fromJson(e))
              .toList();
          propertyDetailsList = newProperty;
          print(
              "-details------------->>>>${propertyDetailsList.first.toString()}");
          emit(PropertyDetailsLoaded(detailsList: propertyDetailsList));
        } else {
          emit(PropertyDetailsFailed(
              errorMdg: responseData['message']
                  .toString())); // Handle failure response
        }
      } else {
        emit(PropertyDetailsFailed(
            errorMdg:
                responseData['message'].toString())); // Handle failure response
      }
    } on SocketException {
      emit(PropertyDetailsInternetError(
          errorMdg: 'Internet connection error!')); // Handle network issues
    } catch (e) {
      emit(PropertyDetailsFailed(
          errorMdg: "Something went wrong!")); // Handle failure response
    }
  }
}
