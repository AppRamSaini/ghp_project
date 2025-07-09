part of 'notice_model_cubit.dart';

@immutable
sealed class NoticeModelState {}

final class NoticeModelInitial extends NoticeModelState {}

final class NoticeModelLoading extends NoticeModelState {}

final class NoticeModelLoaded extends NoticeModelState {
  final List<NoticeList> noticeModel;
  final int currentPage;
  final bool hasMore;

  NoticeModelLoaded({
    required this.noticeModel,
    required this.currentPage,
    required this.hasMore,
  });
}

final class NoticeModelSearchedLoaded extends NoticeModelState {
  final List<NoticeList> noticeModel;

  NoticeModelSearchedLoaded({required this.noticeModel});
}

final class NoticeModelFailed extends NoticeModelState {
  final String errorMsg;
  NoticeModelFailed({required this.errorMsg});
}

final class NoticeModelInternetError extends NoticeModelState {
  final String errorMsg;
  NoticeModelInternetError({required this.errorMsg});
}

final class NoticeModelLogout extends NoticeModelState {}

final class NoticeModelLoadMore extends NoticeModelState {}
