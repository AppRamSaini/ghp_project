import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/members_element_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'members_element_state.dart';

class MembersElementCubit extends Cubit<MembersElementState> {
  MembersElementCubit() : super(MembersElementInitial());

  ApiManager apiManager = ApiManager();

  fetchMembersElement() async {
    emit(MembersElementLoading());
    try {
      var response =
          await apiManager.getRequest(Config.baseURL + Routes.membersElements);

      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var memberList = MembersElementModel.fromJson(responseData);
        emit(MembersElementLoaded(membersElements: [memberList]));
      } else if (response.statusCode == 401) {
        emit(MembersElementLogout());
      } else {
        emit(MembersElementFailed());
      }
    } on SocketException {
      emit(MembersElementInternetError());
    } catch (e) {
      emit(MembersElementFailed());
    }
  }
}
