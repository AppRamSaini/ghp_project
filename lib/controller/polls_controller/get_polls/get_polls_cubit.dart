import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/polls_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:ghp_society_management/view/session_dialogue.dart';

part 'get_polls_state.dart';

class GetPollsCubit extends Cubit<GetPollsState> {
  GetPollsCubit() : super(GetPollsInitial());
  ApiManager apiManager = ApiManager();
  List<POllList> polls = []; // Datum represents individual bills

  /// FETCH MY BILLS
  Future<void> fetchGetPolls(BuildContext context) async {
    if (state is GetPollsLoading) return;
    emit(GetPollsLoading());
    try {
      var response =
          await apiManager.getRequest(Config.baseURL + Routes.getAllPolls);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newPolls = (responseData['data'] as List)
              .map((e) => POllList.fromJson(e))
              .toList();
          polls = newPolls;
          emit(GetPollsLoaded(pollsList: polls));
        } else {
          emit(GetPollsFailed(errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        sessionExpiredDialog(context);
      } else {
        emit(GetPollsFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(GetPollsInternetError()); // Handle network issues
    } catch (e) {
      emit(GetPollsFailed(errorMsg: e.toString())); // Handle general errors
    }
  }
}
