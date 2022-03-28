import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/model/mcq.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/common/widgets/question_dialog_box.dart';
import 'package:upstanders/common/widgets/user_avatar.dart';
import 'package:upstanders/home/bloc/alert_bloc.dart';
import 'package:upstanders/home/data/model/alert_data_model.dart';
import 'package:upstanders/home/widgets/enter_pin_screen.dart';
import 'package:upstanders/home/widgets/report_sent_screen.dart';
import 'package:upstanders/home/view/view.dart';

ReportUserModel selectedReportUser = ReportUserModel();
int _groupValue = -1;

class ReportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "REPORT",
          style: TextStyle(
            color: MyTheme.secondryColor,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: MyTheme.secondryColor,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ReportForm(),
    );
  }
}

class ReportForm extends StatefulWidget {
  @override
  _ReportFormState createState() => _ReportFormState();
}

class _ReportFormState extends State<ReportForm> {
  int myIndex = 0;
  List<ReportUserModel> reportUsers = [];
  String _title =
      "Select who to report.you can come back to\nthis page to report more than one person";

  @override
  void initState() {
    super.initState();
    getAlertDetailsModel.alertData.user.forEach((element) {
      reportUsers.add(
        ReportUserModel(
          alertId: getAlertDetailsModel.alertData.id,
          userId: element.userId,
          firstName: element.firstName,
          lastName: element.lastName,
          image: element.image,
          isReport: false,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  width: size.width,
                  alignment: Alignment.center,
                  child: Text(_title,
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                ),
                Expanded(child: _listItem())
              ],
            ),
            Align(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    RoundedBorderTextButton(
                        title: "FINISH",
                        onTap: () => clearAndNaviagateToHome(),
                        height: size.height * 0.07,
                        width: size.width * 0.9,
                        textColor: MyTheme.black,
                        fontSize: 18,
                        bgColor: MyTheme.primaryColor,
                        borderRadius: 80,
                        borderColor: MyTheme.primaryColor),
                    RoundedBorderTextButton(
                        title: "CANCEL",
                        fontSize: 18,
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        height: size.height * 0.07,
                        width: size.width,
                        textColor: MyTheme.black,
                        bgColor: MyTheme.white,
                        borderRadius: 80,
                        borderColor: MyTheme.white)
                  ],
                ))
          ],
        ));
  }

  clearAndNaviagateToHome() {
    alertEndedNotified = false;
    isAcceptedNotified = false;
    localDataHelper.saveStringValue(key: ALERT_ID, value: '');

    localDataHelper.saveValue(key: ALERT_ENDED_NOTIFIED, value: false);
    localDataHelper.saveValue(key: IS_ACCEPTED_NOTIFIED, value: false);
    localDataHelper.saveValue(key: SHOW_LEAVE, value: false);
    localDataHelper.saveValue(key: IS_CREATE_ALERT, value: false);
    String notificationData = jsonEncode(NotificationDataModel.fromJson({}));
    localDataHelper.saveStringValue(
        key: NOTIFICATION_DATA, value: notificationData);

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => HomeScreen()),
        (route) => false);
  }

  _listItem() {
    return Container(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 100),
        itemCount: reportUsers.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              tileColor: reportUsers[index].isReport
                  ? MyTheme.primaryColor
                  : MyTheme.transparent,
              contentPadding:
                  EdgeInsets.only(left: 15, right: 8, top: 8, bottom: 8),
              onTap: () {
                // setState(() {
                // reportUsers[index].isReport = !reportUsers[index].isReport;
                // });

                setState(() {
                  reportUsers[myIndex].isReport = false;
                  myIndex = index;
                  reportUsers[index].isReport = true;
                  selectedReportUser = reportUsers[index];

                  showGeneralDialog(
                    barrierLabel: "Barrier",
                    barrierDismissible: true,
                    barrierColor: Colors.black.withOpacity(0.5),
                    transitionDuration: Duration(milliseconds: 700),
                    context: context,
                    pageBuilder: (_, __, ___) {
                      return Align(
                          alignment: Alignment.center,
                          child: ReportAlertBlocView());
                    },
                    transitionBuilder: (_, anim, __, child) {
                      return SlideTransition(
                        position: Tween(begin: Offset(0, 1), end: Offset(0, 0))
                            .animate(anim),
                        child: child,
                      );
                    },
                  );
                });
              },
              leading: UserAvatarNetwok(
                  networkImage: reportUsers[index].image, avatarRadius: 50),
              title: Text(
                  "${reportUsers[index].firstName} ${reportUsers[index].lastName}",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            ),
          );
        },
      ),
    );
  }
}

