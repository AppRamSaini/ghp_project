part of 'not_responde_cubit.dart';

@immutable
sealed class NotRespondingState {}

final class NotRespondingInitial extends NotRespondingState {}

final class NotRespondingLoading extends NotRespondingState {}

final class NotRespondingSuccessfully extends NotRespondingState {
  final String successMsg;
  NotRespondingSuccessfully({required this.successMsg});
}

final class NotRespondingFailed extends NotRespondingState {
  final String errorMsg;
  NotRespondingFailed({required this.errorMsg});
}

final class NotRespondingInternetError extends NotRespondingState {
  final String errorMsg;
  NotRespondingInternetError({required this.errorMsg});
}

final class NotRespondingLogout extends NotRespondingState {}
