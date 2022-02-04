import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:upstanders/common/theme/colors.dart';

class Passcode extends StatelessWidget {
  final void Function(String) onChanged;
  final void Function(String) onCompleted;
  final bool obsecureText;

  const Passcode(
      {Key key, @required this.onChanged,@required this.onCompleted,  @required this.obsecureText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PinCodeTextField(
      onCompleted: onCompleted,

      autoFocus: true,
      inactiveColor: MyTheme.secondryColor,
      shape: PinCodeFieldShape.underline,
      activeFillColor: Colors.white,
      backgroundColor: MyTheme.secondryColor,
      activeColor: MyTheme.secondryColor,
      selectedFillColor: Colors.white,
      textInputType: TextInputType.phone,
      length: 4,
      obsecureText: obsecureText,

      textStyle: TextStyle(color: Colors.white, fontSize: 30),
      animationType: AnimationType.scale,
      //shape: PinCodeFieldShape.box,
      animationDuration: Duration(milliseconds: 300),
      //borderRadius: BorderRadius.circular(5),
      fieldHeight: 50,
      fieldWidth: 50,
      onChanged: onChanged,
    );
  }
}
