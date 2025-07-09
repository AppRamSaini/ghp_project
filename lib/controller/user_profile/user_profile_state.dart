part of 'user_profile_cubit.dart';

@immutable
sealed class UserProfileState {}

final class UserProfileInitial extends UserProfileState {}

final class UserProfileLoading extends UserProfileState {}

final class UserProfileLoaded extends UserProfileState {
  final List<UserProfileModel> userProfile;

  UserProfileLoaded({required this.userProfile});
}

final class UserProfileFailed extends UserProfileState {
  final String errorMsg;
  UserProfileFailed({required this.errorMsg});
}

final class UserProfileInternetError extends UserProfileState {}

final class UserProfileLogout extends UserProfileState {}
