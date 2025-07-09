part of 'select_society_cubit.dart';

@immutable
sealed class SelectSocietyState {}

final class SelectSocietyInitial extends SelectSocietyState {}

final class SelectSocietyLoading extends SelectSocietyState {}

final class SelectSocietyLoaded extends SelectSocietyState {
  final List<SocietyList> selectedSociety;

  SelectSocietyLoaded({required this.selectedSociety});
}

final class SelectSocietySearchedLoaded extends SelectSocietyState {
  final List<SocietyList> selectedSociety;

  SelectSocietySearchedLoaded({required this.selectedSociety});
}

final class SelectSocietyFailed extends SelectSocietyState {
  final String errorMsg;
  SelectSocietyFailed({required this.errorMsg});
}

final class SelectSocietyInternetError extends SelectSocietyState {
  final String errorMsg;
  SelectSocietyInternetError({required this.errorMsg});
}

final class SelectSocietyLoadMore extends SelectSocietyState {}
