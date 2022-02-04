import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/appState/view/view.dart';
import 'package:upstanders/common/constants/asset_constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/register/bloc/signup_bloc.dart';
import 'package:formz/formz.dart';
import 'package:upstanders/register/view/view.dart';

// class SignUpScreen extends StatefulWidget {
//   @override
//   _SignUpScreenState createState() => _SignUpScreenState();
// }

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          AnimatedLogo(),
          _SignUpForm()
        ],
      ),
    );
  }
}


class _SignUpForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return SignUpBloc();
        },
        child: BlocListener<SignUpBloc, SignUpState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              Fluttertoast.showToast(
                msg: "${state.res['message']}",
              );
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => CreateProfileScreen(
                          isEnablePopButton: true,
                        )),
              );
            } else if (state.status.isSubmissionFailure) {
              print("${state.status}");
              Fluttertoast.showToast(
                msg: "${state.res['message']}",
              );
            }
          },
          child: _SignUpInputForm(),
        ));
  }
}

class _SignUpInputForm extends StatefulWidget {
  @override
  __SignUpInputFormState createState() => __SignUpInputFormState();
}

class __SignUpInputFormState extends State<_SignUpInputForm> {
  var _formKey = new GlobalKey<FormState>();
  var _autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  bottomField(size),
                ],
              ),
            ),
          )),
    );
  }

  Widget bottomField(Size size) {
    return Container(
      alignment: FractionalOffset.bottomCenter,
      decoration: BoxDecoration(
          color: MyTheme.white, borderRadius: BorderRadius.circular(30)),
      child: new Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: new Column(
            children: <Widget>[_inputsFields(size), _signupButton()],
          )),
    );
  }

  _signupButton() {
    return new Container(alignment: Alignment.center, child: _SignUpBotton());
  }

  _inputsFields(Size size) {
     double paddingAll = size.height * 0.035;
    return Container(
      alignment: FractionalOffset.bottomCenter,
      padding:  EdgeInsets.all(paddingAll),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CREATE ACCOUNT",
            style: TextStyle(
                color: MyTheme.secondryColor,
                fontSize: size.height * 0.035,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.02),//20
          _EmailForm(),
          SizedBox(height: size.height * 0.02), //20
          _PinInput(),
          SizedBox(height: size.height * 0.02),//20
          _PinConfirmInput(),
          SizedBox(height: size.height * 0.01), //20
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {},
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                      fontSize: size.height * 0.022, //14
                      fontWeight: FontWeight.bold,
                      color: MyTheme.secondryColor),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  " Login",
                  style: TextStyle(
                      fontSize: size.height * 0.025,// 14
                      fontWeight: FontWeight.bold,
                      color: MyTheme.primaryColor),
                ),
              ),
            ],
          ),
          new SizedBox(
            height: 10.0,
          ),
        ],
      ),
    );
  }
}

class _EmailForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          key: const Key('EmailForm_EmailInput_textField'),
          keyboardType: TextInputType.emailAddress,
          decoration: new InputDecoration(
            contentPadding: const EdgeInsets.all(8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.grey,
              ),
            ),
            errorBorder: state.email.invalid
                ? OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: MyTheme.red,
                    ),
                  )
                : OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 2,
                      color: MyTheme.grey,
                    ),
                  ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Image.asset(
                EMAIL_ASSET,
                width: 25.0,
                height: 20,
              ),
            ),
            hintText: 'Email',
            errorText: state.email.invalid ? 'Invalid email' : null,
            hintStyle: TextStyle(
                fontSize: 12, color: MyTheme.grey, fontWeight: FontWeight.bold),
          ),
          onChanged: (email) =>
              context.read<SignUpBloc>().add(SignUpEmailChanged(email)),
        );
      },
    );
  }
}

class _PinInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.pin != current.pin,
      builder: (context, state) {
        return TextFormField(
          maxLength: 4,
          obscureText: true,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.grey,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.red,
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                PIN_ASSET,
                width: 25.0,
                height: 20,
                // color: Colors.grey[600],
              ),
            ),
            hintText: 'Pin',
            errorText: state.pin.invalid ? 'Please enter 4 digits pin' : null,
            hintStyle: TextStyle(
                fontSize: 12, color: MyTheme.grey, fontWeight: FontWeight.bold),
          ),
          onSaved: (String value) {},
          keyboardType: TextInputType.number,
          onChanged: (pin) =>
              context.read<SignUpBloc>().add(SignUpPinChanged(pin)),
        );
      },
    );
  }
}

class _PinConfirmInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) =>
          previous.confirmedPin != current.confirmedPin,
      builder: (context, state) {
        return TextFormField(
          maxLength: 4,
          // controller: _pinController,
          obscureText: true,
          decoration: InputDecoration(
            counterText: "",
            contentPadding: const EdgeInsets.all(8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.grey,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.red,
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Image.asset(
                PIN_ASSET,
                width: 25.0,
                height: 20,
                // color: Colors.grey[600],
              ),
            ),
            hintText: 'Confirm Pin',
            errorText: state.confirmedPin.invalid ? 'Mismatched Pin' : null,
            hintStyle: TextStyle(
                fontSize: 12, color: MyTheme.grey, fontWeight: FontWeight.bold),
          ),

          keyboardType: TextInputType.number,
          onChanged: (confirmedPin) => context
              .read<SignUpBloc>()
              .add(SignUpPinConfirmChanged(confirmedPin)),
        );
      },
    );
  }
}

class _SignUpBotton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<SignUpBloc, SignUpState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return _buildSignUpButton(context, size, state);
       
      },
    );
  }

  _buildSignUpButton(BuildContext context, Size size, SignUpState state) {
    bool isLoading = state.status.isSubmissionInProgress ? true : false;
    return AnimatedRoundedBorderTextButton(
       alignment: Alignment.center,
      isLoading: isLoading,
      processColor: MyTheme.white,
      height: size.height * 0.08,
      width: isLoading ? size.height * 0.08 : size.width,
      textColor: MyTheme.secondryColor,
      fontSize: size.height * 0.025, //17
      title: "CREATE",
      bgColor: state.email.invalid || state.pin.value.isEmpty ||state.confirmedPin.invalid
          ? MyTheme.grey
          : MyTheme.primaryColor,
      borderRadius:isLoading?80: 0,
      onTap: state.email.invalid || state.pin.invalid ||state.confirmedPin.invalid
        ? null
        : () {
            if (state.email.value.isEmpty ||
                state.pin.value.isEmpty) {
              Fluttertoast.showToast(
                  msg: "Required fields are empty");
            } else {
              context
                  .read<SignUpBloc>()
                  .add(const SignUpSubmitted());
            }
          },
    );
  }
  
}

