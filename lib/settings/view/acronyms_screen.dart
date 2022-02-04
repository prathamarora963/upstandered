import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/pop_button.dart';
import 'package:upstanders/home/widgets/discreet_alert_description_screen.dart';
import 'package:upstanders/home/widgets/urgent_alert_description_screen.dart';

class AcronymsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "TRAINING SUMMARY",
          style: TextStyle(
            //ACRONYMS
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
      body: AcronymsForm(),
    );
  }
}

class AcronymsForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.all(20),
        child: ListView(children: [
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => UrgentAlertDescriptionScreen(
                      backButton: PopButton(
                        fromTop :32,
                         onCancel: ()=>Navigator.of(context).pop(),
                      ),
                      bottomButton: Container(
                        height: 0,
                        width: 0,
                      ))));
            },
            child: Container(
              alignment: Alignment.center,
              height: size.height * 0.22,
              decoration: BoxDecoration(
                  // color: MyTheme.red,
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(colors: [
                    MyTheme.urgentAlertGradientUp,
                    MyTheme.urgentAlertGradientDown
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Text(
                "URGENT ALERT",
                style: TextStyle(
                    fontSize: size.height * 0.030,// 25,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.black),
              ),
            ),
          ),
          SizedBox(height: size.height * 0.02),
          InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => DiscreetAlertDescriptionScreen(
                      backButton: PopButton(
                        fromTop :32,
                        onCancel: ()=>Navigator.of(context).pop(),
                      ),
                      bottomButton: Container(
                        height: 0,
                        width: 0,
                      ))));
            },
            child: Container(
              alignment: Alignment.center,
              height: size.height * 0.22,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(colors: [
                    MyTheme.discreetAlertGradientUp,
                    MyTheme.discreetAlertGradientDown
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
              child: Text(
                "DISCREET ALERT",
                style: TextStyle(
                    fontSize:size.height * 0.030,// 25,
                    fontWeight: FontWeight.bold,
                    color: MyTheme.black),
              ),
            ),
          )
        ]));
  }
}
