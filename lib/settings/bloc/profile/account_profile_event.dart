part of 'account_profile_bloc.dart';

abstract class AccountProfileEvent extends Equatable {
  const AccountProfileEvent();

  @override
  List<Object> get props => [];
}

class GetCurrentUserProfile extends AccountProfileEvent {
  @override
  List<Object> get props => [];
}

class CloseAccount extends AccountProfileEvent {
  @override
  List<Object> get props => [];
}

class ChangePin extends AccountProfileEvent {
  final String pin;

  ChangePin(this.pin);

  @override
  List<Object> get props => [];
}

class UpdateProfileImage extends AccountProfileEvent {
  final String file;

  UpdateProfileImage(this.file);

  @override
  List<Object> get props => [];
}

class MatchOldPin extends AccountProfileEvent {
  final String pin;

  MatchOldPin(this.pin);

  @override
  List<Object> get props => [];
}





