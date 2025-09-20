part of 'daily_help_cubit.dart';

@immutable
sealed class DailyHelpListingState {}

final class DailyHelpListingInitial extends DailyHelpListingState {}

final class DailyHelpListingLoading extends DailyHelpListingState {}

final class DailyHelpListingLoaded extends DailyHelpListingState {
  final List<DailyHelp> dailyHelpMemberList;

  DailyHelpListingLoaded({required this.dailyHelpMemberList});
}

final class DailyHelpListingSearchLoaded extends DailyHelpListingState {
  final List<DailyHelp> dailyHelpMemberList;

  DailyHelpListingSearchLoaded({required this.dailyHelpMemberList});
}

final class DailyHelpListingError extends DailyHelpListingState {
  final String errorMsg;

  DailyHelpListingError({required this.errorMsg});
}

final class DailyHelpListingLoadingMore extends DailyHelpListingState {}

final class UnAuthenticatedUser extends DailyHelpListingState {}
