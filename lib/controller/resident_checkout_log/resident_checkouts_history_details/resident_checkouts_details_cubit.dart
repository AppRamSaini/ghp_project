import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/resident_checkout_history_details_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'resident_checkouts_details_state.dart';

class ResidentCheckoutsHistoryDetailsCubit
    extends Cubit<ResidentCheckoutsHistoryDetailsState> {
  ResidentCheckoutsHistoryDetailsCubit()
      : super(ResidentCheckoutsHistoryDetailsInitial());

  ApiManager apiManager = ApiManager();

  fetchResidentCheckoutsHistoryDetailsApi(
      {String userId = '', String? fromDate, String? toDate}) async {
    emit(ResidentCheckoutsHistoryDetailsLoading());
    try {
      var responseData;
      if (fromDate == null) {
        responseData = await apiManager.getRequest(
            "${Config.baseURL + Routes.residentCheckoutsHistoryDetails}/$userId?");
      } else {
        responseData = await apiManager.getRequest(
            "${Config.baseURL + Routes.residentCheckoutsHistoryDetails}/$userId?from_date=$fromDate&to_date=$toDate");
      }

      var data = json.decode(responseData.body);
      if (responseData.statusCode == 200) {
        if (data['status']) {
          var decodedList = ResidentCheckoutsHistoryDetailsModal.fromJson(data);
          emit(ResidentCheckoutsHistoryDetailsLoaded(
              residentCheckoutsHistoryDetailsModal: decodedList));
        } else {
          emit(ResidentCheckoutsHistoryDetailsError(
              errorMsg: jsonDecode(responseData.body)['message']));
        }
      } else {
        emit(ResidentCheckoutsHistoryDetailsError(
            errorMsg: jsonDecode(responseData.body)['message']));
      }
    } on SocketException {
      emit(ResidentCheckoutsHistoryDetailsError(
          errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(ResidentCheckoutsHistoryDetailsError(
          errorMsg: 'Something went wrong!'));
    }
  }
}
