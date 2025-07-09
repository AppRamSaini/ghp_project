import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'resident_checkout_state.dart';

class ResidentCheckOutCubit extends Cubit<ResidentCheckOutState> {
  ResidentCheckOutCubit() : super(ResidentCheckOutInitial());
  ApiManager apiManager = ApiManager();

  checkOutApi({var statusBody}) async {
    emit(ResidentCheckOutLoading());
    try {
      var token = LocalStorage.localStorage.getString('token');
      var responseData = await apiManager.postRequest(
          statusBody,
          Config.baseURL + Routes.residentCheckOut,
          {'Authorization': 'Bearer $token', 'Accept': 'application/json'});

      var data = json.decode((responseData.body.toString()));
      print("---------->>>>$data");
      print(responseData.statusCode);

      if (responseData.statusCode == 201) {
        if (data['status']) {
          emit(ResidentCheckOutSuccessfully(successMsg: data['message']));
        } else {
          emit(ResidentCheckOutFailed(errorMsg: data['message']));
        }
      } else {
        emit(ResidentCheckOutFailed(errorMsg: data['message']));
      }
    } on SocketException {
      emit(ResidentCheckOutFailed(errorMsg: 'Internet Connection Error!'));
    } catch (e) {
      emit(ResidentCheckOutFailed(errorMsg: "Something Went Wrong!"));
    }
  }
}
