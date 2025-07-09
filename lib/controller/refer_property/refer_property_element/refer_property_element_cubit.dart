import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/refer_property_element_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'refer_property_element_state.dart';

class ReferPropertyElementCubit extends Cubit<ReferPropertyElementState> {
  ReferPropertyElementCubit() : super(ReferPropertyElementInitial());

  ApiManager apiManager = ApiManager();

  fetchReferPropetyElement() async {
    emit(ReferPropertyElementLoading());
    try {
      var responseData = await apiManager
          .getRequest(Config.baseURL + Routes.referPropertyElements);

      if (responseData.statusCode == 200) {
        var decodedList =
            ReferPropertyElementModel.fromJson(jsonDecode(responseData.body));

        emit(ReferPropertyElementLoaded(referPropertyElement: [decodedList]));
      } else if (responseData.statusCode == 401) {
        emit(ReferPropertyElementLogout());
      }
    } on SocketException {
      emit(ReferPropertyElementInternetError());
    } catch (e) {
      print(e);
      emit(ReferPropertyElementFailed());
    }
  }
}
