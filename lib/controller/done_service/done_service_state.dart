part of 'done_service_cubit.dart';

@immutable
sealed class DoneServiceState {}

final class DoneServiceInitial extends DoneServiceState {}

final class DoneServiceLoading extends DoneServiceState {}

final class DoneServiceSuccess extends DoneServiceState {
  final String successMsg;
  DoneServiceSuccess({required this.successMsg});
}

final class DoneServiceFailed extends DoneServiceState {
  final String errorMsg;
  DoneServiceFailed({required this.errorMsg});
}

final class DoneServiceInternetError extends DoneServiceState {}

final class DoneServiceTimeout extends DoneServiceState {}

final class DoneServiceLogout extends DoneServiceState {}
