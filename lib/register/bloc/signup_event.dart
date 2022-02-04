part of 'signup_bloc.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {
  const SignUpEmailChanged(this.email);

  final String email;

  @override
  List<Object> get props => [email];
}

class SignUpPinChanged extends SignUpEvent {
  const SignUpPinChanged(this.pin);

  final String pin;

  @override
  List<Object> get props => [pin];
}

class SignUpPinConfirmChanged extends SignUpEvent {
  const SignUpPinConfirmChanged(this.confirmPin);

  final String confirmPin;

  @override
  List<Object> get props => [confirmPin];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}
