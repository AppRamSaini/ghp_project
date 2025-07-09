part of 'parcel_listing_cubit.dart';

@immutable
sealed class ParcelListingState {}

final class ParcelListingInitial extends ParcelListingState {}

/// for get all parcel listing
final class ParcelListingLoading extends ParcelListingState {}

final class ParcelListingLoaded extends ParcelListingState {
  final List<ParcelListing>? parcelListing;
  final int currentPage;
  final bool hasMore;
  ParcelListingLoaded(
      {required this.parcelListing,
      required this.currentPage,
      required this.hasMore});
}

final class ParcelListingFailed extends ParcelListingState {
  final String errorMsg;
  ParcelListingFailed({required this.errorMsg});
}

final class ParcelListingLogout extends ParcelListingState {}

final class NotificationListingLoadingMore extends ParcelListingState {}

final class ParcelListingInternetError extends ParcelListingState {
  final String errorMsg;
  ParcelListingInternetError({required this.errorMsg});
}
