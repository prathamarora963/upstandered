import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:upstanders/common/constants/asset_constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/common/widgets/user_avatar.dart';
import 'package:upstanders/home/bloc/alert_bloc.dart';
import 'package:upstanders/home/data/model/alert_data_model.dart';
import 'package:upstanders/home/widgets/enter_pin_screen.dart';

/**
 * Register Success Dialog Box
 */

class RegisterSuccessDialogBox extends StatelessWidget {
  final void Function() onContinue;
  final void Function() onCancel;

  const RegisterSuccessDialogBox({Key key, this.onContinue, this.onCancel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.5,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: registerBody(context)
        ));
  }

  registerBody(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.02),
            Image.asset(
              LOGO_ASSET,
              height: size.height * 0.1,
              width: size.width * 0.2,
              fit: BoxFit.cover,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "We verify IDs for everyone's safety",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: size.height * 0.026, //27
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.secondryColor),
            ),
            SizedBox(height: size.height * 0.015),
            Text(
              "New users won't be able to call for\nhelp or go on active duty until\ntheir id is verified.",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: size.height * 0.023, //25
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.secondryColor),
            ),
            SizedBox(height: size.height * 0.008),
            Text(
              "If you have been reported for\ninappropriate behavior, you might\nnot be able to re-register, sorry..",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: size.height * 0.023, //25
                  height: 1.2,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.secondryColor),
            ),
            SizedBox(height: size.height * 0.03),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: onCancel,
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                          fontSize: size.height * 0.025,
                          color: MyTheme.black,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 30),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "CONTINUE",
                  fontSize: size.height * 0.025,
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.055,
                  width: size.width * 0.4,
                  onTap: onContinue,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 80,
                )
              ],
            )
          ],
        ));
  }
}



/**
 * Active Inactive Dialog Box 
 */

class ActiveInactiveDialogBox extends StatelessWidget {
  final void Function() onContinue;
  final void Function() onCancel;

  const ActiveInactiveDialogBox({Key key, this.onContinue, this.onCancel})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.45,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
            borderRadius: BorderRadius.circular(20),
            child: _activeInactiveBody(size)));
  }

  _activeInactiveBody(Size size) {
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.02),
            Image.asset(
              LOGO_ASSET,
              height: size.height * 0.1,
              width: size.width * 0.2,
              fit: BoxFit.cover,
            ),
            SizedBox(height: size.height * 0.02),
            FittedBox(
              fit: BoxFit.fitWidth,
              child: Text(
                "Please watch the following\nshort videos and answer the\nmultiple choice questions\nto ensure you know what\nto do when alerted.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: size.height * 0.033, //22
                    height: 1.3,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                    onTap: onCancel,
                    child: Text(
                      "CANCEL",
                      style: TextStyle(
                          fontSize: size.height * 0.025, //18,
                          color: MyTheme.black,
                          fontWeight: FontWeight.bold),
                    )),
                SizedBox(width: 30),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "CONTINUE",
                  fontSize: size.height * 0.025, //18,
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.055,
                  width: size.width * 0.4,
                  onTap: onContinue,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 80,
                )
              ],
            )
          ],
        ));
  }
}

////////// HelpNeeded Dialog Box ///////////

class HelpNeededDialogBox extends StatelessWidget {
  final void Function() illgo;
  final void Function() icant;

  const HelpNeededDialogBox(
      {Key key, @required this.illgo, @required this.icant})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.28,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: HelpNeededDialogBody(
            illgo: illgo,
            icant: icant,
          ),
        ));
  }
}

class HelpNeededDialogBody extends StatelessWidget {
  final void Function() illgo;
  final void Function() icant;

  const HelpNeededDialogBody(
      {Key key, @required this.illgo, @required this.icant})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.02),
            RoundedBorderTextButton(
              textColor: MyTheme.secondryColor,
              bgColor: MyTheme.white,
              borderColor: MyTheme.secondryColor,
              borderRadius: 5,
              title: "HELP NEEDED",
              fontSize: 20,
              height: size.height * 0.049,
              width: size.width * 0.4,
              onTap: () {},
            ),
            SizedBox(height: size.height * 0.01),
            ListTile(
              //  minLeadingWidth: 40,
              leading: UserAvatarAsset(
                avatarRadius: size.height * 0.07,
                asset: "assets/users/CrystalGaskell.png",
                // imageUrl:
                //     "https://img.mensxp.com/media/content/2020/Aug/Michele-Morrone-From-365-Days-Floored-Us-With-His-Fashion-Game-1200x900_5f2a761253b66_1200x900.jpeg"
              ),
              title: Text(
                "CRYSTAL GASKELL",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
              subtitle: Text(
                "200m away",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "I CAN'T",
                  bgColor: MyTheme.red,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: icant,
                  borderColor: MyTheme.red,
                  borderRadius: 8,
                  fontSize: 20,
                ),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "I'LL GO",
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: icant,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 8,
                  fontSize: 20,
                ),
              ],
            )
          ],
        ));
  }
}

