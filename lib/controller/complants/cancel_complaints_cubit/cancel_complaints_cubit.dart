import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart' as http;

part 'cancel_complaints_state.dart';

class CancelComplaintsCubit extends Cubit<CancelComplaintsState> {
  CancelComplaintsCubit() : super(CancelComplaintsInitial());
  ApiManager apiManager = ApiManager();

  Future<void> cancelComplaints({
    required String? complaintsId,
  }) async {
    emit(CancelComplaintsLoading());

    try {
      var token = LocalStorage.localStorage.getString('token');
      if (token == null) {
        emit(CancelComplaintsFailed());
        return;
      }
      final request = http.MultipartRequest(
          'POST', Uri.parse(Config.baseURL + Routes.cancelComplaints))
        ..headers['Authorization'] = 'Bearer $token'
        ..headers['Accept'] = 'application/json'
        ..fields['complaint_id'] = complaintsId ?? '';
      // Send the request
      final responseStream = await request.send();
      var response = await http.Response.fromStream(responseStream);
      var data = json.decode(response.body.toString());
      print(data);
      if (response.statusCode == 200) {
        emit(CancelComplaintsSuccessfully());
      } else if (response.statusCode == 401) {
        emit(CancelComplaintsLogout());
      } else {
        emit(CancelComplaintsFailed());
      }
    } on SocketException {
      emit(CancelComplaintsInternetError());
    } catch (e) {
      emit(CancelComplaintsFailed());
    }
  }
}
