import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/parcel_element.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'parcel_element_state.dart';

class ParcelElementsCubit extends Cubit<ParcelElementsState> {
  ParcelElementsCubit() : super(ParcelElementsInitial());

  ApiManager apiManager = ApiManager();

  fetchParcelElement() async {
    emit(ParcelElementLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.parcelElement);

      if (responseData.statusCode == 200) {
        var parcelList =
            ParcelElementModel.fromJson(jsonDecode(responseData.body));
        emit(ParcelElementLoaded(parcelElement: [parcelList]));
      } else if (responseData.statusCode == 401) {
        emit(ParcelElementLogout());
      }
    } on SocketException {
      emit(ParcelElementInternetError());
    } catch (e) {
      emit(ParcelElementFailed());
    }
  }
}
