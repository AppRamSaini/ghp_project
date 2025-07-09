import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'checkout_parcel_state.dart';

class ParcelCheckoutCubit extends Cubit<ParcelCheckoutState> {
  ParcelCheckoutCubit() : super(ParcelCheckoutInitial());
  ApiManager apiManager = ApiManager();

  checkoutParcelApi(parcelBody) async {
    emit(ParcelCheckoutLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          parcelBody,
          Config.baseURL + Routes.parcelCheckout,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var resData = json.decode(responseData.body.toString());

      if (responseData.statusCode == 200) {
        if (resData['status']) {
          emit(
              ParcelCheckoutSuccess(successMsg: resData['message'].toString()));
        } else {
          emit(ParcelCheckoutFailed(errorMsg: resData['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(ParcelCheckoutLogout());
      } else {
        emit(ParcelCheckoutFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(
          ParcelCheckoutInternetError(errorMsg: "Internet connection failed!"));
    } catch (e) {
      emit(ParcelCheckoutFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
