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
      // Fetching the response from the API
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.getSliders}");
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
        // Parse the bills data from the response
        var newSliders = (responseData['data']['sliders'] as List)
            .map((e) => SliderList.fromJson(e))
            .toList();
        slidersList
            .addAll(newSliders); // For subsequent pages, append new bills
        // Emit the loaded state with updated bills
        emit(SlidersLoaded(sliders: slidersList));
      } else {
        emit(SlidersFailed()); // Handle failure response
      }
    } on SocketException {
      emit(SlidersInternetError()); // Handle network issues
    } catch (e) {
      emit(SlidersFailed()); // Handle general errors
    }
  }
}
