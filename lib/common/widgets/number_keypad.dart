import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';


class NumberKeypad extends StatelessWidget {
 final TextEditingController pinCodeController;
 final void Function(int) onNumber;
 final void Function() onClear;
 final void Function() onZero;


  const NumberKeypad({this.pinCodeController, this.onClear, this.onNumber, this.onZero}) ;
  @override
  Widget build(BuildContext context) {
    return  Expanded(
      child: Container(
        child: GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          crossAxisSpacing: 20,
          mainAxisSpacing: 00,
          padding: const EdgeInsets.all(30),
          physics: NeverScrollableScrollPhysics(),
          children: [
            ...[1, 2, 3, 4, 5, 6, 7, 8, 9, ].map((e) {
              return KeyButton(
                title: '$e',
                onTap:(){
                  onNumber(e);
                }
                //  () {
                //   pinCodeController.text = '${pinCodeController.text}$e';
                //   print(" pinCodeController.text:${ pinCodeController.text}");
                // },
              );
            }),
            KeyButton(
              title: '',
              onTap: () {
                
              },
            ),
            KeyButton(
              title: '0',
              onTap: onZero
              // () {
              //   pinCodeController.text = '${pinCodeController.text}0';
              // },
            ),
            
            IconButton(
              icon: Icon(Icons.backspace_outlined, color: MyTheme.grey,),
                onPressed:onClear
              //    (){
              //     if (pinCodeController.text.isNotEmpty) {
              //     pinCodeController.text = pinCodeController.text
              //         .substring(0, pinCodeController.text.length - 1);
              //   }
                  
              // }
              )
          ],
        ),
      ),
    ); 
    
  }
}


class KeyButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  KeyButton({this.title, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            // shape: BoxShape.circle,
            // color: const Color.fromRGBO(25, 21, 99, 1),
            color: MyTheme.white),
        alignment: Alignment.center,
        child: Text(
          '$title',
          style: TextStyle(fontSize: 35, color: MyTheme.black),
        ),
      ),
    );
  }
}


