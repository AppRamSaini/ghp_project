
part of 'update_notification_settings_cubit.dart';

@immutable
sealed class UpdateNotificationSettingsState {}

final class UpdateNotificationSettingsInitial extends UpdateNotificationSettingsState {}

final class UpdateNotificationSettingsLoading extends UpdateNotificationSettingsState {}

final class UpdateNotificationSettingsSuccessfully extends UpdateNotificationSettingsState {
  final String message;
  UpdateNotificationSettingsSuccessfully({required this.message});
}

final class UpdateNotificationSettingsFailed extends UpdateNotificationSettingsState {
  final String errorMessage;
  UpdateNotificationSettingsFailed({required this.errorMessage});
}

final class UpdateNotificationSettingsInternetError extends UpdateNotificationSettingsState {
  final String errorMessage;
  UpdateNotificationSettingsInternetError({required this.errorMessage});
}