class ReportAlertBlocView extends StatefulWidget {
  @override
  _ReportAlertBlocViewState createState() => _ReportAlertBlocViewState();
}

class _ReportAlertBlocViewState extends State<ReportAlertBlocView> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(new FocusNode());
      },
      child: BlocProvider<AlertBloc>(
        create: (context) => AlertBloc(),
        child: BlocListener<AlertBloc, AlertState>(
          listener: (context, state) {
            if (state.alertStatus == AlertStatus.reportingUserFailed) {
              Fluttertoast.showToast(msg: "${state.res['message']}");
            } else if (state.alertStatus == AlertStatus.reportedUser) {
              initiateDataAgain();
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ReportSentScreen()));
            }
          },
          child: BlocBuilder<AlertBloc, AlertState>(
            builder: (context, state) {
              if (state.alertStatus == AlertStatus.reportingUser) {
                return ProcessingIndicator(
                  size: size.height * 0.0015,
                );
              }
              return QuestionDialogBox(
                  options: list(),
                  onSubmit: () {
                    print(
                        "SELECTED REPORT USER ALERTID:${selectedReportUser.alertId} \nUSER ID:${selectedReportUser.userId} /nREASON:${selectedReportUser.reason}\n COMMENT:${selectedReportUser.comment}}");
                    context.read<AlertBloc>().add(ReportUser(
                        selectedReportUser.alertId.toString(),
                        selectedReportUser.userId.toString(),
                        selectedReportUser.reason,
                        selectedReportUser.comment));
                  },
                  reportUser: selectedReportUser,
                  onCancel: () {
                    Navigator.of(context).pop();
                  },
                  onChangedcomment: (comment) {
                    setState(() {
                      selectedReportUser.comment = comment;
                    });
                  }
                  // widget.onChangedcomment,
                  );
            },
          ),
        ),
      ),
    );
  }

  initiateDataAgain() {
    _groupValue = -1;
    selectedReportUser.comment = '';
    selectedReportUser.reason = '';
  }

  List<MCQ> items = [
    MCQ(title: "Alerter assaulted me", option: 1),
    MCQ(title: "Alerter was not helpful", option: 2),
    MCQ(title: "Alerter made this situation worse", option: 3),
    MCQ(title: "Alerter did not respect alert type", option: 4),
    MCQ(title: "Alerter created a false alert", option: 5),
    MCQ(title: "Other (optional text box)", option: 6),
  ];

  List<Widget> list() {
    List<Widget> widgets = [];
    for (int i = 0; i < items.length; i++) {
      widgets.add(
        _myRadioButton(
          title: items[i].title,
          value: items[i].option,
          onChanged: (newValue) {
            print(
                "items[i].title items[i].title items[i].title :${items[i].title}");
            setState(() {
              _groupValue = newValue;
              selectedReportUser.reason = items[i].title;
            });
          },
        ),
      );
    }
    return widgets;
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return Container(
      height: 30,
      child: RadioListTile(
        activeColor: MyTheme.primaryColor,
        value: value,
        groupValue: _groupValue,
        onChanged: onChanged,
        title: Text(
          title,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }
}

class ReportUserModel {
  int alertId;
  int userId;
  String firstName;
  String lastName;
  String image;
  String comment = '';
  String reason = '';
  bool isReport;

  ReportUserModel(
      {this.alertId,
      this.userId,
      this.firstName,
      this.lastName,
      this.image,
      this.comment,
      this.reason,
      this.isReport});
}
