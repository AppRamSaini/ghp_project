part of 'sos_acknowledged_cubit.dart';

@immutable
sealed class AcknowledgedState {}

final class AcknowledgedInitial extends AcknowledgedState {}

final class AcknowledgedLoading extends AcknowledgedState {}

final class AcknowledgedSuccessfully extends AcknowledgedState {
  final String successMsg;
  AcknowledgedSuccessfully({required this.successMsg});
}

final class AcknowledgedFailed extends AcknowledgedState {
  final String errorMsg;
  AcknowledgedFailed({required this.errorMsg});
}

final class AcknowledgedInternetError extends AcknowledgedState {
  final String errorMsg;
  AcknowledgedInternetError({required this.errorMsg});
}

final class AcknowledgedLogout extends AcknowledgedState {}
