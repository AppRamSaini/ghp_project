
part of 'sos_cancel_cubit.dart';

@immutable
sealed class SosCancelState {}

final class SosCancelInitial extends SosCancelState {}

final class SosCancelLoading extends SosCancelState {}

final class SosCancelSuccessfully extends SosCancelState {
  final String successMsg;
  SosCancelSuccessfully({required this.successMsg});
}

final class SosCancelFailed extends SosCancelState {
  final String errorMsg;
  SosCancelFailed({required this.errorMsg});
}

final class SosCancelInternetError extends SosCancelState {}

final class SosCancelLogout extends SosCancelState {}
