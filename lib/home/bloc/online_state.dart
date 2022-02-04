part of 'online_bloc.dart';

abstract class OnlineState extends Equatable {
  const OnlineState();
  
  @override
  List<Object> get props => [];
}

class OnlineInitial extends OnlineState {}

class InitialInActivatedUser extends OnlineState {
  @override
  String toString() {
    return "InitialInActivatedUser";
  }
}

class ActivatedUser extends OnlineState {
  @override
  String toString() {
    return "ActivatedUser";
  }
}

class ActivatingUser extends OnlineState {
  @override
  String toString() {
    return "ActivatingUser";
  }
}



class ActivatingUserFailed extends OnlineState {
  final error;

  ActivatingUserFailed(this.error);
  @override
  String toString() {
    return "ActivatingUserFailed";
  }
}


class InActivatingUser extends OnlineState {
  @override
  String toString() {
    return "InActivatingUser";
  }
}

class InActivatedUser extends OnlineState {
  @override
  String toString() {
    return "InActivatedUser";
  }
}



class InActivatingUserFailed extends OnlineState {
  final error;

  InActivatingUserFailed(this.error);
  @override
  String toString() {
    return "InActivatingUserFailed";
  }
}

class ChekingUserOnlineStatus extends OnlineState {
  ChekingUserOnlineStatus();
  @override
  String toString() {
    return "ChekingUserOnlineStatus";
  }
}



class CheckUserOfflineOrNotFailure extends OnlineState {
  final error;

  CheckUserOfflineOrNotFailure(this.error);
  @override
  String toString() {
    return "CheckUserOfflineOrNotFailure";
  }
}




