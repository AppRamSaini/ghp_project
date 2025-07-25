import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/sliders_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';

part 'sliders_state.dart';

class SlidersCubit extends Cubit<SlidersState> {
  SlidersCubit() : super(InitialSliders());
  ApiManager apiManager = ApiManager();
  List<SliderList> slidersList = [];

  /// FETCH MY BILLS
  Future<void> fetchSlidersAPI() async {
    if (state is SlidersLoading) return;
    emit(SlidersLoading());
    try {
      var response =
          await apiManager.getRequest("${Config.baseURL}${Routes.getSliders}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        var newSliders = (responseData['data']['sliders'] as List)
            .map((e) => SliderList.fromJson(e))
            .toList();
        slidersList.addAll(newSliders);
        emit(SlidersLoaded(sliders: slidersList));
      } else {
        emit(SlidersFailed());
      }
    } on SocketException {
      emit(SlidersInternetError());
    } catch (e) {
      emit(SlidersFailed());
    }
  }
}
