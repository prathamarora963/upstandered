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
import 'package:upstanders/common/validator/pin_confirm_validator.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(const SignUpState());
  Repository _repository = Repository();
  LocalDataHelper localDataHelper = LocalDataHelper();

  @override
  Stream<SignUpState> mapEventToState(
    SignUpEvent event,
  ) async* {
    if (event is SignUpEmailChanged) {
      yield _mapEmailChangedToState(event, state);
    } else if (event is SignUpPinChanged) {
      yield _mapPinChangedToState(event, state);
    } else if (event is SignUpPinConfirmChanged) {
      yield _mapPinConfirmChangedToState(event, state);
    } else if (event is SignUpSubmitted) {
      yield* _mapSignUpSubmittedToState(event, state);
    }
  }

  SignUpState _mapEmailChangedToState(
    SignUpEmailChanged event,
    SignUpState state,
  ) {
    // final email = event.email;
    final email = Email.dirty(event.email);
    return state.copyWith(
      email: email,
      status: Formz.validate([state.pin, email]),
    );
  }

  SignUpState _mapPinChangedToState(
    SignUpPinChanged event,
    SignUpState state,
  ) {
    final pin = Pin.dirty(event.pin);
    return state.copyWith(
      pin: pin,
      status: Formz.validate([pin, state.email]),
    );
  }

  SignUpState _mapPinConfirmChangedToState(
    SignUpPinConfirmChanged event,
    SignUpState state,
  ) {
    final confirmedPin =
        ConfirmedPin.dirty(pin: state.pin.value, value: event.confirmPin);
    return state.copyWith(
      confirmedPin: confirmedPin,
      status: Formz.validate([confirmedPin, state.email]),
    );
  }

  Stream<SignUpState> _mapSignUpSubmittedToState(
    SignUpSubmitted event,
    SignUpState state,
  ) async* {
    if (state.email.value.isEmpty ||
        state.pin.value.isEmpty ||
        (state.pin.value != state.confirmedPin.value)) return;
    yield state.copyWith(status: FormzStatus.submissionInProgress);
    var res = await _repository.signup(
        email: state.email.value, pin: state.pin.value);
    if (res['status'] == 200) {
      localDataHelper.saveStringValue(
          key: Constants.ACCOUNT_STATUS, value: "1");
      localDataHelper.saveStringValue(
          key: TOKEN, value: res['data']["token"]);
      yield state.copyWith(status: FormzStatus.submissionSuccess, res: res);
    } else {
      yield state.copyWith(status: FormzStatus.submissionFailure, res: res);
    }
  }
}
