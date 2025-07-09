import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/parcel_details_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'parcel_details_state.dart';

class ParcelDetailsCubit extends Cubit<ParcelDetailsState> {
  ParcelDetailsCubit() : super(ParcelDetailsInitial());
  ApiManager apiManager = ApiManager();

  /// for get all parcels
  fetchParcelDetailsApi(String parcelId) async {
    try {
      emit(ParcelDetailsLoading());
      var response = await apiManager
          .getRequest("${Config.baseURL + Routes.parcelDetails}$parcelId");
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newParcels = (responseData['data']['parcel'] as List)
              .map((e) => ParcelDetails.fromJson(e))
              .toList();
          emit(ParcelDetailsLoaded(parcelDetails: newParcels));
        } else {
          emit(ParcelDetailsFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(ParcelDetailsLogout());
      } else {
        emit(ParcelDetailsFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(ParcelDetailsInternetError(errorMsg: "Internet connection Failed!"));
    } catch (e) {
      emit(ParcelDetailsFailed(errorMsg: e.toString()));
    }
  }
}
