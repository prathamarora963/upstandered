import 'package:flutter/material.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';

class AnimatedLogo extends StatefulWidget {
  final bool isSplash;

   AnimatedLogo({Key key, this.isSplash =  false}) : super(key: key);
  _AnimatedLogoExampleState createState() => _AnimatedLogoExampleState();
}

class _AnimatedLogoExampleState extends State<AnimatedLogo>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _animation;

  initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this, value: 0.1);
    _animation =
        CurvedAnimation(parent: _controller, curve: Curves.bounceInOut);

    _controller.forward();
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return ScaleTransition(
        scale: _animation, alignment: Alignment.center, child: widget.isSplash ?_SplashLogo():_Logo());
  }
}

class _Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      alignment: Alignment.center,
      height: size.height * 0.2,
      width: size.width * 0.4,
      decoration: BoxDecoration(
          color: MyTheme.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: MyTheme.transparent),
          image: DecorationImage(image: AssetImage(LOGO_ASSET))),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Center(
      child: Card(
        color: MyTheme.transparent,
        child: Image.asset(
          LOGO_ASSET,
          height: size.height * 0.25,
          width: size.width * 0.5,
        ),
        elevation: 8.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(32.0),
          ),
        ),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
