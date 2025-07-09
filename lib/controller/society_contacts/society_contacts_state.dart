part of 'society_contacts_cubit.dart';

@immutable
sealed class SocietyContactsState {}

final class SocietyContactsInitial extends SocietyContactsState {}

final class SocietyContactsLoading extends SocietyContactsState {}

final class SocietyContactsLoaded extends SocietyContactsState {
  final List<SoscietyContactsModel> societyContacts;
  SocietyContactsLoaded({required this.societyContacts});
}

final class SocietyContactsFailed extends SocietyContactsState {
  final String errorMsg;
  SocietyContactsFailed({required this.errorMsg});
}

final class SocietyContactsInternetError extends SocietyContactsState {}
