import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/visitors_details_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';

part 'visitors_details_state.dart';

class VisitorsDetailsCubit extends Cubit<VisitorsDetailsState> {
  VisitorsDetailsCubit() : super(VisitorsDetailsInitial());
  ApiManager apiManager = ApiManager();
  List<VisitorsDetails> visitorsDetails = [];
  String message = '';

  /// FETCH  VISITORS DETAILS
  Future<void> fetchVisitorsDetails(
      {required BuildContext context, required String visitorsId}) async {
    emit(VisitorsDetailsLoading());
    print('url------${Config.baseURL}${Routes.visitorsDetails}$visitorsId');
    try {
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.visitorsDetails}$visitorsId");
      var responseData = jsonDecode(response.body);
      print('------${response.statusCode}           $responseData');
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newVisitors = (responseData['data']['visitor'] as List)
              .map((e) => VisitorsDetails.fromJson(e))
              .toList();
          visitorsDetails = newVisitors;
          emit(VisitorsDetailsLoaded(visitorDetails: visitorsDetails));
        } else {
          message = responseData['message'];
          emit(VisitorsDetailsMessage(msg: message));
        }
      } else if (response.statusCode == 401) {
        sessionExpiredDialog(context);
      } else {
        emit(VisitorsDetailsFailed(
            errorMsg: responseData['message'])); // Handle failure response
      }
    } on SocketException {
      emit(VisitorsDetailsInternetError(
          errorMsg: 'Internet connection error!')); // Handle network issues
    } catch (e) {
      print(e);
      emit(VisitorsDetailsFailed(
          errorMsg: "Error ${e.toString()}")); // Handle failure response
    }
  }
}
