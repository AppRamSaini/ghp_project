part of 'members_cubit.dart';

@immutable
sealed class MembersState {}

final class MembersInitial extends MembersState {}

final class MembersLoading extends MembersState {}

final class MembersLoaded extends MembersState {
  final SocietyMembersModel membersList;
  MembersLoaded({required this.membersList});
}

final class MembersFailed extends MembersState {
  final String errorMessage;
  MembersFailed({required this.errorMessage});
}

final class MembersInternetError extends MembersState {}

final class MembersLogout extends MembersState {}

class MembersSearchedLoaded extends MembersState {
  final SocietyData propertyMember;

  MembersSearchedLoaded({required this.propertyMember});
}
