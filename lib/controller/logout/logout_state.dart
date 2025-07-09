part of 'logout_cubit.dart';

@immutable
sealed class LogoutState {}

final class LogoutInitial extends LogoutState {}

final class LogoutLoading extends LogoutState {}

final class LogoutSuccessfully extends LogoutState {}

final class LogoutFailed extends LogoutState {}

final class LogoutInternetError extends LogoutState {}

final class LogoutSessionError extends LogoutState {}
