part of 'update_refer_property_cubit.dart';

@immutable
sealed class UpdateReferPropertyState {}

final class UpdateReferPropertyInitial extends UpdateReferPropertyState {}

/// for update refer property
final class UpdateReferPropertyLoading extends UpdateReferPropertyState {}

final class UpdateReferPropertySuccess extends UpdateReferPropertyState {
  final String successMsg;
  UpdateReferPropertySuccess({required this.successMsg});
}

final class UpdateReferPropertyFailed extends UpdateReferPropertyState {
  final String errorMsg;
  UpdateReferPropertyFailed({required this.errorMsg});
}

final class UpdateReferPropertyInternetError extends UpdateReferPropertyState {
  final String errorMsg;
  UpdateReferPropertyInternetError({required this.errorMsg});
}

final class UpdateReferPropertyLogout extends UpdateReferPropertyState {}
