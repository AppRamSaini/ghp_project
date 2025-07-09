part of 'request_call_back_cubit.dart';

@immutable
sealed class RequestCallBackState {}

final class RequestCallBackInitial extends RequestCallBackState {}

final class RequestCallBackLoading extends RequestCallBackState {}

final class RequestCallBacksuccessfully extends RequestCallBackState {}

final class RequestCallBackFailed extends RequestCallBackState {}

final class RequestCallBackInternetError extends RequestCallBackState {}

final class RequestCallBackLogout extends RequestCallBackState {}
