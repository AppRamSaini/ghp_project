part of 'start_service_cubit.dart';

@immutable
sealed class StartServiceState {}

final class StartServiceInitial extends StartServiceState {}

final class StartServiceLoading extends StartServiceState {}

final class StartServiceSuccess extends StartServiceState {
  final String successMsg;
  StartServiceSuccess({required this.successMsg});
}

class TriggerDataRefresh extends StartServiceState {}

final class StartServiceFailed extends StartServiceState {
  final String errorMsg;
  StartServiceFailed({required this.errorMsg});
}

final class StartServiceInternetError extends StartServiceState {}

final class StartServiceTimeout extends StartServiceState {}

final class StartServiceLogout extends StartServiceState {}
