part of 'create_polls_cubit.dart';

abstract class CreatePollsState {}

class CreatePollsInitial extends CreatePollsState {}

class CreatePollsLoading extends CreatePollsState {}

class CreatePollsLoaded extends CreatePollsState {
  bool status;
  CreatePollsLoaded({required this.status});
}

class CreatePollsFailed extends CreatePollsState {}

class CreatePollsInternetError extends CreatePollsState {}

class CreatePollsLogout extends CreatePollsState {}
