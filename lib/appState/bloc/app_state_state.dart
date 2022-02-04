part of 'app_state_bloc.dart';

abstract class AppStateState extends Equatable {
  const AppStateState();

  @override
  List<Object> get props => [];
}

class AppStateInitial extends AppStateState {}

class CheckingState extends AppStateState {}

class AppStateProcceed extends AppStateState {}

class OnBoarding extends AppStateState {}

class CreateProfile extends AppStateState {}
class Home extends AppStateState {}

class VerifyAccount extends AppStateState {
  final Map data;

  VerifyAccount(this.data);
}
class Failed extends AppStateState {
  final Map data;

  Failed(this.data);
}

class UserDeleted extends AppStateState {
  final Map data;

  UserDeleted(this.data);
}





