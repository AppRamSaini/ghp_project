part of 'submit_sos_cubit.dart';

@immutable
sealed class SubmitSosState {}

final class SubmitSosInitial extends SubmitSosState {}

final class SubmitSosLoading extends SubmitSosState {}

final class SubmitSosSuccessfully extends SubmitSosState {
  final String successMsg;
  final String sosId;

  SubmitSosSuccessfully({required this.successMsg, required this.sosId});
}

final class SubmitSosFailed extends SubmitSosState {
  final String errorMsg;
  SubmitSosFailed({required this.errorMsg});
}

final class SubmitSosInternetError extends SubmitSosState {}

final class SubmitSosLogout extends SubmitSosState {}
