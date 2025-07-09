part of 'get_refer_property_cubit.dart';

@immutable
sealed class GetReferPropertyState {}

final class GetReferPropertyInitial extends GetReferPropertyState {}

final class GetReferPropertyLoading extends GetReferPropertyState {}

final class GetReferPropertyLoaded extends GetReferPropertyState {
  final List<ReferPropertyList?> getReferProperty;
  final int currentPage;
  final bool hasMore;
  GetReferPropertyLoaded(
      {required this.getReferProperty,
      required this.currentPage,
      required this.hasMore});
}

final class GetReferPropertyFailed extends GetReferPropertyState {
  final String errorMsg;
  GetReferPropertyFailed({required this.errorMsg});
}

final class GetReferPropertyInternetError extends GetReferPropertyState {
  final String errorMsg;
  GetReferPropertyInternetError({required this.errorMsg});
}

final class GetReferPropertyLoadingMore extends GetReferPropertyState {}

final class GetReferPropertyLogout extends GetReferPropertyState {}
