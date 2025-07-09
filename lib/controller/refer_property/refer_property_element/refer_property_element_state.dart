part of 'refer_property_element_cubit.dart';

@immutable
sealed class ReferPropertyElementState {}

final class ReferPropertyElementInitial extends ReferPropertyElementState {}

final class ReferPropertyElementLoading extends ReferPropertyElementState {}

final class ReferPropertyElementLoaded extends ReferPropertyElementState {
  final List<ReferPropertyElementModel> referPropertyElement;

  ReferPropertyElementLoaded({required this.referPropertyElement});
}

final class ReferPropertyElementFailed extends ReferPropertyElementState {}

final class ReferPropertyElementLogout extends ReferPropertyElementState {}

final class ReferPropertyElementInternetError
    extends ReferPropertyElementState {}
