import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:upstanders/common/constants/constants.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'dart:ui' as ui;
import 'package:gallery_saver/gallery_saver.dart';

import 'package:upstanders/common/widgets/processing_indicator.dart';

class ProfileAvatar extends StatelessWidget {
  final String imageUrl;
  final File fileImage;
  final double avatarRadius;
  final double width;

  const ProfileAvatar(
      {Key key,
      @required this.imageUrl,
      @required this.avatarRadius,
      @required this.width,
      @required this.fileImage})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        height: avatarRadius,
        width: width,
        child: Stack(
          children: [
            Positioned(
              bottom: 10,
              left: 20,
              child: Container(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: MakeCircle(color: MyTheme.orange, radius: 15),
                ),
              ),
            ),
            Positioned(
              top: 20,
              right: 10,
              child: Container(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: MakeCircle(color: MyTheme.orange, radius: 20),
                ),
              ),
            ),
            Align(
                alignment: Alignment.center,
                child: fileImage == null
                    ? imageUrl != null
                        ? InkWell(
                            onTap: () => showImage(context, false),
                            child: CachedNetworkImage(
                              imageUrl: imageUrl,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                height: avatarRadius,
                                width: avatarRadius,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: MyTheme.white, width: 1),
                                    image: DecorationImage(
                                        image: imageProvider,
                                        fit: BoxFit.cover)),
                              ),
                              placeholder: (context, url) =>
                                  ProcessingIndicator(
                                size: size.height * 0.0015,
                              ),
                              errorWidget: (context, url, error) => Icon(
                                Icons.error,
                                color: MyTheme.red,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(3),
                            alignment: Alignment.center,
                            height: avatarRadius,
                            width: avatarRadius,
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border:
                                    Border.all(color: MyTheme.white, width: 2),
                                image: DecorationImage(
                                    image: AssetImage(DEFAULT_USER_IMAGE),
                                    fit: BoxFit.cover)),
                          )
                    : InkWell(
                        onTap: () => showImage(context, true),
                        child: Container(
                          height: avatarRadius,
                          width: avatarRadius,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border:
                                  Border.all(color: MyTheme.white, width: 1),
                              image: DecorationImage(
                                  image: FileImage(fileImage),
                                  fit: BoxFit.cover)),
                        ),
                      )),
            Positioned(
              top: 40,
              right: 0,
              child: Container(
                width: 20,
                height: 20,
                child: CustomPaint(
                  painter: MakeCircle(
                      color: Color(0xffFFC938).withOpacity(0.6), radius: 13),
                ),
              ),
            ),
          ],
        ));
  }

  showImage(BuildContext context, bool isFile) {
    final size = MediaQuery.of(context).size;
    showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: AspectRatio(
                  aspectRatio: 8 / 8,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Stack(
                      children: <Widget>[
                       isFile 
                       ? Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                              image: DecorationImage(
                                  image: FileImage(fileImage),
                                  fit: BoxFit.fill)),
                        )
                       : CachedNetworkImage(
                          imageUrl: imageUrl,
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                               borderRadius: BorderRadius.circular(20.0),
                                image: DecorationImage(
                                    image: imageProvider, fit: BoxFit.fill)),
                          ),
                          placeholder: (context, url) => ProcessingIndicator(
                            size: size.height * 0.0015,
                          ),
                          errorWidget: (context, url, error) => Icon(
                            Icons.error,
                            color: MyTheme.red,
                          ),
                        ),
                       
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: MyTheme.primaryColor,
                                border: Border(
                                  top: BorderSide(
                                      width: 2.0, color: Colors.black26),
                                ),
                              ),
                              child: isFile
                                  ? InkWell(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "CANCEL",
                                          style: TextStyle(
                                              color: Colors.blue,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "CANCEL",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                        VerticalDivider(
                                          thickness: 1,
                                          color: Colors.grey[300],
                                        ),
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Fluttertoast.showToast(
                                                  msg: "Downloading...");
                                              String path = imageUrl;
                                              GallerySaver.saveImage(path)
                                                  .then((bool success) {
                                                Fluttertoast.showToast(
                                                    msg: "Download Completed");
                                                print("DOWNLOADED COMPLETEED");
                                                Navigator.pop(context);
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              child: Text(
                                                "DOWNLOAD",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 20,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}

class MakeCircle extends CustomPainter {
  final Color color;
  final double radius;

  MakeCircle({this.color, this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    var position = Offset(size.width / 10, size.height / 10);
    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class GradientCircle extends CustomPainter {
  final Color color;
  final double radius;

  GradientCircle({this.color, this.radius});
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    paint.color = color;
    paint.shader = ui.Gradient.linear(
      Offset(0, 1),
      Offset(1, 0),
      [
        MyTheme.orange,
        MyTheme.primaryColor,
      ],
    );
    var position = Offset(size.width / 10, size.height / 10);
    canvas.drawCircle(position, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var paint1 = Paint()
      ..color = Color(0xff63aa65)
      ..style = PaintingStyle.fill;
    //a circle
    canvas.drawCircle(Offset(200, 200), 100, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}