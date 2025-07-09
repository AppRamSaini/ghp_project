import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/sos_element_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'sos_element_state.dart';

class SosElementCubit extends Cubit<SosElementState> {
  SosElementCubit() : super(SosElementInitial());

  ApiManager apiManager = ApiManager();
  List<SosElementModel> sosElement = [];

  fetchSosElement() async {
    emit(SosElementLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.sosElement);
      if (responseData.statusCode == 200) {
        var decodedList =
            SosElementModel.fromJson(jsonDecode(responseData.body));
        sosElement = [decodedList];

        emit(SosElementLoaded(sosElement: [decodedList]));
      } else if (responseData.statusCode == 401) {
        emit(SosElementLogout());
      }
    } on SocketException {
      emit(SosElementInternetError());
    } catch (e) {
      emit(SosElementFailed());
    }
  }
}
