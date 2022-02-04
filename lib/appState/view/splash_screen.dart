import 'package:flutter/material.dart';
import 'package:upstanders/appState/constants/constants.dart';
import 'package:upstanders/appState/view/view.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(SPLASH_BACKGROUND_ASSET),
                    fit: BoxFit.fill)),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              children: [
                SizedBox(height: size.height * 0.25),
                AnimatedLogo(isSplash: true,),
                SizedBox(height: size.height * 0.018),
                Text(
                  HEADING_TEXT,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: MyTheme.secondryColor,
                      fontSize: size.height * 0.028),
                )
              ],
            )
          ),
        ],
      ),
    );
  }
}
