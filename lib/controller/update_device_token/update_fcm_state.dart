part of 'update_fcm_cubit.dart';

@immutable
sealed class UpdateFCMState {}

final class UpdateFCMInitial extends UpdateFCMState {}

final class UpdateFCMLoading extends UpdateFCMState {}

final class UpdateFCMSuccessfully extends UpdateFCMState {}

final class UpdateFCMFailed extends UpdateFCMState {
  final String errorMessage;

  UpdateFCMFailed({required this.errorMessage});
}

final class UpdateFCMInternetError extends UpdateFCMState {}
