part of 'event_cubit.dart';

@immutable
sealed class EventState {}

final class EventInitial extends EventState {}

final class EventLoading extends EventState {}

final class EventLoaded extends EventState {
  final List<EventsListing> event;
  final int currentPage;
  final bool hasMore;

  EventLoaded(
      {required this.event, required this.currentPage, required this.hasMore});
}

final class EventSearchedLoaded extends EventState {
  final List<EventsListing> event;

  EventSearchedLoaded({required this.event});
}

final class EventFailed extends EventState {
  final String errorMsg;
  EventFailed({required this.errorMsg});
}

final class EventInternetError extends EventState {
  final String errorMsg;
  EventInternetError({required this.errorMsg});
}

final class EventLogout extends EventState {}

final class EventLoadingMore extends EventState {}
