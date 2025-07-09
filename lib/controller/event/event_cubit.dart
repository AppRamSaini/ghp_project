import 'dart:convert';
import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:ghp_society_management/constants/config.dart';
import 'package:ghp_society_management/constants/export.dart';
import 'package:ghp_society_management/model/event_model.dart';
import 'package:ghp_society_management/network/api_manager.dart';
import 'package:meta/meta.dart';

part 'event_state.dart';

class EventCubit extends Cubit<EventState> {
  EventCubit() : super(EventInitial());
  ApiManager apiManager = ApiManager();

  int currentPage = 1;
  bool hasMore = true;
  bool isLoadingMore = false;

  List<EventsListing> eventsListing = [];

  fetchEvents({bool loadMore = false}) async {
    if (loadMore) {
      if (isLoadingMore || !hasMore) return; // Prevent duplicate calls
      isLoadingMore = true;
      emit(EventLoadingMore());
    } else {
      currentPage = 1;
      eventsListing.clear();
      emit(EventLoading());
    }

    try {
      var response = await apiManager
          .getRequest("${Config.baseURL}${Routes.event}?page=$currentPage");
      var responseData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status']) {
          var newEvents = (responseData['data']['events']['data'] as List)
              .map((e) => EventsListing.fromJson(e))
              .toList();
          currentPage = responseData['data']['events']['current_page'];
          int lastPage = responseData['data']['events']['last_page'];
          hasMore = currentPage < lastPage;

          if (loadMore) {
            eventsListing.addAll(newEvents);
          } else {
            eventsListing = newEvents;
          }
          emit(EventLoaded(
              event: eventsListing,
              currentPage: currentPage,
              hasMore: hasMore));
        } else {
          emit(EventFailed(errorMsg: responseData['message'].toString()));
        }
      } else if (response.statusCode == 401) {
        emit(EventLogout());
      } else {
        emit(EventFailed(errorMsg: responseData['message'].toString()));
      }
    } on SocketException {
      emit(EventInternetError(errorMsg: "Internet connect error!"));
    } catch (e) {
      emit(EventFailed(errorMsg: e.toString()));
    } finally {
      isLoadingMore = false;
    }
  }

  searchEvent(String query) {
    if (query.isEmpty) {
      emit(EventLoaded(
          event: eventsListing, currentPage: currentPage, hasMore: hasMore));
      return;
    }

    final List<EventsListing> filteredList = eventsListing.where((event) {
      return event.title.toLowerCase().contains(query.toLowerCase());
    }).toList();

    emit(EventSearchedLoaded(event: filteredList));
  }

  void loadMoreEvents() {
    if (state is EventLoaded && hasMore) {
      fetchEvents(loadMore: true); // Load more bills
    }
  }
}
