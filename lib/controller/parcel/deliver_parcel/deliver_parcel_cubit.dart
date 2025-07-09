import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'deliver_parcel_state.dart';

class DeliverParcelCubit extends Cubit<DeliverParcelState> {
  DeliverParcelCubit() : super(DeliverParcelInitial());
  ApiManager apiManager = ApiManager();

  deliverParcelAPI(parcelBody) async {
    emit(DeliverParcelLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          parcelBody,
          Config.baseURL + Routes.deliverParcel,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var resData = json.decode(responseData.body.toString());

      if (responseData.statusCode == 200) {
        if (resData['status']) {
          emit(DeliverParcelSuccess(successMsg: resData['message'].toString()));
        } else {
          emit(DeliverParcelFailed(errorMsg: resData['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(DeliverParcelLogout());
      } else {
        emit(DeliverParcelFailed(errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(DeliverParcelInternetError(errorMsg: "Internet connection failed!"));
    } catch (e) {
      emit(DeliverParcelFailed(errorMsg: "Error ${e.toString()}"));
    }
  }
}
