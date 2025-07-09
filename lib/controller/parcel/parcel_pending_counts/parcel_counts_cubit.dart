import 'dart:convert';
import 'dart:io';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/network/api_manager.dart';
part 'parcel_counts_state.dart';

class ParcelCountsCubit extends Cubit<ParcelCountsState> {
  ParcelCountsCubit() : super(ParcelCountsInitial());

  ApiManager apiManager = ApiManager();

  fetchParcelCounts() async {
    emit(ParcelCountsLoading());
    try {
      var responseData =
          await apiManager.getRequest(Config.baseURL + Routes.parcelCounts);

      var data = json.decode(responseData.body.toString());
      if (responseData.statusCode == 200) {
        if (data['status']) {
          int counts = data['data']['pending_count'] as int ?? 0;
          LocalStorage.localStorage.setInt('counts', counts);
          emit(ParcelCountsLoaded(count: counts));
        } else {
          emit(ParcelCountsFailed());
        }
      } else if (responseData.statusCode == 401) {
        emit(ParcelCountsLogout());
      }
    } on SocketException {
      emit(ParcelCountsInternetError());
    } catch (e) {
      emit(ParcelCountsFailed());
    }
  }
}
