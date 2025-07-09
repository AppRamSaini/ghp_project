part of 'create_complaints_cubit.dart';

@immutable
sealed class CreateComplaintsState {}

final class CreateComplaintsInitial extends CreateComplaintsState {}

final class CreateComplaintsLoading extends CreateComplaintsState {}

final class CreateComplaintsSuccessfully extends CreateComplaintsState {
  final String msg;
  CreateComplaintsSuccessfully({required this.msg});
}

final class CreateComplaintsFailed extends CreateComplaintsState {
  final String errorMsg;
  CreateComplaintsFailed({required this.errorMsg});
}

final class CreateComplaintsInternetError extends CreateComplaintsState {}

final class CreateComplaintsLogout extends CreateComplaintsState {}
