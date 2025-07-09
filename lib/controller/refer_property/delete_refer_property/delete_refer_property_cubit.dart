import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/refer_property_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'delete_refer_property_state.dart';

class DeleteReferPropertyCubit extends Cubit<DeleteReferPropertyState> {
  DeleteReferPropertyCubit() : super(DeleteReferPropertyInitial());
  ApiManager apiManager = ApiManager();
  List<ReferPropertyList?> referPropertyList = [];

  /// delete refer property api
  deleteReferPropertyAPI(String referId) async {
    emit(DeleteReferPropertyLoading());
    try {
      var response = await apiManager.deleteRequest(
          "${Config.baseURL + Routes.deleteReferProperty}$referId");
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          emit(DeleteReferPropertySuccess(
              successMsg: responseData['message'].toString()));
        } else {
          emit(DeleteReferPropertyFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(DeleteReferPropertyLogout());
      } else {
        emit(DeleteReferPropertyFailed(
            errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(DeleteReferPropertyInternetError(
          errorMsg: 'Internet connection error!'));
    } catch (e) {
      emit(DeleteReferPropertyFailed(errorMsg: e.toString()));
    }
  }
}
