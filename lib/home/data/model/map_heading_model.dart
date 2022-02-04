import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapHeading {
  final Widget child;
  final LatLng location;

  MapHeading({this.child, this.location});
}