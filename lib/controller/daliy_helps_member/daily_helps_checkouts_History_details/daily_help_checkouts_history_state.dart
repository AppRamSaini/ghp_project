part of 'daily_help_checkouts_history_cubit.dart';

@immutable
sealed class DailyHelpHistoryDetailsState {}

final class DailyHelpHistoryDetailsInitial
    extends DailyHelpHistoryDetailsState {}

final class DailyHelpHistoryDetailsLoading
    extends DailyHelpHistoryDetailsState {}

final class DailyHelpHistoryDetailsLoaded extends DailyHelpHistoryDetailsState {
  final DailyHelpsMemberDetailModal dailyHelpMemberDetailsModal;

  DailyHelpHistoryDetailsLoaded({required this.dailyHelpMemberDetailsModal});
}

final class DailyHelpHistoryDetailsError extends DailyHelpHistoryDetailsState {
  final String errorMsg;
  DailyHelpHistoryDetailsError({required this.errorMsg});
}
