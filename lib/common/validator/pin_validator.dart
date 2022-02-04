import 'package:formz/formz.dart';

enum PinValidationError { empty, invalid }

class Pin extends FormzInput<String, PinValidationError> {
  const Pin.pure() : super.pure('');
  const Pin.dirty([String value = '']) : super.dirty(value);

  @override
  PinValidationError validator(String value) {
    return value.isNotEmpty && value.length == 4 ? null : PinValidationError.invalid;

    // value?.isNotEmpty  == true ? null : PinValidationError.empty;
  }
}
