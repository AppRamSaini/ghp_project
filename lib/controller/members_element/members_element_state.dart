part of 'members_element_cubit.dart';

@immutable
sealed class MembersElementState {}

final class MembersElementInitial extends MembersElementState {}

final class MembersElementLoading extends MembersElementState {}

final class MembersElementLoaded extends MembersElementState {
  final List<MembersElementModel?> membersElements;

  MembersElementLoaded({required this.membersElements});
}

final class MembersElementFailed extends MembersElementState {}

final class MembersElementInternetError extends MembersElementState {}

final class MembersElementLogout extends MembersElementState {}
