import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'delete_property_state.dart';

class DeletePropertyCubit extends Cubit<DeletePropertyState> {
  DeletePropertyCubit() : super(DeletePropertyInitial());
  ApiManager apiManager = ApiManager();

  /// delete  property api
  deletePropertyAPI(String id) async {
    emit(DeletePropertyLoading());
    try {
      var response = await apiManager.deleteRequest(
          "${Config.baseURL + Routes.deleteRentSellProperty}$id");
      var responseData = jsonDecode(response.body);

      print(responseData);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          emit(DeletePropertySuccessfully(
              successMsg: responseData['message'].toString()));
        } else {
          emit(DeletePropertyFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(DeletePropertyLogout());
      } else {
        emit(
            DeletePropertyFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(DeletePropertyInternetError(errorMsg: 'Internet connection error!'));
    } catch (e) {
      emit(DeletePropertyFailed(errorMsg: e.toString()));
    }
  }
}
