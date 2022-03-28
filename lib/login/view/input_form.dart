import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/login/bloc/login_bloc.dart';
import 'package:upstanders/login/constants/constants.dart';
import 'package:upstanders/login/view/forgot_password_screen.dart';
import 'package:upstanders/register/view/sign_up_screen.dart';
import 'package:formz/formz.dart';

class InputForm extends StatefulWidget {
  final LoginBloc loginBloc;
  InputForm({Key key, this.loginBloc}) : super(key: key);

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  var _formKey = new GlobalKey<FormState>();

  var _autoValidateMode = AutovalidateMode.disabled;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: Text(
                      GET_STARTED_TEXT,
                      style: TextStyle(
                          color: MyTheme.white,
                          fontSize: size.height * 0.04, //30
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: size.height * 0.02),

                  ///20
                  bottomField(size, context),
                ],
              ),
            ),
          )),
    );
  }

  Widget bottomField(Size size, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: MyTheme.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          )),
      child: new Form(
          key: _formKey,
          autovalidateMode: _autoValidateMode,
          child: new Column(
            children: <Widget>[
              _inputsFields(context, size),
              _loginButtonForm()
            ],
          )),
    );
  }

  _inputsFields(BuildContext context, Size size) {
    double paddingAll = size.height * 0.035;
    return Container(
      padding: EdgeInsets.all(paddingAll), //30
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            LOGIN_TEXT,
            style: TextStyle(
                color: MyTheme.secondryColor,
                fontSize: size.height * 0.035, // 25,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.02), //20
          _EmailForm(),
          SizedBox(height: size.height * 0.02), //20
          _PinInput(),
          SizedBox(height: size.height * 0.01), //10
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignUpScreen()));
                },
                child: Text(
                  CREATE_NEW_AC_TEXT,
                  style: TextStyle(
                      fontSize: size.height * 0.02, //14,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.primaryColor),
                ),
              ),
              InkWell(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => BlocProvider.value(
                          value: widget.loginBloc,
                          child: ForgotPasswordScreen(),
                        ))),
                child: Text(
                  FORGOT_PASS_BUTTON_TEXT,
                  style: TextStyle(
                      fontSize: size.height * 0.02, //14,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.secondryColor),
                ),
              ),
            ],
          ),
          new SizedBox(
            height: size.height * 0.012,
          ),
        ],
      ),
    );
  }

  _loginButtonForm() {
    return new Container(alignment: Alignment.center, child: _LoginButton());
  }
}

class _EmailForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return TextFormField(
          inputFormatters: [
            FilteringTextInputFormatter.deny(RegExp(r'\s')),
          ],
          key: const Key('loginForm_EmailInput_textField'),
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
            errorBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.red,
              ),
            ),
            prefixIcon: Padding(
              padding: const EdgeInsets.all(10.0),
              child: new Image.asset(
                EMAIL_ASSET,
                width: size.height * 0.025, //25.0,
                height: size.height * 0.02, //20,
              ),
            ),
            hintText: EMAIL_TEXT,
            errorText: state.email.invalid ? INVALID_EMAIL_ERROR_TEXT : null,
            hintStyle: TextStyle(
                fontSize: 12, color: MyTheme.grey, fontWeight: FontWeight.bold),
          ),
          onChanged: (email) =>
              context.read<LoginBloc>().add(LoginEmailChanged(email)),
        );
      },
    );
  }
}

class _PinInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
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
              ),
            ),
            hintText: PIN_TEXT,
            errorText: state.pin.invalid ? PIN_VALIDATION_MSG : null,
            hintStyle: TextStyle(
                fontSize: 12, color: MyTheme.grey, fontWeight: FontWeight.bold),
          ),
          onSaved: (String value) {},
          keyboardType: TextInputType.number,
          onChanged: (pin) =>
              context.read<LoginBloc>().add(LoginPinChanged(pin)),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<LoginBloc, LoginState>(
      buildWhen: (previous, current) => previous.status != current.status,
      builder: (context, state) {
        return _buildLoginButton(context, size, state);
      },
    );
  }

  _buildLoginButton(BuildContext context, Size size, LoginState state) {
    bool isLoading = state.status.isSubmissionInProgress ? true : false;
    return AnimatedRoundedBorderTextButton(
      alignment: Alignment.center,
      isLoading: isLoading,
      processColor: MyTheme.white,
      height: size.height * 0.08,
      width: isLoading ? size.height * 0.08 : size.width,
      textColor: MyTheme.secondryColor,
      fontSize: size.height * 0.028, //17,
      title: LOGIN_TEXT,
      bgColor: state.email.invalid || state.pin.value.isEmpty
          ? MyTheme.grey
          : MyTheme.primaryColor,
      borderRadius: isLoading ? 80 : 0,
      onTap: state.email.invalid || state.pin.invalid
          ? null
          : () {
              if (state.email.value.isEmpty || state.pin.value.isEmpty) {
                Fluttertoast.showToast(msg: "Required fields are empty");
              } else {
                context.read<LoginBloc>().add(const LoginSubmitted());
              }
            },
    );
  }
}
