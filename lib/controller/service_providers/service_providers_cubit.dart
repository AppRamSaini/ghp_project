import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/service_provider_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'service_providers_state.dart';

class ServiceProvidersCubit extends Cubit<ServiceProvidersState> {
  ServiceProvidersCubit() : super(ServiceProvidersInitial());

  ApiManager apiManager = ApiManager();
  List<ServiceProvidersModel> serviceProviders = [];

  List<Datum> searchList = [];

  fetchServiceProviders(id) async {
    emit(ServiceProvidersLoading());
    try {
      var responseData = await apiManager
          .getRequest("${Config.baseURL}${Routes.serviceProviders}$id");
      var response = json.decode(responseData.body.toString());
      if (responseData.statusCode == 200) {
        if (response['status']) {
          var decodedList =
              ServiceProvidersModel.fromJson(jsonDecode(responseData.body));
          serviceProviders = [decodedList];
          emit(ServiceProvidersLoaded(serviceProviders: [decodedList]));
        } else {
          emit(
              ServiceProvidersFailed(errorMsg: response['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(ServiceProvidersLogout());
      } else {
        emit(ServiceProvidersFailed(errorMsg: response['message'].toString()));
      }
    } on SocketException {
      emit(ServiceProvidersInternetError());
    } catch (e) {
      emit(ServiceProvidersFailed(errorMsg: e.toString()));
    }
  }

  searchServiceProvider(String query) {
    emit(ServiceProvidersLoaded(serviceProviders: serviceProviders));

    if (serviceProviders.isEmpty) {
      searchList = [];
    } else {
      searchList = serviceProviders.first.data.serviceProviders.data;
    }

    final suggestion = searchList.where((element) {
      final apartmentNumber = element.name.toLowerCase();
      final input = query.toLowerCase();

      return apartmentNumber.contains(input);
    }).toList();

    emit(ServiceProvidersSearchLoaded(
      serviceProviders: suggestion,
    ));
  }
}
