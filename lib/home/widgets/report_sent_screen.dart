import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';

class ReportSentScreen extends StatefulWidget {
  @override
  _ReportSentScreenState createState() => _ReportSentScreenState();
}

class _ReportSentScreenState extends State<ReportSentScreen> {
   @override
  void initState() {
    super.initState();
    navigateToNextScreen();
  }

  navigateToNextScreen(){
    Future.delayed(Duration(seconds: 3), (){
      //  alertEndedNotified = false;
      //   isAcceptedNotified = false;
       Navigator.of(context).pop();
        Navigator.of(context).pop();
      
     
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _BG(),
          _Foreground()
        ],
      ),
      
    );
  }
}

class _BG extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(REPORT_SUBMIT_ASSET),
          fit: BoxFit.cover
        )
      ),
      
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
          Image.asset(REPORT_SENT_ASSET, 
          height: size.height * 0.2, width: size.height * 0.2,),
          SizedBox(height: size.height * 0.02,),

          Text(
            "Report sent",
            style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: MyTheme.white),
          ),

        ],
      ),
      
    );
  }
}