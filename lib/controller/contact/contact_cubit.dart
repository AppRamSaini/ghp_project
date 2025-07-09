import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/contact_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';
import 'package:meta/meta.dart';

part 'contact_state.dart';

class ContactCubit extends Cubit<ContactState> {
  ContactCubit() : super(ContactInitial());

  ApiManager apiManager = ApiManager();

  contact(BuildContext context) async {
    emit(ContactLoading());
    try {
      var responseData = await apiManager.getRequest(
        Config.baseURL + Routes.contact,
      );

      log(responseData.body);

      if (responseData.statusCode == 200) {
        var response = jsonDecode(responseData.body);

        var contact = ContactModel.fromJson(response);
        emit(Contactsuccessfully(contact: [contact]));
      } else if (responseData.statusCode == 401) {
        sessionExpiredDialog(context);
      } else {
        emit(ContactFailed());
      }
    } on SocketException {
      emit(ContactInternetError());
    } catch (e) {
      print(e);
      emit(ContactFailed());
    }
  }
}
