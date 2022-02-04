import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';

class PopButton extends StatelessWidget {
  final void Function() onCancel;
  final double fromTop;

  const PopButton({Key key, @required this.onCancel, @required this.fromTop}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: fromTop,
      // left: 20,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back_ios,
          color: MyTheme.black,
          size: 30,
        ),
        onPressed: onCancel,
      ),
    );
  }
}
