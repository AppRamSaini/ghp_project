import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/service_request_history_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'service_request_history_state.dart';

class ServiceRequestHistoryCubit extends Cubit<ServiceRequestHistoryState> {
  ServiceRequestHistoryCubit() : super(ServiceRequestHistoryInitial());

  final ApiManager apiManager = ApiManager();
  List<ServiceHistoryModel> serviceRequestHistorys = [];

  int currentPage = 1;
  int totalPages = 1;
  bool isFetchingMore = false;

  /// Fetch initial or paginated service request history
  Future<void> serviceRequestHistory(
      {String? filter,
      String? startDate,
      String? endDate,
      bool loadMore = false}) async {
    if (loadMore) {
      if (currentPage >= totalPages || isFetchingMore) return;
      isFetchingMore = true;
      emit(ServiceRequestHistoryLoadingMore());
    } else {
      emit(ServiceRequestHistoryLoading());
      currentPage = 1;
      serviceRequestHistorys.clear(); // Reset for fresh load
    }

    try {
      String url =
          "${Config.baseURL}${Routes.serviceHistory}?page=$currentPage";
      if (filter != null) url += "&status=$filter";
      if (startDate != null && endDate != null) {
        url += "&from_date=$startDate&to_date=$endDate";
      }

      Response response = await apiManager.getRequest(url);
      var resData = jsonDecode(response.body);

      if (response.statusCode == 200 && resData['status']) {
        var historyModel = ServiceRequestHistoryModel.fromJson(resData);
        var newItems = historyModel.data?.serviceRequests?.data ?? [];

        if (newItems.isNotEmpty) {
          serviceRequestHistorys.addAll(newItems);
          currentPage++;
          totalPages = historyModel.data?.serviceRequests?.lastPage ?? 1;

          emit(ServiceRequestHistoryLoaded(
              serviceHistory: serviceRequestHistorys));
        } else {
          emit(ServiceRequestHistoryEmpty());
        }
      } else {
        emit(ServiceRequestHistoryFailed(
            errorMsg: resData['message'].toString()));
      }
    } on SocketException {
      emit(ServiceRequestHistoryInternetError());
    } on TimeoutException {
      emit(ServiceRequestHistoryTimeout());
    } catch (e) {
      emit(ServiceRequestHistoryFailed(errorMsg: "Error: ${e.toString()}"));
    } finally {
      isFetchingMore = false;
    }
  }
}
