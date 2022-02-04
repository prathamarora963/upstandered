import 'package:flutter/material.dart';

class PinCodeTextEditField extends StatelessWidget {
  final TextEditingController controller;
  

  const PinCodeTextEditField({Key key, this.controller, })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.15,
      height: size.height * 0.09,
      child: Container(
      //  margin: EdgeInsets.all(5),
       alignment: Alignment.center,
        
       child: TextFormField(
         autofocus: true,
         obscureText: true,
        //  obscuringCharacter: ".",
         maxLength: 1,
         style: TextStyle(
           color: Colors.white,
           fontSize:30),
         keyboardType: TextInputType.number,
         textAlign: TextAlign.center,
         controller: controller,
         decoration: InputDecoration(
             filled: true,
            //  fillColor: Colors.white,
             counterText: "",
             border: InputBorder.none
              // border: new OutlineInputBorder(
              // borderRadius: const BorderRadius.all(
              //   const Radius.circular(15.0),
              // ))
              ),
            
          
         validator: (value) {
           if (value.isEmpty) {
           
             return null;
           }
          
           return null;
         },
       ),
        ),
    );
  }
}
