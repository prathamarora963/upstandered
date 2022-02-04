part of 'account_profile_bloc.dart';

class AccountProfileState extends Equatable {
  @override
  List<Object> get props => [];
}

class ProfileInitial extends AccountProfileState {
  @override
  String toString() {
    return "ProfileInitial";
  }
}

class FetchingProfileData extends AccountProfileState {
  @override
  String toString() {
    return "FetchingProfileData";
  }
}

class CurrentUserProfileLoaded extends AccountProfileState {
  final ProfileModel profile;

  CurrentUserProfileLoaded(this.profile);
  @override
  String toString() {
    return "CurrentUserProfileLoaded";
  }
}

class FetchingProfileDataFailed extends AccountProfileState {
  final error;

  FetchingProfileDataFailed({this.error});
  @override
  String toString() {
    return "CurrentUserProfileLoaded";
  }
}

class ClosingAccount extends AccountProfileState {
  @override
  String toString() {
    return "ClosingAccount";
  }
}

class ClosedAccount extends AccountProfileState {
  @override
  String toString() {
    return "ClosedAccount";
  }
}

class ClosingAccountFailed extends AccountProfileState {
  final error;

  ClosingAccountFailed({this.error});
  @override
  String toString() {
    return "ClosingAccountFailed";
  }
}

class ChangingPin extends AccountProfileState {
  @override
  String toString() {
    return "ChangingPin";
  }
}

class ChangedPin extends AccountProfileState {
  @override
  String toString() {
    return "ChangedPin";
  }
}

class ChangingPinFailed extends AccountProfileState {
  final error;

  ChangingPinFailed({this.error});
  @override
  String toString() {
    return "ChangingPinFailed";
  }
}

class UpdatingImage extends AccountProfileState {
  @override
  String toString() {
    return "UpdatingImage";
  }
}

class UpdatedImage extends AccountProfileState {
  @override
  String toString() {
    return "UpdatedImage";
  }
}

class UpdatingImageFailed extends AccountProfileState {
  final error;

  UpdatingImageFailed({this.error});
  @override
  String toString() {
    return "UpdatingImageFailed";
  }
}

class MatchingPin extends AccountProfileState {
  @override
  String toString() {
    return "MatchingPin";
  }
}

class MatchedPin extends AccountProfileState {
  @override
  String toString() {
    return "MatchedPin";
  }
}

class MatchingPinFailed extends AccountProfileState {
  final error;

  MatchingPinFailed({this.error});
  @override
  String toString() {
    return "MatchingPinFailed";
  }
}
