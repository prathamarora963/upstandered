import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
class WelcomeDialogBox extends StatelessWidget {
  final void Function() onTap;

  const WelcomeDialogBox({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
    height: size.height * 0.38,
    margin: EdgeInsets.only(left: 12, right: 12),
    padding: const EdgeInsets.all(0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Material(
      borderRadius: BorderRadius.circular(20),
      child:  WelcomeDialogBody(
        onTap: onTap

      ),
    ));
  }
}

class WelcomeDialogBody extends StatelessWidget {
   final void Function() onTap;

  const WelcomeDialogBody({Key key, this.onTap}) : super(key: key);
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
            SizedBox(height: size.height * 0.03),
            Image.asset(
             LOGO_ASSET,
              height: size.height * 0.1,
              width: size.width * 0.2,
              fit: BoxFit.cover,
            ),
            SizedBox(height: size.height * 0.02),
            Text(
              "\"WELCOME TO THE COMMUNITY\nBEFORE YOU CAN REGISTER AS A\nHELPER LET\'S, LEARN HOW TO\nSAFETY HELP OTHERS\"",  
               textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                height: 1.2,
                  fontWeight: FontWeight.bold, color: MyTheme.secondryColor),
            ),
            SizedBox(height: size.height * 0.02),
            
            RoundedBorderTextButton(
              textColor: MyTheme.secondryColor,
              title: "CONTINUE",
              bgColor: MyTheme.primaryColor,
              height: size.height * 0.049,
              width: size.width * 0.3,
              onTap: onTap, 
              borderColor: MyTheme.primaryColor,
               borderRadius: 80,
            )

          ],
        ));
  }
}
