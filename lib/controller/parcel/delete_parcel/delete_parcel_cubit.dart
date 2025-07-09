import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/parcel_listing_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'delete_parcel_state.dart';

class ParcelDeletetCubit extends Cubit<ParcelDeletetState> {
  ParcelDeletetCubit() : super(ParcelDeletetInitial());
  ApiManager apiManager = ApiManager();
  List<ParcelListing> parcelListing = [];

  /// for delete parcel
  deleteParcelApi(String parcelID) async {
    try {
      emit(ParcelDeleteLoading());
      var response = await apiManager
          .deleteRequest("${Config.baseURL + Routes.deleteParcel}$parcelID");
      var responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status']) {
          emit(ParcelDeletedSuccess(
              successMsg: responseData['message'].toString()));
        } else {
          emit(ParcelDeletedFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(ParcelDeletetLogout());
      } else {
        emit(ParcelDeletedFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(ParcelDeletetInternetError(errorMsg: "Internet connection Failed!"));
    } catch (e) {
      emit(ParcelDeletedFailed(errorMsg: e.toString()));
    }
  }
}
