import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';

class BottomButton extends StatelessWidget {
  final void Function() onTap;

  const BottomButton({Key key, this.onTap}) : super(key: key);
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
          "CONTINUE",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: MyTheme.black),
        ),
      ),
    );
  }
}
