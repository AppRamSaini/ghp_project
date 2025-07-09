part of 'parcel_complaint_cubit.dart';

@immutable
sealed class ParcelComplaintState {}

final class ParcelComplaintInitial extends ParcelComplaintState {}

/// for  create parcel complaints
final class ParcelComplaintLoading extends ParcelComplaintState {}

final class ParcelComplaintSuccess extends ParcelComplaintState {
  final String successMsg;
  ParcelComplaintSuccess({required this.successMsg});
}

final class ParcelComplaintFailed extends ParcelComplaintState {
  final String errorMsg;
  ParcelComplaintFailed({required this.errorMsg});
}

final class ParcelComplaintLogout extends ParcelComplaintState {}

final class ParcelComplaintInternetError extends ParcelComplaintState {
  final String errorMsg;
  ParcelComplaintInternetError({required this.errorMsg});
}
