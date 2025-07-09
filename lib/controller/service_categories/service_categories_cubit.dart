import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/service_categories_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'service_categories_state.dart';

class ServiceCategoriesCubit extends Cubit<ServiceCategoriesState> {
  ServiceCategoriesCubit() : super(ServiceCategoriesInitial());

  ApiManager apiManager = ApiManager();
  List<ServiceCategoriesModel> serviceCategories = [];

  List<ServiceCategory> searchList = [];

  fetchServiceCategories() async {
    emit(ServiceCategoriesLoading());
    try {
      var responseData = await apiManager
          .getRequest(Config.baseURL + Routes.serviceCategories);
      var response = json.decode(responseData.body.toString());
      if (responseData.statusCode == 200) {
        if (response['status']) {
          var decodedList =
              ServiceCategoriesModel.fromJson(jsonDecode(responseData.body));
          serviceCategories = [decodedList];
          emit(ServiceCategoriesLoaded(serviceCategories: [decodedList]));
        } else {
          emit(ServiceCategoriesFailed(
              errorMsg: response['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(ServiceCategoriesLogout());
      } else {
        emit(ServiceCategoriesFailed(errorMsg: response['message'].toString()));
      }
    } on SocketException {
      emit(ServiceCategoriesInternetError());
    } catch (e) {
      emit(ServiceCategoriesFailed(errorMsg: e.toString()));
    }
  }

  searchServiceCategory(String query) {
    emit(ServiceCategoriesLoaded(serviceCategories: serviceCategories));

    if (serviceCategories.isNotEmpty) {
      searchList = serviceCategories.first.data.serviceCategories;
    } else {
      searchList = [];
    }

    final suggestion = searchList.where((element) {
      final apartmentNumber = element.name.toLowerCase();
      final input = query.toLowerCase();

      return apartmentNumber.contains(input);
    }).toList();

    emit(ServiceCategoriesSearchLoaded(
      serviceCategories: suggestion,
    ));
  }
}
