part of 'delete_visitor_cubit.dart';

@immutable
sealed class DeleteVisitorState {}

final class DeleteVisitorInitial extends DeleteVisitorState {}

final class DeleteVisitorLoading extends DeleteVisitorState {}

final class DeleteVisitorSuccessfully extends DeleteVisitorState {
  final String successMsg;
  DeleteVisitorSuccessfully({required this.successMsg});
}

final class DeleteVisitorFailed extends DeleteVisitorState {
  final String errorMsg;
  DeleteVisitorFailed({required this.errorMsg});
}

final class DeleteVisitorInternetError extends DeleteVisitorState {}

final class DeleteVisitorLogout extends DeleteVisitorState {}
