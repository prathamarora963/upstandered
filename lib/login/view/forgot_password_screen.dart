import 'package:flutter/material.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/login/constants/constants.dart';
import 'package:upstanders/login/view/forgot_password_form.dart';

class ForgotPasswordScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
       backgroundColor: MyTheme.secondryColor,
      appBar: AppBar(
        backgroundColor: MyTheme.primaryColor,
        automaticallyImplyLeading: false,
        title: Text(FORGOT_PASS_TEXT, style: TextStyle(
          color: MyTheme.secondryColor,
          fontSize :size.height * 0.03
        ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, 
          size: size.height * 0.04,
          color: MyTheme.secondryColor,
        ),
          onPressed: () =>  Navigator.of(context).pop(),
        ),
      ),
      body: ForgotPasswordForm(),
      
    );
  }
}