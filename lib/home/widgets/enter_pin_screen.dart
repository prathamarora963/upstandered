import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/local/local_data_helper.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/dialogs.dart';
import 'package:upstanders/common/widgets/passcode.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/bloc/alert_bloc.dart';
import 'package:upstanders/home/bloc/home_bloc.dart';
import 'package:upstanders/home/data/model/get_current_alert_model.dart';
import 'package:upstanders/home/widgets/report_screen.dart';
import 'package:upstanders/settings/bloc/profile/account_profile_bloc.dart';

GetAlertDetailsModel getAlertDetailsModel = GetAlertDetailsModel();

class EnterPinCodeScreen extends StatelessWidget {
  final String alertId;

  EnterPinCodeScreen({Key key, @required this.alertId}) : super(key: key);
  LocalDataHelper localDataHelper = LocalDataHelper();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          "ENTER YOUR PIN",
          style: TextStyle(
              color: MyTheme.secondryColor, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Image.asset(
            CROSS_ASSET,
            height: 20,
            width: 20,
            color: MyTheme.secondryColor,
          ),
          onPressed: () {
            localDataHelper.saveStringValue(key: ALERT_ID, value: '');
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _EnterPinCodeForm(alertId),
    );
  }
}

String enteredOldPin;

class _EnterPinCodeForm extends StatefulWidget {
  final String alertId;

  _EnterPinCodeForm(this.alertId);
  @override
  __EnterPinCodeFormState createState() => __EnterPinCodeFormState();
}

class __EnterPinCodeFormState extends State<_EnterPinCodeForm> {
  LocalDataHelper localDataHelper = LocalDataHelper();

  bool showPin = true;
  BuildContext alertBloccontext;

  @override
  void dispose() {
    enteredOldPin = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            return AlertBloc();
          },
        ),
        BlocProvider(create: (context) => AccountProfileBloc()),
      ],
      // create: (context) => SubjectBloc(),
      child: Stack(
        children: [
          Container(
            width: size.width,
            height: size.height,
            alignment: Alignment.topCenter,
            padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.04),
                _rowInputs(),
                SizedBox(height: size.height * 0.04),
                Text(
                  "Forgot Pin?",
                  style: TextStyle(
                      color: MyTheme.white,
                      fontSize: 20,
                      height: 2.000,
                      fontWeight: FontWeight.bold),
                ),
                _doneButton(),
                // Expanded(
                //   child: Align(
                //     alignment: Alignment.bottomCenter,
                //     child: Container(
                //       margin: const EdgeInsets.only(bottom: 20),
                //       child: BlocProvider(
                //         create: (context) {

                //           return AlertBloc();
                //         },
                //         child: BlocListener<AlertBloc, AlertState>(
                //           listener: (context, state) {
                //             if (state.alertStatus ==
                //                 AlertStatus.gotAlertDetails) {
                //               getAlertDetailsModel =
                //                   BlocProvider.of<AlertBloc>(context)
                //                       .alertDetailsModel;
                //               _showReportDialog();
                //             }
                //             if (state.alertStatus ==
                //                 AlertStatus.gettingAlertDetailsFailed) {
                //               Fluttertoast.showToast(
                //                   msg: "${state.res['message']}");
                //             }
                //           },
                //           child: BlocBuilder<AlertBloc, AlertState>(
                //             builder: (context, state) {
                //               if (state.alertStatus ==
                //                   AlertStatus.gettingAlertDetails) {
                //                 return ProcessingIndicator(
                //                   size: size.height * 0.0015,
                //                 );
                //               }

                //               return RoundedBorderTextButton(
                //                 fontSize: 18,
                //                 title: "DONE",
                //                 height: size.height * 0.06,
                //                 width: size.width / 2.7,
                //                 bgColor: MyTheme.primaryColor,
                //                 textColor: MyTheme.secondryColor,
                //                 onTap: () => context
                //                     .read<AlertBloc>()
                //                     .add(GetAlertDetails(widget.alertId)),
                //                 borderColor: MyTheme.primaryColor,
                //                 borderRadius: 80,
                //               );
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //   ),
                // )
              ],
            ),
          ),
          Align(
              alignment: Alignment.center,
              child: BlocConsumer<AlertBloc, AlertState>(
                listener: (context, state) {
                  
                  if (state.alertStatus == AlertStatus.gotAlertDetails) {
                    getAlertDetailsModel =
                        BlocProvider.of<AlertBloc>(context).alertDetailsModel;
                    _showReportDialog();
                  }
                  if (state.alertStatus ==
                      AlertStatus.gettingAlertDetailsFailed) {
                    Fluttertoast.showToast(msg: "${state.res['message']}");
                  }
                },
                builder: (context, state) {
                  alertBloccontext = context;
                  if (state.alertStatus == AlertStatus.gettingAlertDetails) {
                    return ProcessingIndicator(
                      processColor: MyTheme.primaryColor,
                      size: 0.0015,
                    );
                  }

                  return Container();
                },
              ))
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
              obsecureText: showPin,
              onChanged: (pin) => setState(() => enteredOldPin = pin),
              onCompleted: (val) {},
            )),
        InkWell(
          onTap: () => setState(() => showPin = !showPin),
          child: Image.asset(
            showPin ? EYE_ASSET : EYE_CLOSE,
            height: 30,
            width: 30,
          ),
        )
      ],
    );
  }

  _doneButton() {
    final size = MediaQuery.of(context).size;
    return Expanded(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
            margin: const EdgeInsets.only(bottom: 20),
            child: BlocListener<AccountProfileBloc, AccountProfileState>(
              listener: (context, state) {
                if (state is MatchedPin) {
                  BlocProvider.of<AlertBloc>(alertBloccontext)
                      .add(GetAlertDetails(widget.alertId));
                } else if (state is MatchingPinFailed) {
                  Fluttertoast.showToast(msg: "${state.error}");
                }
              },
              child: BlocBuilder<AccountProfileBloc, AccountProfileState>(
                builder: (context, state) {
                  return _builtNextbutton(context, size, state);
                },
              ),
            )),
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
      title: "DONE",
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

  _showReportDialog() {
    showGeneralDialog(
      barrierLabel: "Barrier",
      barrierDismissible: true,
      barrierColor: Colors.black.withOpacity(0.5),
      transitionDuration: Duration(milliseconds: 700),
      context: context,
      pageBuilder: (_, __, ___) => Align(
          alignment: Alignment.center,
          child: ReportToAnyoneDialogBox(
            onContinue: () => Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => ReportScreen())),
            onLater: () {
              Navigator.pop(context);
              Navigator.pop(context);
              localDataHelper.saveStringValue(key: ALERT_ID, value: '');
            },
          )),
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position: Tween(begin: Offset(0, 1), end: Offset(0, 0)).animate(anim),
          child: child,
        );
      },
    );
  }
}

