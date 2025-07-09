part of 'edit_profile_cubit.dart';

@immutable
sealed class EditProfileState {}

final class EditProfileInitial extends EditProfileState {}

final class EditProfileLoading extends EditProfileState {}

final class EditProfileSuccessfully extends EditProfileState {}

final class EditProfileFailed extends EditProfileState {
  final String errorMsg;
  EditProfileFailed({required this.errorMsg});
}

final class EditProfileInternetError extends EditProfileState {}

final class EditProfileLogout extends EditProfileState {}
