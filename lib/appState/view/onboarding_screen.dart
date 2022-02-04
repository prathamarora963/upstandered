import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:upstanders/appState/constants/constants.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/login/view/view.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final int _numPages = 7;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  int staticIndex = 0;

  List<Widget> _buildPageIndicator(Size size) {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(
          i == _currentPage ? _indicator(true, size) : _indicator(false, size));
    }
    return list;
  }

  Widget _indicator(bool isActive, Size size) {
    double margin = size.height * 0.010;
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: margin),
      height: size.height * 0.015,
      width: size.height * 0.015, //isActive?  8.0 : 8.0,
      decoration: BoxDecoration(
          color: isActive ? Colors.black : MyTheme.primaryColor,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.all(color: MyTheme.black)),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: MyTheme.primaryColor,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          decoration: BoxDecoration(color: MyTheme.primaryColor),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                  child: PageView(
                      physics: ClampingScrollPhysics(),
                      controller: _pageController,
                      onPageChanged: (int page) {
                        setState(() {
                          _currentPage = page;
                        });
                        if (staticIndex < _currentPage + 1) {
                          print("RIGHT");
                          setState(() {
                            staticIndex++;
                          });
                        } else {
                           setState(() {
                            staticIndex--;
                          });
                          print("LEFT");
                        }
                      },
                      children: <Widget>[
                    OnBoardingWidget(
                        fontSize: size.height * 0.025,//26
                        asset: On_BOARDING_ASSET_1,
                        text: ON_BOARDING_TEXT_1),
                    OnBoardingWidget(
                        fontSize: size.height * 0.026,
                        asset: On_BOARDING_ASSET_2,
                        text: ON_BOARDING_TEXT_2),
                    OnBoardingWidget(
                        fontSize: size.height * 0.026, //27
                        asset: On_BOARDING_ASSET_2,
                        text: ON_BOARDING_TEXT_3),
                    OnBoardingWidget(
                      fontSize: size.height * 0.027,
                      asset: On_BOARDING_ASSET_4,
                      text: ON_BOARDING_TEXT_4,
                    ),
                    OnBoardingWidget(
                        fontSize: size.height * 0.026,
                        asset: On_BOARDING_ASSET_5,
                        text: ON_BOARDING_TEXT_5),
                    OnBoardingWidget(
                        fontSize: size.height * 0.027,
                        asset: On_BOARDING_ASSET_6,
                        text: ON_BOARDING_TEXT_6),
                    GestureDetector(
                      onHorizontalDragUpdate: (details) {
                        int sensitivity = 8;
                        if (details.delta.dx > sensitivity) {
                          // Right Swipe
                        } else if (details.delta.dx < -sensitivity) {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              '/login', (route) => false);
                        }
                      },
                      child: OnBoardingWidget(
                        fontSize: size.height * 0.025, //26
                        asset: On_BOARDING_ASSET_7,
                        text: ON_BOARDING_TEXT_7,
                      ),
                    ),
                  ])),
              Container(
                alignment: Alignment.center,
                height: size.height * 0.050, //60
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildPageIndicator(size),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoardingWidget extends StatelessWidget {
  final double fontSize;
  final String text;
  final String asset;

  const OnBoardingWidget({Key key, this.text, this.asset, this.fontSize})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    var fromTop = size.height * 0.038; //30
    var paddingLeftRight = size.height * 0.020; //15
    return Container(
      padding: EdgeInsets.only(left: paddingLeftRight, right: paddingLeftRight),
      margin: EdgeInsets.only(top: fromTop),
      child: Column(
        children: [
          Expanded(
            child: Container(
                child: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(fromTop),
                topRight: Radius.circular(fromTop),
              ),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(fromTop),
                    border: Border.all(color: MyTheme.black),
                    image: DecorationImage(
                        image: AssetImage(asset), fit: BoxFit.fill)),
              ),
            )),
          ),
          SizedBox(height: size.height * 0.01),
          Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
                height: 1.2,
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: MyTheme.secondryColor),
          ),
        ],
      ),
    );
  }
}
