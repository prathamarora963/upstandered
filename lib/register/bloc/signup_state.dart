part of 'signup_bloc.dart';

class SignUpState extends Equatable {
  const SignUpState({
    this.status = FormzStatus.pure,
   
     this.email = const Email.pure(),
    this.pin = const Pin.pure(),
    this.confirmedPin = const ConfirmedPin.pure(),
    this.res
  });

 
  final FormzStatus status;

  final Email email;
  final Pin pin;
  final ConfirmedPin confirmedPin;
  final Map res;

  SignUpState copyWith({
    FormzStatus status,
    Email email,
    Pin pin,
    ConfirmedPin confirmedPin,
    final Map res
  
  }) {
    return SignUpState(
      status: status ?? this.status,
      email: email ?? this.email,
      pin: pin ?? this.pin,
      confirmedPin :confirmedPin ??this.confirmedPin,
      res: res??this.res
    );
  }

  @override
  List<Object> get props => [status, email, pin, confirmedPin, res];
}
