part of 'checkout_parcel_cubit.dart';

@immutable
sealed class ParcelCheckoutState {}

final class ParcelCheckoutInitial extends ParcelCheckoutState {}

final class ParcelCheckoutLoading extends ParcelCheckoutState {}

final class ParcelCheckoutSuccess extends ParcelCheckoutState {
  final String successMsg;
  ParcelCheckoutSuccess({required this.successMsg});
}

final class ParcelCheckoutFailed extends ParcelCheckoutState {
  final String errorMsg;
  ParcelCheckoutFailed({required this.errorMsg});
}

final class ParcelCheckoutLogout extends ParcelCheckoutState {}

final class ParcelCheckoutInternetError extends ParcelCheckoutState {
  final String errorMsg;
  ParcelCheckoutInternetError({required this.errorMsg});
}
