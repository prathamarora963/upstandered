import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:upstanders/common/constants/asset_constants.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/view/view.dart';
import 'package:upstanders/register/bloc/create_account_bloc.dart';
import 'package:upstanders/register/models/update_profile.dart';

class VerifyAccountScreen extends StatelessWidget {
  final String number;
  final bool isEnablePopButton;

  const VerifyAccountScreen(
      {Key key, @required this.number, @required this.isEnablePopButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "VERIFY YOUR ACCOUNT",
          style: TextStyle(
            color: MyTheme.secondryColor,
          ),
        ),
        leading: isEnablePopButton
            ? IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: MyTheme.secondryColor,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : Container(),
      ),
      body: BlocProvider(
        create: (context) {
          return CreateAccountBloc();
        },
        child: _VerifyAccountForm(phoneNumber: number),
      ),
    );
  }
}

class _VerifyAccountForm extends StatefulWidget {
  final String phoneNumber;

  const _VerifyAccountForm({Key key, this.phoneNumber}) : super(key: key);
  @override
  __VerifyAccountFormState createState() => __VerifyAccountFormState();
}

class __VerifyAccountFormState extends State<_VerifyAccountForm> {
  TextEditingController _pinPutController = TextEditingController();
  UpdateProfile createAccount = UpdateProfile();
  LocalDataHelper localDataHelper = LocalDataHelper();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    );
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              "Enter the confirmation code we sent to\n${widget.phoneNumber}",
              style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 16,
                  height: 2.000,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.06),
            PinPut(
              validator: (s) {
                if (s.contains('1')) return null;
                return 'NOT VALID';
              },
              useNativeKeyboard: true,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              withCursor: true,
              fieldsCount: 5,
              fieldsAlignment: MainAxisAlignment.spaceAround,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
              eachFieldMargin: EdgeInsets.all(0),
              eachFieldWidth: 50.0,
              eachFieldHeight: 50.0,

              onChanged: (String pin) {
                setState(() {
                  createAccount.otp = pin;
                  localDataHelper.saveStringValue(key: OTP, value: pin);
                });
              },
              autofocus: true,
              // focusNode: _pinPutFocusNode.,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration.copyWith(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: MyTheme.primaryColor,
                ),
              ),
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.scale,
            ),
            SizedBox(height: size.height * 0.06),
            _VerifyMeButton(
              createAccount: createAccount,
            ),
            SizedBox(height: size.height * 0.02),
            _ResendCodeButton(),
          ],
        ),
      ),
    );
  }
}

class _ResendCodeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<CreateAccountBloc, CreateAccountState>(
        listener: (context, state) {
          if (state.registrationStatus == RegistrationStatus.sentOTP) {
            Fluttertoast.showToast(
              msg: "${state.data['message']}",
            );
          } else if (state.registrationStatus ==
              RegistrationStatus.sendingOTPFailed) {
            Fluttertoast.showToast(
              msg: "${state.data['message']}",
            );
          }
        },
        child: BlocBuilder<CreateAccountBloc, CreateAccountState>(
          buildWhen: (previous, current) =>
              previous.registrationStatus != current.registrationStatus,
          builder: (context, state) {
            return state.registrationStatus == RegistrationStatus.processing
                ? ProcessingIndicator(
                    size: size.height * 0.0015,
                  )
                : _resendCodeButton(size, context);
          },
        ));
  }

  _resendCodeButton(Size size, BuildContext context) {
    return InkWell(
      onTap: () {
        print("RESEND OTP");
        context.read<CreateAccountBloc>().add(SendOTP());
      },
      child: Container(
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                SEND_AGAIN_ASSET,
                height: 30,
                width: 30,
              ),
              SizedBox(width: 10),
              Text(
                "SEND AGAIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyTheme.white),
              )
            ],
          )),
    );
  }
}

class _VerifyMeButton extends StatelessWidget {
  final UpdateProfile createAccount;

  const _VerifyMeButton({Key key, this.createAccount}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<CreateAccountBloc, CreateAccountState>(
        listener: (context, state) {
          if (state.registrationStatus == RegistrationStatus.verifiedOTP) {
            Fluttertoast.showToast(
              msg: "${state.data['message']}",
            );
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => HomeScreen()),
                (route) => false);
          } else if (state.registrationStatus == RegistrationStatus.failure) {
            Fluttertoast.showToast(
              msg: "${state.data['message']}",
            );
          }
        },
        child: BlocBuilder<CreateAccountBloc, CreateAccountState>(
          buildWhen: (previous, current) =>
              previous.registrationStatus != current.registrationStatus,
          builder: (context, state) {
            return _builtVerifyMeButton(context, size, state);
          },
        ));
  }

  _builtVerifyMeButton(
      BuildContext context, Size size, CreateAccountState state) {
    bool isLoading = state.registrationStatus == RegistrationStatus.verifyingOTP
        ? true
        : false;

    return AnimatedRoundedBorderTextButton(
      alignment: Alignment.bottomCenter,
      processColor: MyTheme.white,
      title: "VERIFY ME",
      fontSize: 18,
      height: size.height * 0.06,
      isLoading: isLoading,
      width: isLoading ? size.height * 0.06 : size.width,
      textColor: MyTheme.secondryColor,
      bgColor: (createAccount.otp != null && createAccount.otp != '') &&
              createAccount.otp.length == 5
          ? MyTheme.primaryColor
          : MyTheme.grey,
      borderRadius: 80,
      onTap: (createAccount.otp != null && createAccount.otp != '') &&
              createAccount.otp.length == 5
          ? () {
              context.read<CreateAccountBloc>().add(VerifyOTP(createAccount));
            }
          : null,
    );
  }
}
