import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/refer_property_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'get_refer_property_state.dart';

class GetReferPropertyCubit extends Cubit<GetReferPropertyState> {
  GetReferPropertyCubit() : super(GetReferPropertyInitial());
  ApiManager apiManager = ApiManager();
  List<ReferPropertyList?> referPropertyList = [];

  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// for get all parcels
  fetchGetReferProperty({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return; // Prevent duplicate calls
      isLoadingMore = true;
      emit(GetReferPropertyLoadingMore());
    } else {
      currentPage = 1;
      referPropertyList.clear();
      emit(GetReferPropertyLoading());
    }

    try {
      var response = await apiManager
          .getRequest(Config.baseURL + Routes.referPropertyList);
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newReferPropertyList =
              (responseData['data']['refer_properties']['data'] as List)
                  .map((e) => ReferPropertyList.fromJson(e))
                  .toList();

          currentPage =
              responseData['data']['refer_properties']['current_page'];
          final int lastPage =
              responseData['data']['refer_properties']['last_page'];

          hasMore = currentPage < lastPage;

          if (loadMore) {
            referPropertyList.addAll(newReferPropertyList);
          } else {
            referPropertyList = newReferPropertyList;
          }

          emit(GetReferPropertyLoaded(
              getReferProperty: referPropertyList,
              currentPage: currentPage,
              hasMore: hasMore));
        } else {
          emit(GetReferPropertyFailed(
              errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(GetReferPropertyLogout());
      } else {
        emit(GetReferPropertyFailed(
            errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(GetReferPropertyInternetError(
          errorMsg: 'Internet connection error!'));
    } catch (e) {
      emit(GetReferPropertyFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load More Notifications
  void loadMoreReferProperty() {
    if (state is GetReferPropertyLoaded && hasMore) {
      fetchGetReferProperty(loadMore: true);
    }
  }
}
