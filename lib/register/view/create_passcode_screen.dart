
import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';
import 'package:upstanders/register/view/view.dart';
import 'package:upstanders/register/widgets/widgets.dart';

class CreatePasscodeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
  Size size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text("CREATE PASSCODE", style: TextStyle(
          color: MyTheme.secondryColor,
          fontWeight: FontWeight.bold,
          // fontSize :size.height * 0.
        ),),
        
        // leading: IconButton(
        //   icon: Icon(Icons.arrow_back_ios, color: MyTheme.secondryColor,),
        //   onPressed: (){
        //     Navigator.of(context).pop();
        //   },
        // ),
      ),
      body: _CreatePasscodeForm(),
      
    );
  }
}

class _CreatePasscodeForm extends StatelessWidget {
  TextEditingController pin1Controller = TextEditingController();
  TextEditingController pin2Controller = TextEditingController();
  TextEditingController pin3Controller = TextEditingController();
  TextEditingController pin4Controller = TextEditingController();
  TextEditingController _codePutController = TextEditingController();

  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
     final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    );
    return Container(
      width: size.width,
      height: size.height,
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              "Enter your passcode",
              style: TextStyle(
                  color: MyTheme.white,
                  fontSize: 20,
                  height: 2.000,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.06),
            _rowInputs(),
            //  PinPut(
            //   validator: (s) {
            //     if (s.contains('1')) return null;
            //     return 'NOT VALID';
            //   },
            //   useNativeKeyboard: true,
            //   // autovalidateMode: AutovalidateMode.onUserInteraction,
            //   withCursor: true,
            //   fieldsCount: 5,
            
            //   // obscureText: ".",
            //   fieldsAlignment: MainAxisAlignment.spaceAround,
            //   textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
            //   eachFieldMargin: EdgeInsets.all(0),
            //   eachFieldWidth: 50.0,
            //   eachFieldHeight: 50.0,
            //   onSubmit: (String pin) {},
            //   autofocus: true,
            //   // focusNode: _pinPutFocusNode.,
            //   controller: _codePutController,
            //   submittedFieldDecoration: pinPutDecoration,
            //   selectedFieldDecoration: pinPutDecoration.copyWith(
            //     color: Colors.white,
            //     border: Border.all(
            //       width: 2,
            //       color: MyTheme.primaryColor,
            //     ),
            //   ),
            //   followingFieldDecoration: pinPutDecoration,
            //   pinAnimationType: PinAnimationType.scale,
            // ),
           
          
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: const EdgeInsets.only(bottom: 20),
                child: RoundedBorderTextButton(
                  fontSize: 18,
                  title: "CREATE",
                  height: size.height * 0.06,
                  width: size.width / 2.7,
                  bgColor: MyTheme.primaryColor,
                  textColor: MyTheme.secondryColor,
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => CreateProfileScreen(isEnablePopButton: true,)));
                  },
                   borderColor: MyTheme.primaryColor, 
                  borderRadius: 80,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _rowInputs() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
    PinCodeTextEditField(
      controller: pin1Controller,
    ),
    // SizedBox(width:6),
    PinCodeTextEditField(
      controller: pin2Controller,
    ),
    // SizedBox(width:6),
    PinCodeTextEditField(
      controller: pin3Controller,
    ),
    // SizedBox(width:6),
    PinCodeTextEditField(
          controller: pin4Controller,
    ),
   
        ],
      );
  }
}
