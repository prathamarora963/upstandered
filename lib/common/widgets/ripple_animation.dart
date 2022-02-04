import 'package:flutter/material.dart';
import 'package:upstanders/common/widgets/circle_painter.dart';
import 'dart:math' as math show sin, pi;
import 'package:flutter/animation.dart';
import 'package:upstanders/common/widgets/user_avatar.dart';

class RipplesAnimation extends StatefulWidget {
  const RipplesAnimation({Key key, this.size = 70.0, this.color =  Colors.red,
    this.onPressed,this.userSize, this.userImage
    //  @required this.child,
     }) : super(key: key);
  final double size;
  final double userSize;
  final Color color;
  // final Widget child;
  final VoidCallback onPressed;
   final String userImage;
  @override
  _RipplesAnimationState createState() => _RipplesAnimationState();
}

class _RipplesAnimationState extends State<RipplesAnimation> with TickerProviderStateMixin {
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat();
  }
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
  Widget _button() {
    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.size),
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: <Color>[
                widget.color,
                Color.lerp(widget.color, Colors.black, .05)
              ],
            ),
          ),
          child: ScaleTransition(
              scale: Tween(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: _controller,
                  curve: const CurveWave(),
                ),
              ),
              child: 
              UserAvatarAsset( //UserAvatar
              asset:
                 widget.userImage,
              avatarRadius: widget.userSize),
              // Icon(Icons.speaker_phone, size: 44,)
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: CustomPaint(
          painter: CirclePainterr(
            _controller,
            color: widget.color,
          ),
          child: SizedBox(
            width: widget.size * 4.125,
            // height: widget.size * 4.125,
            child: _button(),
          ),
        ),
     
    );
  }
}

class CurveWave extends Curve {
  const CurveWave();
  @override
  double transform(double t) {
    if (t == 0 || t == 1) {
      return 0.01;
    }
    return math.sin(t * math.pi);
  }
}