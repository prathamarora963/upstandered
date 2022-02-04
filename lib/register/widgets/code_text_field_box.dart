import 'package:flutter/material.dart';


class CodeTextFieldBox extends StatelessWidget {
  final TextEditingController controller;
  

  const CodeTextFieldBox({Key key, this.controller, })
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      // width: size.width / 5.5,
      height: size.height * 0.09,
      child: Container(
       padding: EdgeInsets.all(5),
       alignment: Alignment.center,
        
       child: TextFormField(
         
         maxLength: 1,
         style: TextStyle(fontSize:30),
         keyboardType: TextInputType.number,
         textAlign: TextAlign.center,
         controller: controller,
         decoration: InputDecoration(
           
             filled: true,
             fillColor: Colors.white,
             counterText: "",
            //  border: InputBorder.none
              border: new OutlineInputBorder(
              borderRadius: const BorderRadius.all(
                const Radius.circular(15.0),
              ))
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
