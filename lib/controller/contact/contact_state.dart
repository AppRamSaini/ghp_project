part of 'contact_cubit.dart';

@immutable
sealed class ContactState {}

final class ContactInitial extends ContactState {}

final class ContactLoading extends ContactState {}

final class Contactsuccessfully extends ContactState {
  final List<ContactModel> contact;

  Contactsuccessfully({required this.contact});
}

final class ContactFailed extends ContactState {}

final class ContactInternetError extends ContactState {}
