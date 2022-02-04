import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/login/bloc/login_bloc.dart';
import 'package:upstanders/login/constants/constants.dart';

class ForgotPasswordForm extends StatelessWidget {
 
  @override
  Widget build(BuildContext context) {
  
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _headerText(size),
            SizedBox(height: size.height * 0.03),
            _EmailInput(),
            SizedBox(height: size.height * 0.1),
            _SendButton(),
            SizedBox(height: size.height * 0.02),
            _SendAgainButton(),
          ],
        ),
      ),
    );
  }

  _headerText(Size size) {
    return Text(
      ENTER_EMAIL_TEXT,
      style: TextStyle(
          color: MyTheme.white,
          fontSize: size.height * 0.02, //16
          height: 2.000,
          fontWeight: FontWeight.bold),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        return new TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: new InputDecoration(
            filled: true,
            fillColor: MyTheme.white,
            contentPadding: const EdgeInsets.all(8),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 2,
                color: MyTheme.primaryColor,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                width: 0,
                color: MyTheme.secondryColor,
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
                width: 25.0,
                height: 20,
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

class _SendButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.loginStatus == LoginStatus.forgettingPasswordFailure) {
          _showMessage(state.error);
        }
        if (state.loginStatus == LoginStatus.forgotSuccess) {
          _showMessage(state.res['message']);
        }
      },
      builder: (context, state) {
        return _sendButtonsubmit(context, size, state);
      },
    );
  }

  _showMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  _sendButtonsubmit(BuildContext context, Size size, LoginState state) {
    bool isLoading =
        state.loginStatus == LoginStatus.forgettingInProgress ? true : false;
    return AnimatedRoundedBorderTextButton(
       alignment: Alignment.center,
      isLoading: isLoading,
      processColor: MyTheme.white,
      fontSize: size.height * 0.023,///18
      height: size.height * 0.06,
      width: isLoading ? size.height * 0.06 : size.width,
      textColor: MyTheme.secondryColor,
      title: SEND_TEXT,
      bgColor: state.email.invalid || state.email.value.isEmpty
          ? MyTheme.grey
          : MyTheme.primaryColor,
      borderRadius: 80,
      onTap: state.email.invalid || state.email.value.isEmpty
          ? null
          : () =>
              context.read<LoginBloc>().add(ForgotPassword(state.email.value)),
    );
  }

  // _sendButtonsubmit2(BuildContext context, Size size, LoginState state) {
  //   return RoundedBorderTextButton(
  //     title: SEND_TEXT,
  //     height: size.height * 0.06,
  //     width: size.width,
  //     fontSize: 18,
  //     bgColor: state.email.invalid || state.email.value.isEmpty
  //         ? MyTheme.grey
  //         : MyTheme.primaryColor,
  //     textColor: MyTheme.secondryColor,
  //     onTap: state.email.invalid || state.email.value.isEmpty
  //         ? null
  //         : () =>
  //             context.read<LoginBloc>().add(ForgotPassword(state.email.value)),
  //     borderColor: MyTheme.primaryColor,
  //     borderRadius: 80,
  //   );
  // }
}

class _SendAgainButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.loginStatus == LoginStatus.forgettingInProgress) {
          return Container();
        }

        return _resendAgainButton(size, context, state);
      },
    );
  }

  _resendAgainButton(Size size, BuildContext context, LoginState state) {
    return InkWell(
      onTap: state.email.invalid || state.email.value.isEmpty
          ? null
          : () =>
              context.read<LoginBloc>().add(ForgotPassword(state.email.value)),
      child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                SEND_AGAIN_ASSET,
                height: 28,
                width: 28,
              ),
              SizedBox(width: 10),
              Text(
                SEND_AGAIN_TEXT,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: size.height * 0.023,
                     color: MyTheme.white),
              )
            ],
          )),
    );
  }
}
