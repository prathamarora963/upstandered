part of 'online_bloc.dart';

abstract class OnlineEvent extends Equatable {
  const OnlineEvent();

  @override
  List<Object> get props => [];
}


class CheckUserOfflineOrNot extends OnlineEvent {
  @override
  List<Object> get props => [];
}

class ActiveUser extends OnlineEvent {
  @override
  List<Object> get props => [];
}

class InActiveUser extends OnlineEvent {
  @override
  List<Object> get props => [];
}