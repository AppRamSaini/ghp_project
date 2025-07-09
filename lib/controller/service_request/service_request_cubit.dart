import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/service_request_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

part 'service_request_state.dart';

class ServiceRequestCubit extends Cubit<ServiceRequestState> {
  ServiceRequestCubit() : super(ServiceRequestInitial());

  final ApiManager apiManager = ApiManager();

  /// Fetches the service requests and updates the state accordingly
  Future<void> serviceRequest() async {
    emit(ServiceRequestsLoading());
    try {
      final Response response = await apiManager.getRequest(
        "${Config.baseURL}${Routes.serviceRequest}",
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> serviceRequestResponse =
            jsonDecode(response.body);

        if (serviceRequestResponse['data'] != null) {
          final ServiceRequestModel historyModel =
              ServiceRequestModel.fromJson(serviceRequestResponse);
          print(historyModel.data);
          emit(ServiceRequestsLoaded(serviceHistory: [historyModel]));
        } else {
          emit(ServiceRequestsFailed());
        }
      } else if ([401, 403].contains(response.statusCode)) {
        emit(ServiceRequestsLogout());
      } else {
        emit(ServiceRequestsFailed());
      }
    } on SocketException {
      emit(ServiceRequestsInternetError());
    } on TimeoutException {
      emit(ServiceRequestsTimeout());
    } catch (e) {
      emit(ServiceRequestsFailed());
    }
  }
}
