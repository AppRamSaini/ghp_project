part of 'terms_conditions_cubit.dart';

abstract class TermsConditionsState {}

class InitialTermsConditions extends TermsConditionsState {}

class TermsConditionsLoading extends TermsConditionsState {}

class TermsConditionsLoaded extends TermsConditionsState {
  final TermsConditionsModel termsConditionsModel;

  TermsConditionsLoaded({required this.termsConditionsModel});
}

class TermsConditionsFailed extends TermsConditionsState {
  final String errorMessage;

  TermsConditionsFailed({required this.errorMessage});
}

class TermsConditionsInternetError extends TermsConditionsState {
  final String errorMessage;

  TermsConditionsInternetError({required this.errorMessage});
}