////////// Ill And Icant Dialog Body ///////////

class IllAndIcantDialogBox extends StatelessWidget {
  final void Function() illgo;
  final void Function() icant;
  final String title;
  final LinearGradient gradient;
  final NotificationDataModel notificationDataModel;

  const IllAndIcantDialogBox({
    Key key,
    @required this.illgo,
    @required this.icant,
    @required this.title,
    @required this.notificationDataModel,
    @required this.gradient,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.28,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: IllAndIcantDialogBody(
              title: title,
              illgo: illgo,
              icant: icant,
              notificationDataModel: notificationDataModel,
              gradient: gradient),
        ));
  }
}

class IllAndIcantDialogBody extends StatelessWidget {
  final void Function() illgo;
  final void Function() icant;
  final String title;
  final LinearGradient gradient;

  final NotificationDataModel notificationDataModel;

  const IllAndIcantDialogBody({
    Key key,
    @required this.illgo,
    @required this.icant,
    @required this.title,
    @required this.notificationDataModel,
    @required this.gradient,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: size.width,
                height: size.height * 0.065,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$title ALERT",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.secondryColor),
                    ),
                    SizedBox(width: 10),
                    Image.asset(
                      ALERT_ASSET,
                      height: 30,
                      width: 30,
                    ),
                  ],
                )),
            SizedBox(height: size.height * 0.01),
            ListTile(
              leading: UserAvatarNetwok(
                avatarRadius: size.height * 0.07,
                networkImage: "${notificationDataModel.senderImage}",
              ),
              title: Text(
                notificationDataModel.senderName,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
              subtitle: Text(
                "${notificationDataModel.distance.split(".")[0]}m away",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "I CAN'T",
                  bgColor: MyTheme.red,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: icant,
                  borderColor: MyTheme.red,
                  borderRadius: 8,
                  fontSize: 20,
                ),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "I'LL GO",
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: illgo,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 8,
                  fontSize: 20,
                )
              ],
            )
          ],
        ));
  }
}

class IllGoBlocView extends StatelessWidget {
  final void Function() illgo;
  final AlertBloc alertBloc;

  const IllGoBlocView({Key key, this.illgo, this.alertBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocBuilder<AlertBloc, AlertState>(
      bloc: alertBloc,
      builder: (context, state) {
        if (state.alertStatus == AlertStatus.acceptingAlert) {
          return ProcessingIndicator(
            size: size.height * 0.0015,
          );
        }

        return RoundedBorderTextButton(
          textColor: MyTheme.secondryColor,
          title: "I'LL GO",
          bgColor: MyTheme.primaryColor,
          height: size.height * 0.06,
          width: size.width * 0.38,
          onTap: illgo,
          borderColor: MyTheme.primaryColor,
          borderRadius: 8,
          fontSize: 20,
        );
      },
    );
  }
}

////// Report To Anyone Dialog Box /////////
class ReportToAnyoneDialogBox extends StatelessWidget {
  final void Function() onLater;
  final void Function() onContinue;

   ReportToAnyoneDialogBox({
    Key key,
    @required this.onLater,
    @required this.onContinue,
  }) : super(key: key);
   double startPoint = 30;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.3,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              height: size.height * 0.065,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Text(
                "REPORT ANYONE?",
                style: TextStyle(
                    fontSize: size.height * 0.020, //18,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              // color: MyTheme.red,
              // width: size.width,
              height: size.height * 0.14,
              alignment: Alignment.center,
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: stackedUsers(size)),
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "NOTHING TO REPORT", //LATER
                  bgColor: MyTheme.white,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onLater,
                  borderColor: MyTheme.white,
                  borderRadius: 8,
                  fontSize: size.height * 0.020, //18
                ),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "CONTINUE",
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onContinue,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 80,
                  fontSize: size.height * 0.020, //18,
                ),
              ],
            )
          ],
        )),
        ));
  }
  List<Widget> stackedUsers(Size size) {
    List<Widget> users = [];
    print("USER LENGTH :${getAlertDetailsModel.alertData.user.length}");
    getAlertDetailsModel.alertData.user.forEach((element) {
      startPoint = startPoint + 30;
      users.add(
        Positioned(
            left: startPoint,
            child: UserAvatarNetwok(
                avatarRadius: size.height * 0.08, networkImage: element.image)),
      );
    });
    return users;
  }
}



