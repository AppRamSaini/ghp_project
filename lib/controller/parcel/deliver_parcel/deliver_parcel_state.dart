part of 'deliver_parcel_cubit.dart';

@immutable
sealed class DeliverParcelState {}

final class DeliverParcelInitial extends DeliverParcelState {}

final class DeliverParcelLoading extends DeliverParcelState {}

final class DeliverParcelSuccess extends DeliverParcelState {
  final String successMsg;
  DeliverParcelSuccess({required this.successMsg});
}

final class DeliverParcelFailed extends DeliverParcelState {
  final String errorMsg;
  DeliverParcelFailed({required this.errorMsg});
}

final class DeliverParcelLogout extends DeliverParcelState {}

final class DeliverParcelInternetError extends DeliverParcelState {
  final String errorMsg;
  DeliverParcelInternetError({required this.errorMsg});
}
