part of 'sos_history_cubit.dart';

@immutable
sealed class SosHistoryState {}

final class SosHistoryInitial extends SosHistoryState {}

final class SosHistoryLoading extends SosHistoryState {}

final class SosHistoryLoaded extends SosHistoryState {
  final List<SosHistoryList> sosHistoryModel;
  SosHistoryLoaded({required this.sosHistoryModel});
}

final class SosHistoryFailed extends SosHistoryState {
  final String errorMsg;

  SosHistoryFailed({required this.errorMsg});
}

final class SosHistoryInternetError extends SosHistoryState {
  final String errorMsg;

  SosHistoryInternetError({required this.errorMsg});
}

final class SosHistoryLoadingMore extends SosHistoryState {}
