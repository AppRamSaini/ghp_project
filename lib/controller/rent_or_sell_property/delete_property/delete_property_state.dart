part of 'delete_property_cubit.dart';

@immutable
sealed class DeletePropertyState {}

final class DeletePropertyInitial extends DeletePropertyState {}

final class DeletePropertyLoading extends DeletePropertyState {}

final class DeletePropertySuccessfully extends DeletePropertyState {
  final String successMsg;
  DeletePropertySuccessfully({required this.successMsg});
}

final class DeletePropertyFailed extends DeletePropertyState {
  final String errorMsg;
  DeletePropertyFailed({required this.errorMsg});
}

final class DeletePropertyInternetError extends DeletePropertyState {
  final String errorMsg;
  DeletePropertyInternetError({required this.errorMsg});
}

final class DeletePropertyLogout extends DeletePropertyState {}
