part of 'delete_refer_property_cubit.dart';

@immutable
sealed class DeleteReferPropertyState {}

final class DeleteReferPropertyInitial extends DeleteReferPropertyState {}

final class DeleteReferPropertyLoading extends DeleteReferPropertyState {}

final class DeleteReferPropertySuccess extends DeleteReferPropertyState {
  final String successMsg;
  DeleteReferPropertySuccess({required this.successMsg});
}

final class DeleteReferPropertyFailed extends DeleteReferPropertyState {
  final String errorMsg;
  DeleteReferPropertyFailed({required this.errorMsg});
}

final class DeleteReferPropertyInternetError extends DeleteReferPropertyState {
  final String errorMsg;
  DeleteReferPropertyInternetError({required this.errorMsg});
}

final class DeleteReferPropertyLogout extends DeleteReferPropertyState {}
