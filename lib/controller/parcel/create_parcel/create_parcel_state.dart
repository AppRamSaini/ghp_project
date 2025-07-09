part of 'create_parcel_cubit.dart';

@immutable
sealed class ParcelManagementState {}

final class ParcelManagementInitial extends ParcelManagementState {}

/// for create parcel
final class CreateParcelLoading extends ParcelManagementState {}

final class CreateParcelSuccess extends ParcelManagementState {
  final String successMsg;
  CreateParcelSuccess({required this.successMsg});
}

final class CreateParcelFailed extends ParcelManagementState {
  final String errorMsg;
  CreateParcelFailed({required this.errorMsg});
}

final class ParcelManagementLogout extends ParcelManagementState {}
final class ParcelManagementInternetError extends ParcelManagementState {
  final String errorMsg;
  ParcelManagementInternetError({required this.errorMsg});
}
