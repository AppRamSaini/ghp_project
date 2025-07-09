part of 'send_otp_cubit.dart';

@immutable
sealed class SendOtpState {}

final class SendOtpInitial extends SendOtpState {}

final class SendOtpLoading extends SendOtpState {}

final class SendOtpSuccessfully extends SendOtpState {}

final class SendOtpFailed extends SendOtpState {
  final String errorMessage;

  SendOtpFailed({required this.errorMessage});
}

final class SendOtpInternetError extends SendOtpState {}
