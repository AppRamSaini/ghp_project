import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/sos_category_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'sos_category_state.dart';

class SosCategoryCubit extends Cubit<SosCategoryState> {
  SosCategoryCubit() : super(SosCategoryInitial());

  ApiManager apiManager = ApiManager();
  List<SosCategoryModel> sosCategory = [];
  List<SosCategory?> searchList = [];

  fetchSosCategory() async {
    emit(SosCategoryLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.sosCategory);
      var response = json.decode(responseData.body.toString());
      if (responseData.statusCode == 200) {
        if (response['status']) {
          var decodedList =
              SosCategoryModel.fromJson(jsonDecode(responseData.body));
          sosCategory = [decodedList];
          emit(SosCategoryLoaded(sosCategory: [decodedList]));
        } else {
          emit(SosCategoryFailed(errorMsg: response['message'].toString()));
        }
      } else if (responseData.statusCode == 401) {
        emit(SosCategoryLogout());
      } else {
        emit(SosCategoryFailed(errorMsg: response['message'].toString()));
      }
    } on SocketException {
      emit(SosCategoryInternetError());
    } catch (e) {
      emit(SosCategoryFailed(errorMsg: e.toString()));
    }
  }

  searchSos(String query) {
    emit(SosCategoryLoaded(sosCategory: sosCategory));

    if (sosCategory.isNotEmpty) {
      searchList = sosCategory.first.data!.sosCategories;
    } else {
      searchList = [];
    }
    final suggestion = searchList.where((element) {
      final apartmentNumber = element!.name.toLowerCase();
      final input = query.toLowerCase();
      return apartmentNumber.contains(input);
    }).toList();
    emit(
      SosCategorySearchLoaded(
        sosCategory: suggestion,
      ),
    );
  }
}
