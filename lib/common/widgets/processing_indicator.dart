import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:shimmer/shimmer.dart';

class ProcessingIndicator extends StatelessWidget {
  final Color processColor;
  final double size;
  ProcessingIndicator({this.processColor, @required this.size});
  @override
  Widget build(BuildContext context) {
    print("START LOADING.... 🟠");
    return Transform.scale(
      scale:size,  //1.3
      child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              processColor == null ? MyTheme.primaryColor : processColor)),
    );
  }
}

class DeletionProcessBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
        child: Container(
      height: size.width * 0.3,
      width: size.width * 0.3,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: MyTheme.white54, borderRadius: BorderRadius.circular(6)),
      child: Lottie.asset('assets/animations/delete.json', repeat: true),
    ));
  }
}

class LottieLoadingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
        child: Container(
      height: size.width * 0.4,
      width: size.width * 0.4,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: MyTheme.white, borderRadius: BorderRadius.circular(6)),
      child: Lottie.asset('assets/animations/loading.json', repeat: true),
    ));
  }
}

class AudioPlayingBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.1,
      width: size.width * 0.1,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MyTheme.transparent,
      ),
      child: Lottie.asset('assets/animations/playing.json', repeat: true),
    );
  }
}

class LeadingAsset extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Image.asset(
      RECORD_AUDIO_ASSET,
      height: size.height * 0.08,
      width: size.height * 0.08,
    );
  }
}

class PauseButton extends StatelessWidget {
  final void Function() onPause;
  PauseButton({@required this.onPause});
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.8,
      width: size.height * 0.079,
      decoration: BoxDecoration(
          color: MyTheme.primaryColor, borderRadius: BorderRadius.circular(10)),
      child: IconButton(
        icon: Icon(
          Icons.pause,
          color: MyTheme.black,
        ),
        iconSize: 30.0,
        onPressed: onPause,
      ),
    );
  }
}

class ShimmerLoadingAudioList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        child: Shimmer.fromColors(
      baseColor: MyTheme.grey400,
      highlightColor: MyTheme.white,
      child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return ListTile(
                trailing: Image.asset(
                  VERTICAL_MENU_ASSET,
                  color: MyTheme.grey,
                  height: 20,
                  width: 20,
                ),
                contentPadding:
                    const EdgeInsets.only(top: 10, left: 10, right: 10),
                leading: Image.asset(
                  RECORD_AUDIO_ASSET,
                  // color: Colors.grey,
                  height: 60,
                  width: 60,
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.3,
                      height: 12,
                      color: MyTheme.grey,
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: size.width * 0.4,
                      height: 10,
                      color: MyTheme.grey,
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: size.width * 0.2,
                      height: 10,
                      color: MyTheme.grey,
                    ),
                  ],
                ));
          }),
    ));
  }
}

class ShimmerLoadingAlertList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        child: Shimmer.fromColors(
      baseColor: MyTheme.grey400,
      highlightColor: MyTheme.white,
      child: ListView.builder(
          itemCount: 12,
          itemBuilder: (context, index) {
            return ListTile(
                leading: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: MyTheme.grey, shape: BoxShape.circle),
                ),
                title: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: size.width * 0.2,
                      height: 12,
                      color: MyTheme.grey,
                    ),
                    SizedBox(height: 2),
                    Container(
                      width: size.width * 0.3,
                      height: 10,
                      color: MyTheme.grey,
                    ),
                  ],
                ));
          }),
    ));
  }
}
