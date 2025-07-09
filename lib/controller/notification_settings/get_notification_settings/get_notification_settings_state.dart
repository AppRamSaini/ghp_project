

part of 'get_notification_settings_cubit.dart';


abstract class GetNotificationSettingsState {}

class InitialGetNotificationSettings extends GetNotificationSettingsState {}

class GetNotificationSettingsLoading extends GetNotificationSettingsState {}

class GetNotificationSettingsLoaded extends GetNotificationSettingsState {
  final List<NotificationSetting> notificationSettings;

  GetNotificationSettingsLoaded({required this.notificationSettings});
}

class GetNotificationSettingsFailed extends GetNotificationSettingsState {
  final String errorMessage;
  GetNotificationSettingsFailed({required this.errorMessage});
}

class GetNotificationSettingsInternetError extends GetNotificationSettingsState {
  final String errorMessage;
  GetNotificationSettingsInternetError({required this.errorMessage});

}