// class _DoneButtonView extends StatelessWidget {
//   final String alertId;

//   const _DoneButtonView({Key key, @required this.alertId}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return BlocProvider(
//       create: (context) => AccountProfileBloc(),
//       child: BlocListener<AccountProfileBloc, AccountProfileState>(
//         listener: (context, state) {
//           if (state is MatchedPin) {
//             print("MatchedPin");
//             Fluttertoast.showToast(msg: "MatchedPin");
//             BlocProvider.of<AlertBloc>(alertBloccontext)
//                 .add(GetAlertDetails(alertId));
//           } else if (state is MatchingPinFailed) {
//             Fluttertoast.showToast(msg: "${state.error}");
//           }
//         },
//         child: BlocBuilder<AccountProfileBloc, AccountProfileState>(
//           builder: (context, state) {
//             return _builtNextbutton(context, size, state);
//           },
//         ),
//       ),
//     );
//   }

//   _builtNextbutton(BuildContext context, Size size, AccountProfileState state) {
//     bool isLoading = state is MatchingPin ? true : false;
//     return AnimatedRoundedBorderTextButton(
//       processColor: MyTheme.white,
//       isLoading: isLoading,
//       height: size.height * 0.06,
//       width: isLoading ? size.height * 0.06 : size.width / 2.7,
//       title: "DONE",
//       borderRadius: 80,
//       textColor: MyTheme.secondryColor,
//       bgColor: (enteredOldPin != null && enteredOldPin != '') &&
//               (enteredOldPin.length == 4)
//           ? MyTheme.primaryColor
//           : MyTheme.grey,
//       alignment: Alignment.bottomCenter,
//       onTap: (enteredOldPin != null && enteredOldPin != '') &&
//               (enteredOldPin.length == 4)
//           ? () =>
//               context.read<AccountProfileBloc>().add(MatchOldPin(enteredOldPin))
//           : null,
//     );
//   }
// }
