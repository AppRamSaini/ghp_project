part of 'notice_detail_cubit.dart';

@immutable
sealed class NoticeDetailState {}

final class NoticeDetailInitial extends NoticeDetailState {}

final class NoticeDetailLoading extends NoticeDetailState {}

final class NoticeDetailLoaded extends NoticeDetailState {
  final List<NoticeDetailModel> noticeDetail;

  NoticeDetailLoaded({required this.noticeDetail});
}

final class NoticeDetailFailed extends NoticeDetailState {}

final class NoticeDetailInternetError extends NoticeDetailState {}
