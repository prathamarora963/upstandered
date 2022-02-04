import 'package:flutter/material.dart';
import 'package:upstanders/common/widgets/ripple_animation.dart';
import 'package:upstanders/common/widgets/user_avatar.dart';

class CustomMarker extends StatelessWidget {
  final String imageUrl;
  final double avatarRadius;
  final Color bgColor1;
  final Color bgColor2;

  const CustomMarker({Key key, @required this.imageUrl, @required this.avatarRadius, @required this.bgColor2,  @required this.bgColor1}) : super(key: key);
  @override
  
  Widget build(BuildContext context) {
    return Container(
       height: avatarRadius +10,
       width:avatarRadius +10,
       alignment: Alignment.center,
       decoration: BoxDecoration(
         color: bgColor1,
         shape: BoxShape.circle
       ),
       child: Container(
        height: avatarRadius +8,
        width: avatarRadius +8,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor2,
          shape: BoxShape.circle,


        ),
        child: UserAvatar(
          imageUrl: imageUrl, 
          avatarRadius: avatarRadius),
        
      ),
    );
  }
}

// Peer Custom Marker

class PeerCustomMarker extends StatelessWidget {
  final String imageUrl;
  final double avatarRadius;
  final Color bgColor1;
  final Color bgColor2;

  const PeerCustomMarker({Key key, @required this.imageUrl, @required this.avatarRadius, @required this.bgColor2,  @required this.bgColor1}) : super(key: key);
  @override
  
  Widget build(BuildContext context) {
    return Container(
       height: avatarRadius +10,
       width:avatarRadius +10,
       alignment: Alignment.center,
       decoration: BoxDecoration(
         color: bgColor1,
         shape: BoxShape.circle
       ),
       child: Container(
        height: avatarRadius +8,
        width: avatarRadius +8,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bgColor2,
          shape: BoxShape.circle,


        ),
        child: UserAvatar(
          imageUrl: imageUrl, 
          avatarRadius: avatarRadius),
        
      ),
    );
  }
}

// create custom marker with details
class BuildCustomMarker extends StatelessWidget {
   final String userName;
    final String userImage;
  final double size;
  final double userSize;
  final Color color;
  final void Function() onPressed;

  const BuildCustomMarker({Key key, this.size, this.userSize, this.color, this.onPressed, this.userName, this.userImage}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      // height: 100,
      // color: MyTheme.pink,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
               color: color,
               borderRadius: BorderRadius.circular(5)
            ),
            child: Text(userName, style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
          ),
          SizedBox(height:size/4),
           RipplesAnimation(
            userImage:userImage,
            size: size,
            userSize :userSize,
            color: color,
            onPressed: onPressed,
          ),
        ],
      ),
      
    );
  }
}