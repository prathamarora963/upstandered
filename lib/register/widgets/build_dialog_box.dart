import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';

class IntroDialogBox extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
    height: size.height * 0.9,
    margin: EdgeInsets.only(left: 12, right: 12),
    padding: const EdgeInsets.all(0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Material(
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          IntroBody(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 8.0,top: 5),
              child: IconButton(
                  icon: Image.asset(CANCEL_ASSET),
                  onPressed: () {
                     Navigator.of(context).pop();
                    // Navigator.of(context).push(MaterialPageRoute(
                    //   builder: (context)=>MapViewScreen()));
                  }),
            ),
          )
        ],
      ),
    ));
  }
}

class IntroBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.02),
              Text("INTRODUCTION",
                  style: TextStyle(
                      fontSize: 20,
                      color: MyTheme.secondryColor,
                      fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.02),
              Text(
                "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla finibus nibh vitae ipsum volutpat tristique a quis purus. Nulla congue imperdiet leo sit amet eleifend. Aliquam malesuada accumsan erat, quis posuere mauris dapibus sed. Donec bibendum lacus ac lorem feugiat, sit amet egestas leo pellentesque. Morbi bibendum gravida varius. Praesent maximus id ante vel condimentum. Sed a ligula vitae odio viverra imperdiet. Sed pellentesque urna ut vulputate rhoncus. Aenean eget tincidunt velit. Pellentesque aliquet et erat nec porta.Sed odio tortor, euismod dictum scelerisque a, laoreet quis magna. Curabitur dignissim volutpat nisl, non pellentesque tortor semper mollis. Integer ornare dolor vel fringilla feugiat. Donec pellentesque risus faucibus, varius quam eget, pellentesque ante. Nulla ac felis venenatis, facilisis magna ac, venenatis nisl. Proin hendrerit mi quis massa egestas, vitae maximus mi aliquet. Aliquam accumsan, mi vitae malesuada ullamcorper, ligula justo pulvinar quam, sit amet lobortis eros massa id dui. Cras tortor nulla, pretium quis libero et, auctor eleifend neque. Nam nisl est, dapibus vel sem ac, euismod pellentesque purus. Nulla in dapibus diam. Proin faucibus, justo ac tincidunt suscipit, nisi ligula tempor metus, sit amet tincidunt orci lorem vitae velit. Pellentesque leo ex, maximus id nibh sit amet, convallis rutrum dui. Sed tempus purus sit amet ullamcorper feugiat Proin molestie tortor eget lorem sagittis, non pharetra lacus accumsan. Curabitur sit amet pellentesque diam. Proin gravida nisl urna, eget bibendum tortor porta id. Nam ut eleifend dui. Donec elit tellus, dignissim vitae sapien eu, bibendum vehicula quam.",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: MyTheme.secondryColor),
              )
            ],
          ),
        ));
  }
}
