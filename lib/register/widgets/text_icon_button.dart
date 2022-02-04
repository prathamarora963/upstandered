import 'package:flutter/material.dart';

class TextIconButton extends StatelessWidget {
  final void Function() onPressed;
   final String text;
   final String iconAsset;
   final Color buttonColor;
   final Color childcolor;
   final double height; 
   final double width;

  const TextIconButton({Key key,
   this.onPressed, this.text, 
   this.iconAsset, this.buttonColor,
    this.childcolor, this.height, this.width}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
        child: Container(
          alignment: Alignment.center,
          height:  height,
          width:  width,
          decoration: BoxDecoration(
            color: buttonColor,
            borderRadius: BorderRadius.circular(5)
          ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              iconAsset, 
              // color: childcolor,
              height: 23,
              width: 23,
            ),
            SizedBox(width:8),
            Text(text, style: TextStyle(
              color: childcolor,
              fontWeight: FontWeight.bold
              
            ),)
            

          ],

        ),
        
      ),
    );
  }
}