class ReportToAnyoneDialogBody extends StatelessWidget {
  final void Function() onLater;
  final void Function() onContinue;

  ReportToAnyoneDialogBody(
      {Key key, @required this.onLater, @required this.onContinue})
      : super(key: key);
  double startPoint = 30;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              height: size.height * 0.065,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Text(
                "REPORT ANYONE?",
                style: TextStyle(
                    fontSize: size.height * 0.020, //18,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            Container(
              // color: MyTheme.red,
              // width: size.width,
              height: size.height * 0.14,
              alignment: Alignment.center,
              child: Stack(
                  alignment: AlignmentDirectional.center,
                  children: stackedUsers(size)),
            ),
            SizedBox(height: size.height * 0.01),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "NOTHING TO REPORT", //LATER
                  bgColor: MyTheme.white,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onLater,
                  borderColor: MyTheme.white,
                  borderRadius: 8,
                  fontSize: size.height * 0.020, //18
                ),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "CONTINUE",
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onContinue,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 80,
                  fontSize: size.height * 0.020, //18,
                ),
              ],
            )
          ],
        ));
  }

  //shruti
  List<Widget> stackedUsers(Size size) {
    List<Widget> users = [];
    print("USER LENGTH :${getAlertDetailsModel.alertData.user.length}");
    getAlertDetailsModel.alertData.user.forEach((element) {
      startPoint = startPoint + 30;
      users.add(
        Positioned(
            left: startPoint,
            child: UserAvatarNetwok(
                avatarRadius: size.height * 0.08, networkImage: element.image)),
      );
    });
    return users;
  }
}

////// Ended alert Dialog Box /////////
class EndedAlertDialogBox extends StatelessWidget {
  final void Function() onContinue;
  final NotificationDataModel notificationDataModel;
  const EndedAlertDialogBox({
    Key key,
    @required this.onContinue,
    @required this.notificationDataModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.28,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: EndedAlertDialogBody(
              onContinue: onContinue,
              notificationDataModel: notificationDataModel),
        ));
  }
}

class EndedAlertDialogBody extends StatelessWidget {
  final void Function() onContinue;
  final NotificationDataModel notificationDataModel;

  const EndedAlertDialogBody({
    Key key,
    @required this.onContinue,
    @required this.notificationDataModel,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: size.width,
                height: size.height * 0.09,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: MyTheme.primaryColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "ALERT ENDED",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: size.height * 0.023, //18,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.secondryColor),
                    ),
                    Text(
                      "THANK YOU FOR HELPING",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: size.height * 0.023,
                          color: MyTheme.black), //18
                    ),
                  ],
                )),
            SizedBox(height: size.height * 0.01),
            Container(
              margin: const EdgeInsets.only(left: 30),
              child: ListTile(
                //  minLeadingWidth: 40,
                leading: UserAvatarNetwok(
                  avatarRadius: size.height * 0.07,
                  networkImage: notificationDataModel.senderImage,
                ),
                title: Text(
                  notificationDataModel.senderName,
                  // "CRYSTAL GASKELL",
                  style: TextStyle(
                      fontSize: size.height * 0.023, //18,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.secondryColor),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
            RoundedBorderTextButton(
              textColor: MyTheme.secondryColor,
              title: "CONTINUE",
              bgColor: MyTheme.primaryColor,
              height: size.height * 0.06,
              width: size.width * 0.38,
              onTap: onContinue,
              borderColor: MyTheme.primaryColor,
              borderRadius: 80,
              fontSize: size.height * 0.026, //20
            ),
          ],
        ));
  }
}

////HELPING SUCCESS DIALOG BOX
class HelpingSuccessDialogBox extends StatelessWidget {
  final void Function() onContinue;

  const HelpingSuccessDialogBox({Key key, this.onContinue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.25,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: HelpingSuccessDialogBody(onContinue: onContinue),
        ));
  }
}

class HelpingSuccessDialogBody extends StatelessWidget {
  final void Function() onContinue;

