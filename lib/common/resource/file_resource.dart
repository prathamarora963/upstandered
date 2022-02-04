// import 'package:flutter_cache_manager/file.dart';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image/image.dart' as Im;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math' as Math;
// import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
//     as bg;

import 'package:permission_handler/permission_handler.dart';

import 'page_manager.dart';

final ImagePicker _picker = ImagePicker();

Future<File> pickImage(ImageSource source) async {
  try {
    final PickedFile pickedFile = await _picker.getImage(
      source: source,
    );
     print(
        "PICKED IMAGE FILE SIZE IN KBBB BEFORE COMPRESSION :${(File(pickedFile.path).readAsBytesSync().lengthInBytes) / 1024}");

    File croppedFile = await _cropImage(File(pickedFile.path));
     print(
        "CROPPED IMAGE FILE SIZE IN KBBB BEFORE COMPRESSION :${(File(pickedFile.path).readAsBytesSync().lengthInBytes) / 1024}");

   
    File compressesedImg =
        (File(croppedFile.path).readAsBytesSync().lengthInBytes) / 1024 <= 500
            ? File(pickedFile.path)
            : await compressImage(File(pickedFile.path));

    return compressesedImg;
  } catch (e) {
    print("EXCEPTION THROW WHILE GETTING IMAGE:$e");
    throw e;
  }
}

Future<File> compressImage(File imageFile) async {
  final tempDir = await getTemporaryDirectory();
  final path = tempDir.path;
  int rand = new Math.Random().nextInt(10000);

  Im.Image image = Im.decodeImage(imageFile.readAsBytesSync());
  // Im.Image smallerImage = Im.copyResize(
  //     image); // choose the size here, it will maintain aspect ratio

  var compressedImage = new File('$path/img_$rand.jpg')
    ..writeAsBytesSync(Im.encodeJpg(image, quality: 10));

  print(
      "COMPRESSES IMAGE FILE SIZE KB:${(compressedImage.readAsBytesSync().lengthInBytes) / 1024}");

  return compressedImage;
}

Future<Map<Permission, PermissionStatus>> requestPermission() async {
  Map<Permission, PermissionStatus> statuses = await [
    Permission.locationAlways,
    Permission.locationWhenInUse,
    Permission.location,
    Permission.notification
  ].request();
  return statuses;
}

Future<File> _cropImage(File imageFile) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ));
  return croppedFile;
}

Future<Position> checkpermission() async {
  Position position;
  var statuses = await requestPermission();
  print(statuses);
  if (statuses[Permission.locationAlways] == PermissionStatus.granted) {
    position = await getloc();
    return position;
  } else if (statuses[Permission.locationAlways] == PermissionStatus.denied) {
    return await checkpermission();
  } else {
    openAppSettings();
    return position;
  }
}

Future<Position> getloc() async {
  return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.best);
}

openAppSettingDialog(BuildContext context) {
  showDialog(
      context: context,
      builder: (BuildContext context) => CupertinoAlertDialog(
            title: Text('Location Permission'),
            content: Text('This app needs current location access'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text('Deny'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              CupertinoDialogAction(
                child: Text('Settings'),
                onPressed: () => openAppSettings(),
              ),
            ],
          ));
}

showAudioPlayer(
  BuildContext context,
  PageManager pageManager,
) {
  showGeneralDialog(
    barrierLabel: "Barrier",
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: Duration(milliseconds: 700),
    context: context,
    pageBuilder: (_, __, ___) {
      return Align(
          alignment: Alignment.center,
          child: Container(
              margin: EdgeInsets.only(
                top: 30,
              ),
              child: MusicPlayerr(pageManager)));
    },
    transitionBuilder: (_, anim, __, child) {
      return SlideTransition(
        position: Tween(begin: Offset(0, -1), end: Offset(0, 0)).animate(anim),
        child: child,
      );
    },
  );
}
