part of 'parcel_details_cubit.dart';

@immutable
sealed class ParcelDetailsState {}

final class ParcelDetailsInitial extends ParcelDetailsState {}

/// for get all parcel listing
final class ParcelDetailsLoading extends ParcelDetailsState {}

final class ParcelDetailsLoaded extends ParcelDetailsState {
  final List<ParcelDetails>? parcelDetails;
  ParcelDetailsLoaded({required this.parcelDetails});
}

final class ParcelDetailsFailed extends ParcelDetailsState {
  final String errorMsg;
  ParcelDetailsFailed({required this.errorMsg});
}

final class ParcelDetailsLogout extends ParcelDetailsState {}

final class ParcelDetailsInternetError extends ParcelDetailsState {
  final String errorMsg;
  ParcelDetailsInternetError({required this.errorMsg});
}
