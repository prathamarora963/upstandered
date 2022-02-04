import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/asset_constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/passcode.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/view/view.dart';
import 'package:upstanders/settings/bloc/profile/account_profile_bloc.dart';
import 'package:upstanders/settings/view/create_pin_code_screen.dart';

class ChangePinCodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
          backgroundColor: MyTheme.primaryColor,
          automaticallyImplyLeading: false,
          centerTitle: true,
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
                "CHANGE PIN",
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ],
          )),
      body: _ChangePinCodeForm(),
    );
  }
}

String enteredOldPin;

class _ChangePinCodeForm extends StatefulWidget {
  @override
  State<_ChangePinCodeForm> createState() => _ChangePinCodeFormState();
}

class _ChangePinCodeFormState extends State<_ChangePinCodeForm> {
  bool showPin = true;

  @override
  void dispose() {
    enteredOldPin = '';
    super.dispose();
  }

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
          _headingText(),
          SizedBox(height: size.height * 0.04),
          _rowInputs(),
          _nextButton()
        ],
      ),
    );
  }

  _headingText() {
    return Text(
      "Enter your current pin",
      style: TextStyle(
          color: MyTheme.white,
          fontSize: 20,
          height: 2.000,
          fontWeight: FontWeight.bold),
    );
  }

  _rowInputs() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
            width: 200,
            child: Passcode(
              obsecureText: showPin,
              onChanged: (pin) {
                setState(() {
                  enteredOldPin = pin;
                });
              },
              onCompleted: (val) {
                // enteredOldPin = val;
              },
            )),
        InkWell(
          onTap: () {
            setState(() {
              showPin = !showPin;
            });
          },
          child: Image.asset(
            showPin ? EYE_ASSET : EYE_CLOSE,
            height: 30,
            width: 30,
            
          ),
        )
      ],
    );
  }

  _nextButton() {
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: _NextButtonView()),
      ),
    );
  }
}

class _NextButtonView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccountProfileBloc(),
      child: BlocListener<AccountProfileBloc, AccountProfileState>(
        listener: (context, state) {
          if (state is MatchedPin) {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => CreatePinCodeScreen()));
          } else if (state is MatchingPinFailed) {
            Fluttertoast.showToast(msg: "${state.error}");
          }
        },
        child: BlocBuilder<AccountProfileBloc, AccountProfileState>(
          builder: (context, state) {
            return _builtNextbutton(context, size, state);
          },
        ),
      ),
    );
  }

  _builtNextbutton(BuildContext context, Size size, AccountProfileState state) {
    bool isLoading = state is MatchingPin ? true : false;
    return AnimatedRoundedBorderTextButton(
      processColor: MyTheme.white,
      isLoading: isLoading,
      height: size.height * 0.06,
      width: isLoading ? size.height * 0.06 : size.width / 2.7,
      title: "NEXT",
      borderRadius: 80,
      textColor: MyTheme.secondryColor,
      bgColor: (enteredOldPin != null && enteredOldPin != '') &&
              (enteredOldPin.length == 4)
          ? MyTheme.primaryColor
          : MyTheme.grey,
      alignment: Alignment.bottomCenter,
      onTap: (enteredOldPin != null && enteredOldPin != '') &&
              (enteredOldPin.length == 4)
          ? () =>
              context.read<AccountProfileBloc>().add(MatchOldPin(enteredOldPin))
          : null,
    );
  }
}
