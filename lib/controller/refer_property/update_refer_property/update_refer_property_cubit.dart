import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'update_refer_property_state.dart';

class UpdateReferPropertyCubit extends Cubit<UpdateReferPropertyState> {
  final ApiManager apiManager = ApiManager();

  UpdateReferPropertyCubit() : super(UpdateReferPropertyInitial());

  /// UPDATE REFER PROPERTY
  Future<void> updateReferProperty(
      String referId, Map<String, dynamic> referPropertyBody) async {
    emit(UpdateReferPropertyLoading());

    try {
      final String? token = LocalStorage.localStorage.getString('token');

      if (token == null) {
        emit(UpdateReferPropertyFailed(
            errorMsg: "Authentication token not found"));
        return;
      }

      final response = await apiManager.postRequest(
        referPropertyBody,
        "${Config.baseURL}${Routes.updateReferProperty}$referId",
        {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      var responseData = json.decode(response.body.toString());

      print("----------->>>>${response.statusCode}");

      if (response.statusCode == 200) {
        final bool status = responseData['status'] ?? false;
        final String message =
            responseData['message']?.toString() ?? "Unknown response";

        if (status) {
          emit(UpdateReferPropertySuccess(successMsg: message));
        } else {
          emit(UpdateReferPropertyFailed(errorMsg: message));
        }
      } else if (responseData.statusCode == 401) {
        emit(UpdateReferPropertyLogout());
      } else {
        emit(UpdateReferPropertyFailed(
            errorMsg: responseData['message']?.toString() ??
                "Unexpected error occurred"));
      }
    } on SocketException {
      emit(UpdateReferPropertyFailed(errorMsg: "No Internet connection"));
    } catch (e) {
      emit(UpdateReferPropertyFailed(errorMsg: "Something went wrong!"));
    }
  }
}
