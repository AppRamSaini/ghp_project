import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/property_element_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'property_element_state.dart';

class PropertyElementCubit extends Cubit<PropertyElementState> {
  PropertyElementCubit() : super(PropertyElementInitial());
  ApiManager apiManager = ApiManager();
  fetchPropertyElement() async {
    emit(PropertyElementLoading());
    try {
      var responseData = await apiManager
          .getRequest(Config.baseURL + Routes.propertyElement);

      if (responseData.statusCode == 200) {
        var response = PropertyElementModel.fromJson(
            jsonDecode(responseData.body));
        var propertyElementData = response.data;
        print('------->>>${propertyElementData.blocks}');
        emit(PropertyElementLoaded(propertyElementDataList: [propertyElementData]));
      }
    } on SocketException {
      emit(PropertyElementInternetError());

    } catch (e) {
      emit(PropertyElementFailed());
    }
  }
}
