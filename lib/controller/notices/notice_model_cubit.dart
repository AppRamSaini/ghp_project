import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/notice_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';
part 'notice_model_state.dart';

class NoticeModelCubit extends Cubit<NoticeModelState> {
  NoticeModelCubit() : super(NoticeModelInitial());

  ApiManager apiManager = ApiManager();
  List<NoticeList> noticeList = [];

  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  fetchNotices({bool loadMore = false}) async {
    if (isLoadingMore || !hasMore) {
      isLoadingMore = true;
      emit(NoticeModelLoadMore());
    } else {
      currentPage = 1;
      noticeList.clear();
      emit(NoticeModelLoading());
    }

    try {
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.notice}?page=$currentPage");

      var responseData = jsonDecode(response.body.toString());
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newNotice = (responseData['data']['notices']['data'] as List)
              .map((e) => NoticeList.fromJson(e))
              .toList();

          // Update pagination data
          currentPage = responseData['data']['notices']['current_page'];
          int lastPage = responseData['data']['notices']['last_page'];
          hasMore = currentPage < lastPage;
          if (loadMore) {
            noticeList = newNotice;
          } else {
            noticeList.addAll(newNotice);
          }
          emit(NoticeModelLoaded(
              noticeModel: noticeList,
              currentPage: currentPage,
              hasMore: hasMore));
        } else {
          emit(NoticeModelFailed(errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(NoticeModelLogout());
      } else {
        emit(NoticeModelFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(NoticeModelInternetError(errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(NoticeModelFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  searchNotice(String query) {
    emit(NoticeModelLoaded(
        noticeModel: noticeList, currentPage: currentPage, hasMore: hasMore));
    final List<NoticeList> filteredList = noticeList.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();
    emit(NoticeModelSearchedLoaded(noticeModel: filteredList));
  }

  void loadMoreNotice() {
    if (state is NoticeModelLoaded && hasMore) {
      fetchNotices(loadMore: true); // Load more bills
    }
  }
}
