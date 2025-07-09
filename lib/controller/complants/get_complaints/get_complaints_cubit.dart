import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/complaint_service_provider_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'get_complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  ComplaintsCubit() : super(InitialComplaints());
  ApiManager apiManager = ApiManager();
  List<ComplaintCategory> complaintsLIst =
      []; // Datum represents individual bills

  /// FETCH MY BILLS
  Future<void> fetchComplaintsAPI() async {
    if (state is ComplaintsLoading) return;
    emit(ComplaintsLoading());
    try {
      // Fetching the response from the API
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.fetchComplaintsService}");

      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var newComplaints =
            (responseData['data']['complaint_categories'] as List)
                .map((e) => ComplaintCategory.fromJson(e))
                .toList();
        complaintsLIst
            .addAll(newComplaints); // For subsequent pages, append new bills
        emit(ComplaintsLoaded(complaints: complaintsLIst));
      } else {
        emit(ComplaintsFailed(
            errorMsg:
                responseData['message'].toString())); // Handle failure response
      }
    } on SocketException {
      emit(ComplaintsInternetError()); // Handle network issues
    } catch (e) {
      emit(ComplaintsFailed(errorMsg: e.toString())); // Handle general errors
    }
  }
}
