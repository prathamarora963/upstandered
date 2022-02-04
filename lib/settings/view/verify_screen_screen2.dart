import 'package:flutter/material.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/common/widgets/buttons.dart';

class VerifyAccountScreen2 extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text("VERIFY YOUR ACCOUNT", style: TextStyle(
          color: MyTheme.secondryColor,
        ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: MyTheme.secondryColor,),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: _VerifyAccountForm(),
    );
  }
}



class _VerifyAccountForm extends StatelessWidget {
  
  TextEditingController _pinPutController = TextEditingController();
  @override
  Widget build(BuildContext context) {
  final size = MediaQuery.of(context).size;
   final BoxDecoration pinPutDecoration = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15.0),
    );
    return Container(
       padding: const EdgeInsets.only(left:25, right: 25, top: 20),
      child: SingleChildScrollView(
         child: Column(
          children: [
             Text("Enter the confirmation code we sent to\n+91 9876543210",
              style: TextStyle(
                color: MyTheme.white,
                fontSize: 16,
                height: 2.000, 
                fontWeight: FontWeight.bold),
              ),
            
              SizedBox(height: size.height * 0.06),
            
            // _rowInputs(),

            // PinCodeTextField(
            //   obscureText: true,
            //   pinTheme: PinTheme(
            //     shape: PinCodeFieldShape.box,
            //     borderRadius: BorderRadius.circular(15),
            //     fieldHeight: 50,
            //     fieldWidth: 50,
            //     activeFillColor: Colors.white,
            //     inactiveColor: Colors.white,
            //     activeColor: Colors.white,
            //     selectedFillColor:  Colors.white,
                
                
            //   ),
            //   appContext: context,
            //   length: 5,
            //   backgroundColor: Colors.transparent,
              
            //   textStyle:
            //       TextStyle(
            //         color: MyTheme.black,
            //         fontSize: 22,),
            //   onChanged: (value) {
            //     // _otpCtrl.text = value;
            //   },
            //   enablePinAutofill: true,
            //   enableActiveFill: true,
            
            //   keyboardType: TextInputType.number,
            //   beforeTextPaste: (text) {
            //     print("Allowing to paste $text");
            //     return true;
            //   },
            // ),
            // 
            PinPut(
              validator: (s) {
                if (s.contains('1')) return null;
                return 'NOT VALID';
              },
              useNativeKeyboard: true,
              // autovalidateMode: AutovalidateMode.onUserInteraction,
              withCursor: true,
              fieldsCount: 5,
              fieldsAlignment: MainAxisAlignment.spaceAround,
              textStyle: const TextStyle(fontSize: 25.0, color: Colors.black),
              eachFieldMargin: EdgeInsets.all(0),
              eachFieldWidth: 50.0,
              eachFieldHeight: 50.0,
              onSubmit: (String pin) {},
              autofocus: true,
              // focusNode: _pinPutFocusNode.,
              controller: _pinPutController,
              submittedFieldDecoration: pinPutDecoration,
              selectedFieldDecoration: pinPutDecoration.copyWith(
                color: Colors.white,
                border: Border.all(
                  width: 2,
                  color: MyTheme.primaryColor,
                ),
              ),
              followingFieldDecoration: pinPutDecoration,
              pinAnimationType: PinAnimationType.scale,
            ),
             SizedBox(height: size.height * 0.06),

             RoundedBorderTextButton(
               title: "VERIFY ME",
               height: size.height * 0.06,
               width: size.width,
               fontSize :18,
               bgColor: MyTheme.primaryColor,
               textColor: MyTheme.secondryColor,
               onTap:(){
                  Navigator.of(context).pop();
                   Navigator.of(context).pop();
               }, 
                borderColor:  MyTheme.primaryColor,
                 borderRadius: 80,
             ),
             SizedBox(height: size.height * 0.02),
            _resendCodeButton(size, context)

          ],
        ),
      ),
      
    );
  }
 
  _resendCodeButton(Size size, BuildContext context){
    return InkWell(
      onTap: (){
       
      },
      child: Container(
        alignment: Alignment.center,
        // height: siz,
        // width: size.width,
        
        child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon(Icons.restore, color:  MyTheme.white,),
            Image.asset(SEND_AGAIN_ASSET,
            height:30,width: 30,),

            SizedBox(width: 10),

            Text("SEND AGAIN",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: MyTheme.white),
            )
          ],
        )
      ),
    );
  }
}











