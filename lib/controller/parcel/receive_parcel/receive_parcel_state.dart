part of 'receive_parcel_cubit.dart';

@immutable
sealed class ReceiveParcelState {}

final class ReceiveParcelInitial extends ReceiveParcelState {}

final class ReceiveParcelLoading extends ReceiveParcelState {}

final class ReceiveParcelSuccess extends ReceiveParcelState {
  final String successMsg;
  ReceiveParcelSuccess({required this.successMsg});
}

final class ReceiveParcelFailed extends ReceiveParcelState {
  final String errorMsg;
  ReceiveParcelFailed({required this.errorMsg});
}

final class ReceiveParcelLogout extends ReceiveParcelState {}

final class ReceiveParcelInternetError extends ReceiveParcelState {
  final String errorMsg;
  ReceiveParcelInternetError({required this.errorMsg});
}
