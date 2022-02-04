import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
class DiscreetAlertDescriptionScreen extends StatelessWidget {
  final Widget bottomButton;
  final Widget backButton;

  const DiscreetAlertDescriptionScreen(
      {Key key, this.bottomButton, this.backButton})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: MyTheme.white,
        body: Stack(
          children: [
            _Foreground(),
            backButton
            // (context),
          ],
        ),
        bottomNavigationBar: bottomButton);
  }
}

class _Foreground extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
           LOGO_ASSET,
            height:  size.height * 0.088,// 80,
            width: size.height * 0.088, //80,
          ),
          SizedBox(
            height: size.height * 0.01,
          ),
          Text(
            "DISCREET ALERT.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: size.height * 0.030,// 25,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: MyTheme.black),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          new RichText(
            textAlign: TextAlign.center,
            strutStyle: StrutStyle(
              fontSize: size.height * 0.028,//20,
            ),
            text: new TextSpan(
              style: DefaultTextStyle.of(context).style,
              // TextStyle(color: Colors.black,fontSize: 20, height: 1.4),

              children: [
                new TextSpan(
                  text: "Thank you for responding.\nHere's what to do:\n",
                  style: new TextStyle(
                      color: Colors.black, fontSize:  size.height * 0.028, height: 1.4), //20
                ),
                new TextSpan(
                  text: "Check safety\n",
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: size.height * 0.028, //20
                      height: 1.4),
                ),
                new TextSpan(
                  text:
                      "(physical and emotional).\ncheck if things have escalated.\n",
                  style: new TextStyle(
                      color: Colors.black, fontSize:  size.height * 0.028, height: 1.4),
                ),
                new TextSpan(
                  text: "Distract Or Disrupt\n",
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:  size.height * 0.028,
                      height: 1.4),
                ),
                new TextSpan(
                  text:
                      "Discreetly separate the alerter\nfrom the potential harm doer,\nwithout mentioning the alert.\n",
                  style: new TextStyle(
                      color: Colors.black, fontSize:  size.height * 0.028, height: 1.4),
                ),
                new TextSpan(
                  text: "Stabilize\n",
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:  size.height * 0.028,
                      height: 1.4),
                ),
                new TextSpan(
                  text:
                      "Make sure everyone is ok and\nknows where to find support.\n",
                  style: new TextStyle(
                      color: Colors.black, fontSize:  size.height * 0.028, height: 1.4),
                ),
                new TextSpan(
                  text: "Maintain accountability\n",
                  style: new TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize:  size.height * 0.028,
                      height: 1.4),
                ),
                new TextSpan(
                  text:
                      "In case of immediate danger,\ncall the police. Any other help\nneeds to answer an explicit request.",
                  style: new TextStyle(
                      color: Colors.black, fontSize:  size.height * 0.028, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
