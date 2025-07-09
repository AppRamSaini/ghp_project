part of 'get_staff_cubit.dart';

@immutable
sealed class GetStaffState {}

final class GetStaffInitial extends GetStaffState {}

final class GetStaffLoading extends GetStaffState {}

final class GetStaffLoaded extends GetStaffState {
  final List<StaffModel> staffList;

  GetStaffLoaded({required this.staffList});
}

final class GetStaffSearchedLoaded extends GetStaffState {
  final List<Datum?> staffList;

  GetStaffSearchedLoaded({required this.staffList});
}

final class GetStaffFailed extends GetStaffState {
  final String errorMsg;
  GetStaffFailed({required this.errorMsg});
}

final class GetStaffInternetError extends GetStaffState {}
