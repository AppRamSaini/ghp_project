import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'parcel_complaint_state.dart';

class ParcelComplaintCubit extends Cubit<ParcelComplaintState> {
  ParcelComplaintCubit() : super(ParcelComplaintInitial());
  ApiManager apiManager = ApiManager();

  /// FOR CREATE PARCEL COMPLAINT MANAGEMENT
  createParcelComplaintAPI(parcelBody) async {
    emit(ParcelComplaintLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          parcelBody,
          Config.baseURL + Routes.parcelComplaint,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var resData = json.decode(responseData.body.toString());

      if (responseData.statusCode == 201) {
        if (resData['status']) {
          emit(ParcelComplaintSuccess(
              successMsg: resData['message'].toString()));
        } else {
          emit(ParcelComplaintFailed(errorMsg: resData['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(ParcelComplaintLogout());
      } else {
        emit(ParcelComplaintFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(ParcelComplaintInternetError(
          errorMsg: "Internet connection failed!"));
    } catch (e) {
      print(e);
      emit(ParcelComplaintFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
