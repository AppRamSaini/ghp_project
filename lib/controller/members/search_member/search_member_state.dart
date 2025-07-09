part of 'search_member_cubit.dart';

@immutable
sealed class SearchMemberState {}

final class SearchMemberInitial extends SearchMemberState {}

final class SearchMemberLoading extends SearchMemberState {}

final class SearchMemberLoaded extends SearchMemberState {
  final List<SearchMemberInfo> searchMemberInfo;
  SearchMemberLoaded({required this.searchMemberInfo});
}

final class SearchMemberFailed extends SearchMemberState {
  final String errorMessage;
  SearchMemberFailed({required this.errorMessage});
}

final class SearchMemberSearchLoaded extends SearchMemberState {
  final List<SearchMemberInfo> searchMemberInfo;
  SearchMemberSearchLoaded({required this.searchMemberInfo});
}

final class SearchMemberInternetError extends SearchMemberState {
  final String errorMessage;
  SearchMemberInternetError({required this.errorMessage});
}

final class SearchMemberLogout extends SearchMemberState {}
