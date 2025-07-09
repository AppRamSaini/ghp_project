import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/local_storage.dart';
import 'package:ghp_society_management/model/notification_listing_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'notification_list_state.dart';

class NotificationListingCubit extends Cubit<NotificationListingState> {
  NotificationListingCubit() : super(NotificationListingInitial());

  final ApiManager apiManager = ApiManager();

  List<NotificationList> notificationList = [];
  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  /// Fetch Notifications
  Future<void> fetchNotifications({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return;
      isLoadingMore = true;
      emit(NotificationListingLoadingMore());
    } else {
      currentPage = 1;
      notificationList.clear();
      emit(NotificationListingLoading());
    }

    try {
      final response = await apiManager.getRequest(
          "${Config.baseURL}${Routes.getAllNotification}?page=$currentPage");

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == true) {
          final List<NotificationList> newNotifications =
              (responseData['data']['notifications']['data'] as List)
                  .map((e) => NotificationList.fromJson(e))
                  .toList();

          final int lastPage =
              responseData['data']['notifications']['last_page'];

          hasMore = currentPage < lastPage; // Check if more pages exist

          if (loadMore) {
            for (var item in newNotifications) {
              if (!notificationList.contains(item)) {
                notificationList.add(item);
              }
            }
          } else {
            notificationList = newNotifications;
          }

          currentPage++;

          emit(NotificationListingLoaded(
            notificationListing: notificationList,
            currentPage: currentPage,
            hasMore: hasMore,
          ));
        } else {
          emit(NotificationListingFailed(
              errorMsg: responseData['message'] ?? "Something went wrong."));
        }
      } else if (response.statusCode == 401) {
        emit(NotificationListingLogout());
      } else {
        emit(NotificationListingFailed(
            errorMsg:
                "Error: ${response.statusCode}, ${response.reasonPhrase}"));
      }

      // 🔹 **Update unread notification count in local storage**
      if (responseData['data'] != null) {
        await LocalStorage.localStorage.setInt(
            'counts', responseData['data']['total_unread_notifications'] ?? 0);
      }
    } on SocketException {
      emit(NotificationListingInternetError(
          errorMsg: "Internet Connection Error!"));
    } catch (e) {
      emit(NotificationListingFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  /// Load More Notifications
  void loadMoreNotification() {
    if (state is NotificationListingLoaded && hasMore) {
      fetchNotifications(loadMore: true);
    }
  }

  /// READ NOTIFICATIONS
  readNotifications() async {
    var token = LocalStorage.localStorage.getString('token');
    try {
      var headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      };
      var request = http.Request(
          'POST', Uri.parse("${Config.baseURL}${Routes.readNotifications}"));
      request.body = json.encode({"all_read": true});
      request.headers.addAll(headers);
      http.StreamedResponse response = await request.send();
      if (response.statusCode == 200) {
        print("----------->>>>>${await response.stream.bytesToString()}");
        await LocalStorage.localStorage.setInt('counts', 0);
      } else {
        print(response.reasonPhrase);
      }
    } catch (e) {
      print('------>>>>>${e.toString()}');
      fetchNotifications(loadMore: true);
    }
  }
}
