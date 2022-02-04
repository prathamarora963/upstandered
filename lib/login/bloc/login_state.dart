part of 'login_bloc.dart';

enum LoginStatus { forgettingInProgress, forgotSuccess,forgettingPasswordFailure }

class LoginState extends Equatable {
  const LoginState(
      {this.status = FormzStatus.pure,
      this.loginStatus,
      this.email = const Email.pure(),
      this.pin = const Pin.pure(),
      this.res,this.error});

  final FormzStatus status;
  final LoginStatus loginStatus;
  final Pin pin;
  final Email email;
  final Map res;
  final String error;

  LoginState copyWith({
    FormzStatus status,
    LoginStatus loginStatus,
    Email email,
    Pin pin,
    Map res,
    String error
  }) {
    return LoginState(
        status: status ?? this.status,
        loginStatus: loginStatus ??this.loginStatus,
        email: email ?? this.email,
        pin: pin ?? this.pin,
        res: res ?? this.res,
        error:error?? this.error);
  }

  @override
  List<Object> get props => [status, email, pin, res, loginStatus, error];
}
