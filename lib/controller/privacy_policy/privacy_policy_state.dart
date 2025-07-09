
part of 'privacy_policy_cubit.dart';

abstract class PrivacyPolicyState {}

class InitialPrivacyPolicy extends PrivacyPolicyState {}

class PrivacyPolicyLoading extends PrivacyPolicyState {}

class PrivacyPolicyLoaded extends PrivacyPolicyState {
  final PrivacyPolicyModel privacyPolicyModel;

  PrivacyPolicyLoaded({required this.privacyPolicyModel});
}

class PrivacyPolicyFailed extends PrivacyPolicyState {
  final String errorMessage;

  PrivacyPolicyFailed({required this.errorMessage});
}

class PrivacyPolicyInternetError extends PrivacyPolicyState {
  final String errorMessage;

  PrivacyPolicyInternetError({required this.errorMessage});
}
