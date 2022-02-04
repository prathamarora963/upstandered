import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/appState/view/view.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/login/bloc/login_bloc.dart';
import 'package:upstanders/login/view/view.dart';
import 'package:formz/formz.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/register/view/create_profile_screen.dart';
import 'package:upstanders/register/view/view.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      body: Column(
        children: [
          SizedBox(height: size.height * 0.1),
          AnimatedLogo(),
          _LoginFormScreen()
        ],
      ),
    );
  }
}

class _LoginFormScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) {
          return LoginBloc();
        },
        child: BlocListener<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.status.isSubmissionSuccess) {
              navigationHome(context, state);
            }
            if (state.status.isSubmissionFailure) {
              if (state.res['status'] == 403) {
                navigateToCreateScreen(
                  context,
                );
              } else if (state.res['status'] == 404) {
                String phoneNumber =
                    '${state.res['data']['userData']['country_code']}${state.res['data']['userData']['phone']}';
                _navigateToVerifyScreen(context, phoneNumber);
              } else {
                _showMessage(state.res['message']);
              }
            }
          },
          child: InputForm(
            loginBloc: LoginBloc(),
          ),
        ));
  }

  _showMessage(String msg) {
    Fluttertoast.showToast(msg: msg);
  }

  _navigateToVerifyScreen(BuildContext context, String phone) {
    initializingData();
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => VerifyAccountScreen(
                isEnablePopButton: true,
                number: phone,
              )),
    );
  }

  navigateToCreateScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => CreateProfileScreen(
                isEnablePopButton: true,
              )),
    );
  }

  navigationHome(BuildContext context, LoginState state) {
    initializingData();
    Navigator.of(context).pushNamedAndRemoveUntil('/home', (route) => false);
  }
}
