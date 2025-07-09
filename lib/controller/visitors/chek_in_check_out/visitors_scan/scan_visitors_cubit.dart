import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/visitors_details_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'scan_visitors_state.dart';

class ScanVisitorsCubit extends Cubit<ScanVisitorsState> {
  ScanVisitorsCubit() : super(ScanVisitorsInitial());
  final ApiManager apiManager = ApiManager();
  Future<void> fetchScanVisitors({required String visitorsId}) async {
    emit(ScanVisitorsLoading());

    try {
      // API Request
      final response = await apiManager.getRequest(
        "${Config.baseURL}${Routes.visitorsDetails}$visitorsId",
      );

      final responseData = jsonDecode(response.body);
      print(responseData);

      // Check response success
      if (response.statusCode == 200 && responseData['status'] == true) {
        final newVisitors = (responseData['data']['visitor'] as List)
            .map((e) => VisitorsDetails.fromJson(e))
            .toList();

        final LastCheckinDetail? lastCheckinDetail =
            newVisitors.first.lastCheckinDetail;

        // Handle visitor's last check-in status
        _handleLastCheckinStatus(lastCheckinDetail);
      } else {
        emit(ScanVisitorsFailed(
            errorMsg: responseData['message'] ?? 'Something went wrong!'));
      }
    } on SocketException {
      emit(ScanVisitorsInternetError(
          errorMsg: 'Internet connection error!')); // Handle network issues
    } catch (e) {
      print("Error: $e");
      emit(ScanVisitorsFailed(errorMsg: "Unexpected error: ${e.toString()}"));
    }
  }

  void _handleLastCheckinStatus(LastCheckinDetail? lastCheckinDetail) {
    if (lastCheckinDetail == null) {
      emit(ScanVisitorsFailed(errorMsg: "No check-in details found!"));
      return;
    }

    print('---------->>>>>${lastCheckinDetail.status}');

    // Map statuses to respective actions
    switch (lastCheckinDetail.status) {
      case 'not_allowed':
      case 'checked_in':
      case 'not_responded':
        emit(CallToFetchListAPI(status: lastCheckinDetail.status.toString()));
        break;
      default:
        emit(ScanVisitorsFailed(
            errorMsg: "Unknown status: ${lastCheckinDetail.status}"));
    }
  }
}
