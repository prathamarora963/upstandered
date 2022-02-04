import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:upstanders/common/theme/colors.dart';
import 'package:upstanders/home/data/model/profile_model.dart';
import 'dart:math' show cos, sqrt, asin;

import 'package:upstanders/home/data/nearby_users.dart';

Future<BitmapDescriptor> getMarkersImage(
    NearbyUsers nearbyUsers,
    ProfileModel prof,
    bool
        isAlertCreatingMode, // nearbyUser.image, nearbyUser.userId, "${nearbyUser.fname}"
    {String distance}) async {
  if (nearbyUsers.image != null) {
    final File markerImageFile =
        await DefaultCacheManager().getSingleFile(nearbyUsers.image);

    Size s = nearbyUsers.userId.toString() == prof.userId.toString()
        ? Size(150, 150)
        : Size(120, 120);

    Color avatarColor = isAlertCreatingMode
        ? nearbyUsers.userRole == "HELPEE"
            ? MyTheme.red
            : nearbyUsers.userRole == "HELPER"
                ? MyTheme.green
                : MyTheme.primaryColor
        : MyTheme.primaryColor; //MyTheme.primaryColorWithAlpha120

    var icon = nearbyUsers.userId.toString() == prof.userId.toString()
        ? await getMarkerIconWithImage(
            markerImageFile.path,
            s,
            nearbyUsers.firstName,
            avatarColor,
          )
        : createCustomMarkerBitmapWithNameAndImage(
            markerImageFile.path, s, nearbyUsers.firstName, avatarColor);

    return icon;
  } else {
    return BitmapDescriptor.defaultMarker;
  }
}

//BUILD CUSTOM MARKER IMAGE
Future<BitmapDescriptor> getMarkerIconWithImage(
    String imagePath, Size size, String name, Color avatarColor) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 2);

  final Paint shadowPaint = Paint()..color = avatarColor.withAlpha(120);
  // MyTheme.primaryColorWithAlpha120;
  final double shadowWidth = 15.0;
  final double borderWidth = 3.0;

  final double imageOffset = shadowWidth + borderWidth;

  // Add shadow circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint);

  // Oval for the image
  Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
      size.width - (imageOffset * 2), size.height - (imageOffset * 2));

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  // Add image
  ui.Image image = await getImageFromPath(
      imagePath); // Alternatively use your own method to get the image
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  // Convert image to bytes
  final ByteData byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

Future<ui.Image> getImageFromPath(String imagePath) async {
  File imageFile = File(imagePath);

  Uint8List imageBytes = imageFile.readAsBytesSync();

  final Completer<ui.Image> completer = new Completer();

  ui.decodeImageFromList(imageBytes, (ui.Image img) {
    return completer.complete(img);
  });

  return completer.future;
}

Future<BitmapDescriptor> createCustomMarkerBitmapWithNameAndImage(
    String imagePath, Size size, String name, Color avatarColor) async {
  TextSpan span = new TextSpan(
      style: new TextStyle(
        height: 1.2,
        color: Colors.black,
        fontSize: 30.0,
        fontWeight: FontWeight.bold,
      ),
      text: name);

  TextPainter tp = new TextPainter(
    text: span,
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  );
  tp.layout();

  ui.PictureRecorder recorder = new ui.PictureRecorder();
  Canvas canvas = new Canvas(recorder);

  //  //ADD SIMPLE CIRCLUE
  //   Paint CirclePaint = new Paint()
  //     ..color = MyTheme.primaryColor.withAlpha(180)
  //     ..style = PaintingStyle.fill
  //     ..strokeWidth = 1;
  //   canvas.drawCircle(Offset(80, 115), 60.0, CirclePaint);

  //OR

  final double shadowWidth = 15.0;
  final double borderWidth = 3.0;
  final double imageOffset = shadowWidth + borderWidth;

  final Radius radius = Radius.circular(size.width / 2);

  final Paint shadowCirclePaint = Paint()
    ..color =
        // avatarColor;
        avatarColor.withAlpha(180);

  // Add shadow circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(
            size.width / 15, size.width / 2, size.width, size.height), //7,1.4
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowCirclePaint);

  // TEXT BOX BACKGROUND
  Paint textBgBoxPaint = Paint()..color = avatarColor; //MyTheme.primaryColor;

  Rect rect = Rect.fromLTWH(
    0,
    0,
    tp.width + 35,
    50,
  );

  canvas.drawRRect(
    RRect.fromRectAndRadius(rect, Radius.circular(10.0)),
    textBgBoxPaint,
  );

  //ADD TEXT AND ALIGN TO CANVAS
  tp.paint(canvas, new Offset(20.0, 5.0));

  /* Do your painting of the custom icon here, including drawing text, shapes, etc. */
  print(
      "image offset image offset:$imageOffset LEFTTTTT:${size.width / 4.5} FROM TOP:${size.width / 1.55}");

  Rect oval = Rect.fromLTWH(
      size.width / 4.5,
      size.width / 1.55,
      // imageOffset,imageOffset,
      size.width - (imageOffset * 2), //35 ,78
      size.height - (imageOffset * 2));

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  ui.Image image = await getImageFromPath(
      imagePath); // Alternatively use your own method to get the image
  paintImage(canvas: canvas, image: image, rect: oval, fit: BoxFit.fitWidth);

  // Convert canvas to image
  // final ui.Image markerAsImage = await pictureRecorder
  //     .endRecording()
  //     .toImage(size.width.toInt(), size.height.toInt());

  // // Convert image to bytes
  // final ByteData byteData =
  //     await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  // final Uint8List uint8List = byteData.buffer.asUint8List();

  // return BitmapDescriptor.fromBytes(uint8List);

  ///other way

  ui.Picture p = recorder.endRecording();
  ByteData pngBytes = await (await p.toImage(300, 300))
      .toByteData(format: ui.ImageByteFormat.png);

  Uint8List data = Uint8List.view(pngBytes.buffer);

  return BitmapDescriptor.fromBytes(data);
}

