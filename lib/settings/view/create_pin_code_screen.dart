import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/asset_constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/passcode.dart';
import 'package:upstanders/settings/view/confirm_pin_code_screen.dart';
String enteredPin;

class CreatePinCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
          backgroundColor: MyTheme.primaryColor,
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: MyTheme.secondryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              Text(
                "CREATE PIN",
                style: TextStyle(
                    // fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ],
          )),
      body: _CreatePinCodeForm(),
    );
  }
}

class _CreatePinCodeForm extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Enter your new pin",
            style: TextStyle(
                color: MyTheme.white,
                fontSize: 20,
                height: 2.000,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.04),
          _rowInputs(),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: RoundedBorderTextButton(
                  fontSize: 18,
                  title: "CREATE",
                  height: size.height * 0.06,
                  width: size.width / 2.7,
                  bgColor: MyTheme.primaryColor,
                  textColor: MyTheme.secondryColor,
                  onTap: () {
                    if (enteredPin != null && enteredPin != '') {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => ConfirmPinCodeScreen()));
                    } else {
                      Fluttertoast.showToast(msg: "Please enter 4 digit pin");
                    }
                  },
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 80,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _rowInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 200,
            child: Passcode(
              obsecureText: true,
              onChanged: (pin) {},
              onCompleted: (pin) {
                enteredPin = pin;
              },
            )),
        InkWell(
          onTap: () {},
          child: Image.asset(
            EYE_ASSET,
            height: 30,
            width: 30,
          ),
        )
      ],
    );
  }
}