  const HelpingSuccessDialogBody({Key key, this.onContinue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: size.height * 0.02),
            RoundedBorderTextButton(
              textColor: MyTheme.secondryColor,
              bgColor: MyTheme.white,
              borderColor: MyTheme.secondryColor,
              borderRadius: 5,
              title: "THANKS FOR HELP",
              fontSize: size.height * 0.026, //20,
              height: size.height * 0.049,
              width: size.width * 0.6,
              onTap: onContinue,
            ),
            SizedBox(height: size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                UserAvatarAsset(
                  avatarRadius: size.height * 0.07,
                  asset: "assets/users/CrystalGaskell.png",
                ),
                Text(
                  "CRYSTAL GASKELL",
                  style: TextStyle(
                      fontSize: size.height * 0.23, //18,
                      fontWeight: FontWeight.bold,
                      color: MyTheme.secondryColor),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            RoundedBorderTextButton(
              textColor: MyTheme.secondryColor,
              title: "CONTINUE",
              bgColor: MyTheme.primaryColor,
              height: size.height * 0.06,
              width: size.width * 0.38,
              onTap: onContinue,
              borderColor: MyTheme.primaryColor,
              borderRadius: 80,
              fontSize: size.height * 0.026, //20,
            ),
          ],
        ));
  }
}

////CONGRATULATION DIALOG BOX
class CongratulationDialogBox extends StatelessWidget {
  final void Function() onContinue;

  const CongratulationDialogBox({Key key, this.onContinue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.25,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: CongratulationDialogBody(onContinue: onContinue),
        ));
  }
}

class CongratulationDialogBody extends StatelessWidget {
  final void Function() onContinue;

  const CongratulationDialogBody({Key key, this.onContinue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: size.height * 0.06,
              width: size.width,
              decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Text(
                "Congratulations",
                style: TextStyle(
                    fontSize: size.height * 0.026, //20,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
            SizedBox(height: size.height * 0.04),
            Text(
              "Your pin has been changed",
              style: TextStyle(
                  fontSize: size.height * 0.020, //18,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.secondryColor),
            ),
            SizedBox(height: size.height * 0.04),
            RoundedBorderTextButton(
              textColor: MyTheme.secondryColor,
              title: "CONTINUE",
              bgColor: MyTheme.primaryColor,
              height: size.height * 0.06,
              width: size.width * 0.38,
              onTap: onContinue,
              borderColor: MyTheme.primaryColor,
              borderRadius: 80,
              fontSize: size.height * 0.026, //20
            ),
          ],
        ));
  }
}

////LOGOUT DIALOG BOX
class AreYouSureDialogBox extends StatelessWidget {
  final void Function() onEvent;
  final void Function() onCancel;
  final String heading;
  final String description;
  final double fontSize;

  const AreYouSureDialogBox(
      {Key key,
      @required this.onEvent,
      @required this.onCancel,
      @required this.heading,
      this.fontSize,
      @required this.description})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.25,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: _logoutDialogBody(size),
        ));
  }

  _logoutDialogBody(Size size) {
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.center,
              height: size.height * 0.06,
              width: size.width,
              decoration: BoxDecoration(
                  color: MyTheme.primaryColor,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  )),
              child: Text(
                "$heading?",
                style: TextStyle(
                    fontSize: size.height * 0.026, //20,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
            // SizedBox(height: size.height * 0.02),

            SizedBox(height: size.height * 0.04),
            Text(
              description,
              style: TextStyle(
                  fontSize: size.height * 0.023, // ,18,
                  fontWeight: FontWeight.bold,
                  color: MyTheme.secondryColor),
            ),

            SizedBox(height: size.height * 0.04),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: "CANCEL",
                  bgColor: MyTheme.white,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onCancel,
                  borderColor: MyTheme.white,
                  borderRadius: 80,
                  fontSize: size.height * 0.026, //20,
                ),
                RoundedBorderTextButton(
                  textColor: MyTheme.secondryColor,
                  title: heading.toUpperCase(),
                  bgColor: MyTheme.primaryColor,
                  height: size.height * 0.06,
                  width: size.width * 0.38,
                  onTap: onEvent,
                  borderColor: MyTheme.primaryColor,
                  borderRadius: 80,
                  fontSize: fontSize,
                ),
              ],
            )
          ],
        ));
  }
}

////WINING LOSING DIALOG BOX
class WiningLoseDialogBox extends StatelessWidget {
  final void Function() onContinue;

  const WiningLoseDialogBox({Key key, this.onContinue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.5,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          // color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: WiningLoseBody(onContinue: onContinue),
        ));
  }
}

class WiningLoseBody extends StatelessWidget {
  final void Function() onContinue;

