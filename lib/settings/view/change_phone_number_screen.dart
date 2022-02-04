import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/view/home_screen.dart';
import 'package:upstanders/login/constants/constants.dart';
import 'package:upstanders/register/bloc/create_account_bloc.dart';
import 'package:upstanders/register/view/view.dart';

class ChangePhoneNumberScreen extends StatelessWidget {
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
                  "CHANGE PHONE NUMBER",
                  style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.secondryColor),
                ),
              ],
            )),
        body: BlocProvider(
          create: (context) => CreateAccountBloc(),
          child: BlocListener<CreateAccountBloc, CreateAccountState>(
            listener: (context, state) {
              if (state.registrationStatus == RegistrationStatus.sentOTP) {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => VerifyAccountScreen(
                            isEnablePopButton: true,
                            number: '${profileData.countryCode}${state.newNumber.value}',
                          )));
                }
            },
            child: ChangePhoneNumberForm(),
          ),
        ));
  }
}



class ChangePhoneNumberForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: const EdgeInsets.only(left: 25, right: 25, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Old Phone Number",
            style: TextStyle(
                color: MyTheme.white,
                fontSize: 16,
                height: 2.000,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.01),
          _OldNumberInputView(),
          Text(
            "New Phone Number",
            style: TextStyle(
                color: MyTheme.white,
                fontSize: 16,
                height: 2.000,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: size.height * 0.01),
          _NewNumberInputView(),
          SizedBox(height: size.height * 0.1),
          Expanded(
              child: Align(
            alignment: Alignment.bottomCenter,
            child: SaveButtonBlocView(),
          )),
          SizedBox(height: size.height * 0.03),
        ],
      ),
    );
  }
}

class _OldNumberInputView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (context, state) {
        return new TextFormField(
            keyboardType: TextInputType.phone,
            decoration: new InputDecoration(
              filled: true,
              fillColor: MyTheme.primaryColor,
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
                  CHANGE_NUMBER_ASSET,
                  width: 25.0,
                  height: 20,
                ),
              ),
              hintText: 'Phone',
              errorText: state.oldNumber.invalid
                  ? INVALID_PHONE_NUMBER_ERROR_TEXT
                  : null,
              hintStyle: TextStyle(
                  fontSize: 12,
                  color: MyTheme.grey,
                  fontWeight: FontWeight.bold),
            ),
            onChanged: (String oldNumber) => context
                .read<CreateAccountBloc>()
                .add(OnOldNumberChanged(oldNumber)));
      },
    );
  }
}

class _NewNumberInputView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateAccountBloc, CreateAccountState>(
      builder: (context, state) {
        return new TextFormField(
          keyboardType: TextInputType.phone,
          // controller: _newNumberController,
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
                PHONE_ASSET,
                width: 25.0,
                height: 20,
              ),
            ),
            hintText: 'Phone',
            errorText: state.newNumber.invalid
                ? INVALID_PHONE_NUMBER_ERROR_TEXT
                : null,
            hintStyle: TextStyle(
                fontSize: 12, color: MyTheme.grey, fontWeight: FontWeight.bold),
          ),
          onChanged: (String newNumber) => context
              .read<CreateAccountBloc>()
              .add(OnNewNumberChanged(newNumber)),
        );
      },
    );
  }
}

class SaveButtonBlocView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocListener<CreateAccountBloc, CreateAccountState>(
      listener: (context, state) {},
      child: BlocBuilder<CreateAccountBloc, CreateAccountState>(
        builder: (context, state) {
          return _builtSaveButton(context, size, state);
        },
      ),
    );
  }

  _builtSaveButton(BuildContext context, Size size, CreateAccountState state) {
   
     print("oldNumber :${state.oldNumber.invalid}, newNumber: ${state.newNumber.invalid}");
    bool isLoading = state.registrationStatus == RegistrationStatus.processing
        ? true
        : false;

    return AnimatedRoundedBorderTextButton(
        alignment: Alignment.bottomCenter,
        processColor: MyTheme.white,
        title: "SAVE",
        height: size.height * 0.06,
        isLoading: isLoading,
        width: isLoading ? size.height * 0.06 : size.width,
        textColor: MyTheme.secondryColor,
        bgColor: state.oldNumber.value == '' || state.newNumber.value == ''
            ? MyTheme.grey
            :MyTheme.primaryColor,
            
        borderRadius: 80,
        onTap:  state.oldNumber.value == '' || state.newNumber.value == ''
          ? null
          : () {
          if (state.oldNumber.value == profileData.phone) {
            if (state.newNumber.value != profileData.phone) {
              context.read<CreateAccountBloc>().add(SendOtpOnNumber(
                  state.newNumber.value, '${profileData.countryCode}'));
            } else {
              Fluttertoast.showToast(
                  msg:
                      'This is your old number ,Please enter new number');
            }
          } else {
            Fluttertoast.showToast(
                msg: 'Entered old number is Invalid or wrong');
          }
        });
  }
}
