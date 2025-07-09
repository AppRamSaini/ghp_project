part of 'notification_list_cubit.dart';

@immutable
sealed class NotificationListingState {}

final class NotificationListingInitial extends NotificationListingState {}

final class NotificationListingLoading extends NotificationListingState {}

final class NotificationListingLoaded extends NotificationListingState {
  final List<NotificationList> notificationListing;
  final int currentPage;
  final bool hasMore;

  NotificationListingLoaded(
      {required this.notificationListing,
      required this.currentPage,
      required this.hasMore});
}

final class NotificationListingSearchedLoaded extends NotificationListingState {
  final List<NotificationList> notificationListing;

  NotificationListingSearchedLoaded({required this.notificationListing});
}

final class NotificationListingFailed extends NotificationListingState {
  final String errorMsg;
  NotificationListingFailed({required this.errorMsg});
}

final class NotificationListingInternetError extends NotificationListingState {
  final String errorMsg;
  NotificationListingInternetError({required this.errorMsg});
}

final class NotificationListingLogout extends NotificationListingState {}

final class NotificationListingEmpty extends NotificationListingState {}

final class NotificationListingLoadingMore extends NotificationListingState {}

final class NotificationListingTimeout extends NotificationListingState {
  final String errorMsg;
  NotificationListingTimeout({required this.errorMsg});
}
