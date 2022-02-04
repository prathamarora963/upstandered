import 'package:flutter/material.dart';
import 'package:formz/formz.dart';

enum ConfirmedPinValidationError { invalid }

class ConfirmedPin
    extends FormzInput<String, ConfirmedPinValidationError> {
  const ConfirmedPin.pure({this.pin = ''}) : super.pure('');
  const ConfirmedPin.dirty({@required this.pin, String value = ''})
      : super.dirty(value);

  final String pin;

  @override
  ConfirmedPinValidationError validator(String value) {
    return pin == value ? null : ConfirmedPinValidationError.invalid;
  }
}
