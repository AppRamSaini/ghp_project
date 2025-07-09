part of 'verify_otp_cubit.dart';

@immutable
sealed class VerifyOtpState {}

final class VerifyOtpInitial extends VerifyOtpState {}

final class VerifyOtpLoading extends VerifyOtpState {}

final class VerifyOtpSuccessfully extends VerifyOtpState {
  final String role;
  VerifyOtpSuccessfully({required this.role});
}

final class VerifyOtpFailed extends VerifyOtpState {
  final String errorMessage;
  VerifyOtpFailed({required this.errorMessage});
}

final class VerifyOtpInternetError extends VerifyOtpState {}