//BUILD CUSTOM MARKER WITHOUT IMAGE
Future<BitmapDescriptor> getMarkerIconWithOutImage(
    Size size, String name) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);

  final Radius radius = Radius.circular(size.width / 2);

  final Paint shadowPaint = Paint()..color = MyTheme.primaryColorWithAlpha120;
  final double shadowWidth = 15.0;

  final Paint borderPaint = Paint()
    ..color = MyTheme.primaryColor; //Colors.white
  final double borderWidth = 45.0; //3.0

  final double imageOffset = shadowWidth + borderWidth;

  // Add shadow circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(0.0, 0.0, size.width, size.height),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      shadowPaint);

  // Add border circle
  canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(shadowWidth, shadowWidth, size.width - (shadowWidth * 2),
            size.height - (shadowWidth * 2)),
        topLeft: radius,
        topRight: radius,
        bottomLeft: radius,
        bottomRight: radius,
      ),
      borderPaint);

  // Oval for the image
  Rect oval = Rect.fromLTWH(imageOffset, imageOffset,
      size.width - (imageOffset * 2), size.height - (imageOffset * 2));

  // Add path for oval image
  canvas.clipPath(Path()..addOval(oval));

  // Convert canvas to image
  final ui.Image markerAsImage = await pictureRecorder
      .endRecording()
      .toImage(size.width.toInt(), size.height.toInt());

  // Convert image to bytes
  final ByteData byteData =
      await markerAsImage.toByteData(format: ui.ImageByteFormat.png);
  final Uint8List uint8List = byteData.buffer.asUint8List();

  return BitmapDescriptor.fromBytes(uint8List);
}

void paintText(Canvas canvas, String title) {
  final textStyle = TextStyle(
    color: Colors.white,
    fontSize: 24,
  );
  final textSpan = TextSpan(
    text: title,
    style: textStyle,
  );
  final textPainter = TextPainter(
    text: textSpan,
    textDirection: TextDirection.ltr,
  );
  textPainter.layout(
    minWidth: 0,
    maxWidth: 88,
  );
  final offset = Offset(48, 8);
  textPainter.paint(canvas, offset);
}

Future<Marker> getStartMarKer(Set<Marker> markers, ProfileModel prof) async {
  Marker startMar;

  markers.forEach((element) {
    if (element.markerId.value == prof.uniqueId) {
      startMar = element;
    }
  });
  return startMar;
}

Future<Marker> getDesMarKer(Set<Marker> markers, ProfileModel prof) async {
  Marker desMar;

  markers.forEach((element) {
    if (element.markerId.value != prof.uniqueId) {
      desMar = element;
    }
  });
  return desMar;
}

Future<LatLng> getStartLatLng(Set<Marker> markers, ProfileModel prof) async {
  LatLng startLatLng;

  markers.forEach((element) {
    if (element.markerId.value == prof.userId.toString()) {
      startLatLng = element.position;
    }
  });
  return startLatLng;
}

Future<LatLng> getDesLatLng(Set<Marker> markers, ProfileModel prof) async {
  LatLng desLatLng;

  markers.forEach((element) {
    if (element.markerId.value != prof.userId.toString()) {
      desLatLng = element.position;
    }
  });
  return desLatLng;
}

double coordinateDistance(lat1, lon1, lat2, lon2) {
  var p = 0.017453292519943295;
  var c = cos;
  var a = 0.5 -
      c((lat2 - lat1) * p) / 2 +
      c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
  return 12742 * asin(sqrt(a));
}
