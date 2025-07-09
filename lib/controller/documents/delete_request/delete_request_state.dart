part of 'delete_request_cubit.dart';

@immutable
sealed class DeleteRequestState {}

final class DeleteRequestInitial extends DeleteRequestState {}

final class DeleteRequestLoading extends DeleteRequestState {}

final class DeleteRequestSuccessfully extends DeleteRequestState {
  final String successMsg;
  DeleteRequestSuccessfully({required this.successMsg});
}

final class DeleteRequestFailed extends DeleteRequestState {
  final String errorMsg;
  DeleteRequestFailed({required this.errorMsg});
}

final class DeleteRequestInternetError extends DeleteRequestState {
  final String errorMsg;
  DeleteRequestInternetError({required this.errorMsg});
}

final class DeleteRequestLogout extends DeleteRequestState {}
