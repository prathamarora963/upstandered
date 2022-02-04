import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/asset_constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/dialogs.dart';
import 'package:upstanders/common/widgets/passcode.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/settings/bloc/profile/account_profile_bloc.dart';
import 'package:upstanders/settings/view/create_pin_code_screen.dart';

String confirmedEnteredPin;

class ConfirmPinCodeScreen extends StatelessWidget {
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
                "CONFIRM PIN",
                style: TextStyle(
                    // fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ],
          )),
      body: _ConfirmPinCodeForm(),
    );
  }
}

class _ConfirmPinCodeForm extends StatelessWidget {
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
            "Confirm pin",
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
                    child: ConfirmButtonBlocView())),
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
                confirmedEnteredPin = pin;
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

class ConfirmButtonBlocView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocProvider(
      create: (context) => AccountProfileBloc(),
      child: BlocListener<AccountProfileBloc, AccountProfileState>(
        listener: (context, state) {
          if (state is ChangedPin) {
            showGeneralDialog(
              barrierLabel: "Barrier",
              barrierDismissible: true,
              barrierColor: Colors.black.withOpacity(0.5),
              transitionDuration: Duration(milliseconds: 700),
              context: context,
              pageBuilder: (_, __, ___) {
                return Align(
                    alignment: Alignment.center,
                    child: CongratulationDialogBox(
                      onContinue: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ));
              },
              transitionBuilder: (_, anim, __, child) {
                return SlideTransition(
                  position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                      .animate(anim),
                  child: child,
                );
              },
            );
          } else if (state is ChangingPinFailed) {
            Fluttertoast.showToast(msg: "${state.error}");
          }
        },
        child: BlocBuilder<AccountProfileBloc, AccountProfileState>(
          builder: (context, state) {
            if (state is ChangingPin) {
              return ProcessingIndicator(
                size: size.height * 0.0015,
              );
            }
            return RoundedBorderTextButton(
              fontSize: 18,
              title: "CONFIRM",
              height: size.height * 0.06,
              width: size.width / 2.7,
              bgColor: MyTheme.primaryColor,
              textColor: MyTheme.secondryColor,
              onTap: () {
                if (confirmedEnteredPin != null && confirmedEnteredPin != '') {
                  if (enteredPin == confirmedEnteredPin) {
                    context
                        .read<AccountProfileBloc>()
                        .add(ChangePin(confirmedEnteredPin));
                  } else {
                    Fluttertoast.showToast(msg: "Please Match pin");
                  }
                } else {
                  Fluttertoast.showToast(msg: "Please enter 4 digits pin");
                }
              },
              borderColor: MyTheme.primaryColor,
              borderRadius: 80,
            );
          },
        ),
      ),
    );
  }
}