  const WiningLoseBody({Key key, this.onContinue}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _winLose(size),
            SizedBox(height: size.height * 0.04),
            _mid(size),
            SizedBox(height: size.height * 0.06),
            RoundedBorderTextButton(
              textColor: MyTheme.secondryColor,
              title: "BACK TO HOME",
              bgColor: MyTheme.primaryColor,
              height: size.height * 0.06,
              width: size.width * 0.5,
              onTap: onContinue,
              borderColor: MyTheme.primaryColor,
              borderRadius: 80,
              fontSize: 20,
            ),
          ],
        ));
  }

  _winLose(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.1,
      width: size.height * 0.1,
      decoration: BoxDecoration(
          color: MyTheme.primaryColor,
          shape: BoxShape.circle,
          image: DecorationImage(
              image: AssetImage(LOGO_ASSET), fit: BoxFit.cover)),
    );
  }

  _mid(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.15,
      width: size.width,
      decoration: BoxDecoration(
        color: MyTheme.primaryColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _chip(size, "Total\nQuestions", "5", MyTheme.secondryColor),
          _chip(size, "Correct", "1", MyTheme.green),
          _chip(size, "Wrong", "4", MyTheme.red),
        ],
      ),
    );
  }

  _chip(Size size, String title, String score, Color scoreColor) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: MyTheme.secondryColor),
        ),
        SizedBox(height: size.height * 0.01),
        Container(
          alignment: Alignment.center,
          height: size.height * 0.05,
          width: size.height * 0.05,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MyTheme.white,
          ),
          child: Text(
            score,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.bold, color: scoreColor),
          ),
        )
      ],
    );
  }
}

// ignore: slash_for_doc_comments
/**
 * Notification DialogBox 
 */
class NotificationDialogBox extends StatelessWidget {
  final void Function() onHangUp;
  final void Function() onRecieve;
  final NotificationDataModel notificationDataModel;
  final String notiMsg;

  const NotificationDialogBox(
      {Key key,
      this.onHangUp,
      this.onRecieve,
      @required this.notificationDataModel,
      @required this.notiMsg})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var bordeRadius = size.height * 0.02;
    var marginLeftRight = size.height * 0.012;
    var paddingeftRightTop = size.height * 0.01;
     var paddingFromLeft = size.height * 0.015;
    
    return Container(
        height: size.height * 0.14,
        margin: EdgeInsets.only(left:marginLeftRight, right: marginLeftRight),
        padding:  EdgeInsets.only(left: paddingeftRightTop,  right: paddingeftRightTop, top: paddingeftRightTop),
        decoration: BoxDecoration(
          color: MyTheme.primaryColor,
          borderRadius: BorderRadius.circular(bordeRadius),
        ),
        child: Material(
          color: MyTheme.primaryColor,
          borderRadius: BorderRadius.circular(bordeRadius),
          child: Column(
              children: [
                Align(
                  heightFactor: 0.0,
                  alignment :Alignment.topLeft,
                  child: InkWell(
                        onTap: onHangUp,
                        child: Image.asset(
                          CIRCULAR_CROSS_ASSET,
                          height: size.height * 0.04,
                          width: size.height * 0.04,
                        )),
                ),
                Padding(
                  padding:  EdgeInsets.only(left: paddingFromLeft),
                  child: ListTile(
                    tileColor: MyTheme.primaryColor,
                    leading: UserAvatarNetwok(
                      avatarRadius: size.height * 0.07,
                      networkImage: notificationDataModel.senderImage,
                    ),
                    title: Text(
                      "${notificationDataModel.senderName}",
                      style: TextStyle(
                          fontSize: size.height * 0.025,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.secondryColor),
                    ),
                    subtitle: Text(
                      notiMsg,
                      style: TextStyle(
                          fontSize: size.height * 0.023,
                          fontWeight: FontWeight.bold,
                          color: MyTheme.secondryColor),
                    ),
                  ),
                ),
              ],
            )
        ));
  }
}



///////MESSAGE DIALOG BOX/////////
class MessageDialogBox extends StatelessWidget {
  final void Function() onOkay;
  final String message;

  const MessageDialogBox(
      {Key key, @required this.onOkay, @required this.message})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        height: size.height * 0.15,
        margin: EdgeInsets.only(left: 12, right: 12),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Material(
          borderRadius: BorderRadius.circular(20),
          child: MessageDialogBody(
            message: message,
            onOkay: onOkay,
          ),
        ));
  }
}

class MessageDialogBody extends StatelessWidget {
  final void Function() onOkay;
  final String message;

  const MessageDialogBody({Key key, this.onOkay, this.message})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        decoration: BoxDecoration(
            color: MyTheme.primaryColor,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                InkWell(
                    onTap: onOkay,
                    child: Image.asset(
                      CIRCULAR_CROSS_ASSET,
                      height: 20,
                      width: 20,
                    )),
              ],
            ),
            ListTile(
              subtitle: Text(
                message,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.secondryColor),
              ),
            ),
          ],
        ));
  }
}
