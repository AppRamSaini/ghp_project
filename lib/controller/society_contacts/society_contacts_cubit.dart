import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/society_contacts_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'society_contacts_state.dart';

class SocietyContactsCubit extends Cubit<SocietyContactsState> {
  SocietyContactsCubit() : super(SocietyContactsInitial());

  ApiManager apiManager = ApiManager();
  List<SoscietyContactsModel> societyContacts = [];

  fetchSocietyContacts() async {
    emit(SocietyContactsLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.societyContacts);
      var response = jsonDecode(responseData.body);
      if (responseData.statusCode == 200) {
        if (response['status']) {
          var decodedList =
              SoscietyContactsModel.fromJson(jsonDecode(responseData.body));
          societyContacts = [decodedList];
          emit(SocietyContactsLoaded(societyContacts: [decodedList]));
        } else {
          emit(SocietyContactsFailed(errorMsg: response['message'].toString()));
        }
      } else {
        emit(SocietyContactsFailed(errorMsg: response['message'].toString()));
      }
    } on SocketException {
      emit(SocietyContactsInternetError());
    } catch (e) {
      emit(SocietyContactsFailed(errorMsg: e.toString()));
    }
  }
}
