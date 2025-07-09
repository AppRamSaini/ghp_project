part of 'sos_category_cubit.dart';

@immutable
sealed class SosCategoryState {}

final class SosCategoryInitial extends SosCategoryState {}

final class SosCategoryLoading extends SosCategoryState {}

final class SosCategoryLoaded extends SosCategoryState {
  final List<SosCategoryModel> sosCategory;

  SosCategoryLoaded({required this.sosCategory});
}

final class SosCategorySearchLoaded extends SosCategoryState {
  final List<SosCategory?> sosCategory;

  SosCategorySearchLoaded({required this.sosCategory});
}

final class SosCategoryFailed extends SosCategoryState {
  final String errorMsg;
  SosCategoryFailed({required this.errorMsg});
}

final class SosCategoryInternetError extends SosCategoryState {}

final class SosCategoryLogout extends SosCategoryState {}
