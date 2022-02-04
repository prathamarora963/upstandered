import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/home/view/home_screen.dart';

class RightOnScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: [
            _BG(),
            _Foreground(),
            //
          ],
        ),
        bottomNavigationBar: _BottomButton(onTap: () {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => HomeScreen()),
              (route) => false); //MapViewScreen
        }));
  }
}

class _BG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage(RIGHT_ON_ASSET),
              fit: BoxFit.cover)),
    );
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
          Text(
            "RIGHT ON!",
            style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: MyTheme.black),
          ),
          SizedBox(
            height: size.height * 0.03,
          ),
          Text(
            "You've answered all the questions\ncorrectly. watch the videos again\nin the top left menu of the home\npage if you need to. A reminder\nwill be displayed when you\naccept an alert.",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20,
                height: 1.5,
                fontWeight: FontWeight.bold,
                color: MyTheme.black),
          ),
        ],
      ),
    );
  }
}

class _BottomButton extends StatelessWidget {
  final void Function() onTap;

  const _BottomButton({Key key, this.onTap}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: size.height * 0.08,
        color: MyTheme.primaryColor,
        child: Text(
          "BACK TO HOME",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: MyTheme.black),
        ),
      ),
    );
  }
}
