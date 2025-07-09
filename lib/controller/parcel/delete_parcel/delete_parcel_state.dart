part of 'delete_parcel_cubit.dart';

@immutable
sealed class ParcelDeletetState {}

final class ParcelDeletetInitial extends ParcelDeletetState {}

/// for  delete parcel
final class ParcelDeleteLoading extends ParcelDeletetState {}

final class ParcelDeletedSuccess extends ParcelDeletetState {
  final String successMsg;
  ParcelDeletedSuccess({required this.successMsg});
}

final class ParcelDeletedFailed extends ParcelDeletetState {
  final String errorMsg;
  ParcelDeletedFailed({required this.errorMsg});
}

final class ParcelDeletetLogout extends ParcelDeletetState {}

final class ParcelDeletetInternetError extends ParcelDeletetState {
  final String errorMsg;
  ParcelDeletetInternetError({required this.errorMsg});
}
