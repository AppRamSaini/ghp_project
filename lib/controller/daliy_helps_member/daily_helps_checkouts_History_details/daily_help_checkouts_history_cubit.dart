import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/daily_help_member_checkout_details_modal.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'daily_help_checkouts_history_state.dart';

class DailyHelpHistoryDetailsCubit extends Cubit<DailyHelpHistoryDetailsState> {
  DailyHelpHistoryDetailsCubit() : super(DailyHelpHistoryDetailsInitial());

  ApiManager apiManager = ApiManager();

  fetchDailyHelpHistoryDetailsApi(
      {String userId = '', String? fromDate, String? toDate}) async {
    emit(DailyHelpHistoryDetailsLoading());
    try {
      var responseData;
      if (fromDate == null) {
        responseData = await apiManager.getRequest(
            "${Config.baseURL + Routes.dailyHelpsMembersDetails}$userId");
      } else {
        responseData = await apiManager.getRequest(
            "${Config.baseURL + Routes.dailyHelpsMembersDetails}$userId?from_date=$fromDate&to_date=$toDate");
      }

      var data = json.decode(responseData.body);
      if (responseData.statusCode == 200) {
        if (data['status']) {
          var decodedList = DailyHelpsMemberDetailModal.fromJson(data);
          emit(DailyHelpHistoryDetailsLoaded(
              dailyHelpMemberDetailsModal: decodedList));
        } else {
          emit(DailyHelpHistoryDetailsError(
              errorMsg: jsonDecode(responseData.body)['message']));
        }
      } else {
        emit(DailyHelpHistoryDetailsError(
            errorMsg: jsonDecode(responseData.body)['message']));
      }
    } on SocketException {
      emit(
          DailyHelpHistoryDetailsError(errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(DailyHelpHistoryDetailsError(errorMsg: 'Something went wrong!'));
    }
  }
}
