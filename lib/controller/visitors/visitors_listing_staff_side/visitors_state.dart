part of 'visitors_cubit.dart';

@immutable
sealed class VisitorsListingState {}

final class VisitorsListingInitial extends VisitorsListingState {}

final class VisitorsListingLoading extends VisitorsListingState {}

final class VisitorsListingLoaded extends VisitorsListingState {
  final List<VisitorsListing> visitorsListingModel;
  final int currentPage;
  final bool hasMore;
  final int pastVisitors;
  final int todayVisitors;

  VisitorsListingLoaded(
      {required this.visitorsListingModel,
      required this.currentPage,
      required this.hasMore,
      required this.pastVisitors,
      required this.todayVisitors});
}

final class VisitorsListingFailed extends VisitorsListingState {
  final String errorMsg;

  VisitorsListingFailed({required this.errorMsg});
}

final class VisitorsListingInternetError extends VisitorsListingState {
  final String errorMsg;

  VisitorsListingInternetError({required this.errorMsg});
}

final class VisitorsListingMessage extends VisitorsListingState {
  final String msg;
  VisitorsListingMessage({required this.msg});
}

final class SearchVisitorLoaded extends VisitorsListingState {
  final List<VisitorsListing> visitorsListing;
  SearchVisitorLoaded({required this.visitorsListing});
}

final class VisitorsListingLogout extends VisitorsListingState {}

final class ViewVisitorsLoadingMore extends VisitorsListingState {}
