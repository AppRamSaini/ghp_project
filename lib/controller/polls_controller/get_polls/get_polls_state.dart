part of 'get_polls_cubit.dart';

abstract class GetPollsState {}

class GetPollsInitial extends GetPollsState {}

class GetPollsLoading extends GetPollsState {}

class GetPollsLoaded extends GetPollsState {
  final List<POllList> pollsList;

  GetPollsLoaded({required this.pollsList});
}

class GetPollsFailed extends GetPollsState {
  final String errorMsg;
  GetPollsFailed({required this.errorMsg});
}

class GetPollsInternetError extends GetPollsState {}
