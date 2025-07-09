part of 'visitors_feedback_cubit.dart';

@immutable
sealed class VisitorsFeedBackState {}

final class VisitorsFeedBackInitial extends VisitorsFeedBackState {}

final class VisitorsFeedBackLoading extends VisitorsFeedBackState {}

final class VisitorsFeedBackSuccessfully extends VisitorsFeedBackState {
  final String successMsg;
  VisitorsFeedBackSuccessfully({required this.successMsg});
}

final class VisitorsFeedBackFailed extends VisitorsFeedBackState {
  final String errorMsg;
  VisitorsFeedBackFailed({required this.errorMsg});
}

final class VisitorsFeedBackInternetError extends VisitorsFeedBackState {}

final class VisitorsFeedBackLogout extends VisitorsFeedBackState {}
