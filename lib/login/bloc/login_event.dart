part of 'login_bloc.dart';

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object> get props => [];
}

class LoginEmailChanged extends LoginEvent {
  const LoginEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class LoginPinChanged extends LoginEvent {
  const LoginPinChanged(this.pin);

  final String pin;

  @override
  List<Object> get props => [pin];
}

class LoginSubmitted extends LoginEvent {
  const LoginSubmitted();
}

class ForgotPassword extends LoginEvent {
  const ForgotPassword(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}



