import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/model/notice_detail_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'notice_detail_state.dart';

class NoticeDetailCubit extends Cubit<NoticeDetailState> {
  NoticeDetailCubit() : super(NoticeDetailInitial());

  ApiManager apiManager = ApiManager();
  List<NoticeDetailModel> notices = [];

  fetchNoticeDetail(noticeId) async {
    emit(NoticeDetailLoading());
    try {
      var responseData = await apiManager
          .getRequest(Config.baseURL + Routes.noticeDetail + noticeId);

      if (responseData.statusCode == 200) {
        var decodedList =
            NoticeDetailModel.fromJson(jsonDecode(responseData.body));
        notices = [decodedList];

        emit(NoticeDetailLoaded(noticeDetail: [decodedList]));
      }
    } on SocketException {
      emit(NoticeDetailInternetError());
    } catch (e) {
      print(e);
      emit(NoticeDetailFailed());
    }
  }
}
