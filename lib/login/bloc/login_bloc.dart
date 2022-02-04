import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/core/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/repository/repository.dart';
import 'package:upstanders/common/validator/email_validator.dart';
import 'package:upstanders/common/validator/pin_validator.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState());

  Repository _repository = Repository();

  LocalDataHelper localDataHelper = LocalDataHelper();
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is LoginPinChanged) {
      yield _mapPinChangedToState(event, state);
    } else if (event is LoginSubmitted) {
      yield* _mapLoginSubmittedToState(event, state);
    } else if (event is ForgotPassword) {
      yield* _mapForgotPasswordToState(event, state);
    }
  }

  LoginState _mapEmailChangedToState(
    LoginEmailChanged event,
    LoginState state,
  ) {
    // final email = event.email;
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.pin, email]),
      // Formz.validate([email, state.pin]),
    );
  }

  LoginState _mapPinChangedToState(
    LoginPinChanged event,
    LoginState state,
  ) {
    final pin = Pin.dirty(event.pin);
    return state.copyWith(
      pin: pin,
      status: Formz.validate([pin, state.email]),
      // Formz.validate([email, state.email]),
    );
  }

  Stream<LoginState> _mapLoginSubmittedToState(
    LoginSubmitted event,
    LoginState state,
  ) async* {
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    var res =
        await _repository.logIn(email: state.email.value, pin: state.pin.value);
    print("LOGIN RESPONSE:$res");
    if (res['status'] == 200 || res['status'] == 401) {
      localDataHelper.saveStringValue(
          key: Constants.ACCOUNT_STATUS, value: "3");
      localDataHelper.saveStringValue(key: TOKEN, value: res['data']["token"]);
      yield state.copyWith(status: FormzStatus.submissionSuccess, res: res);
    }
    if (res['status'] == 403) {
      localDataHelper.saveStringValue(
          key: Constants.ACCOUNT_STATUS, value: "1");
      localDataHelper.saveStringValue(key: TOKEN, value: res['data']["token"]);

      yield state.copyWith(status: FormzStatus.submissionFailure, res: res);
    }
    if (res['status'] == 404) {
      localDataHelper.saveStringValue(
          key: Constants.ACCOUNT_STATUS, value: "2");
      localDataHelper.saveStringValue(key: TOKEN, value: res['data']["token"]);

      yield state.copyWith(status: FormzStatus.submissionFailure, res: res);
    } else {
      yield state.copyWith(status: FormzStatus.submissionFailure, res: res);
    }
  }

  Stream<LoginState> _mapForgotPasswordToState(
    ForgotPassword event,
    LoginState state,
  ) async* {
    yield state.copyWith(loginStatus: LoginStatus.forgettingInProgress);
    try {
      var res = await _repository.forgotPassword(email: state.email.value);
      print("FORGOT PASSWORD RESPONSE:$res");
      if (res['status'] == 200) {
        yield state.copyWith(loginStatus: LoginStatus.forgotSuccess, res: res);
      } else {
        yield state.copyWith(
            loginStatus: LoginStatus.forgettingPasswordFailure, error: res['message']);
      }
    } catch (e) {
      print("GETING EXCEPTION FOR FORGOT PASSWORD:$e");
      yield state.copyWith(
        loginStatus: LoginStatus.forgettingPasswordFailure,
        error:e
      );
    }
  }
}
