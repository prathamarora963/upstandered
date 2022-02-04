import 'dart:async';
import 'dart:io';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:upstanders/common/resource/file_resource.dart';
import 'package:upstanders/common/widgets/processing_indicator.dart';
import 'package:upstanders/home/bloc/home_bloc.dart';
import 'package:upstanders/home/constants/api_keys.dart';
import 'package:upstanders/home/view/home_screen.dart';

int updatedNearByUsersCount = 0;
GoogleMapController _controller;

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMap googleMap;
  Set<Marker> markers = {};
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      if (mounted) setState(() {});
    });
    // _updateNearByUsers();
  }

  _updateNearByUsers() {
    Timer.periodic(Duration(seconds: 15), (Timer t) {
      if (profileData.accountStatus == 'active' &&
          profileData.onlineStatus == 'online') {
        BlocProvider.of<MapScreenBloc>(context)
            .add(UpdateUserMarker(isAlertInCreatingMode: true));
      }
    });
  }

  //Draw multiroutes method from here

  drawMultiRoutes(Set<Marker> markerss) {
    print("MULTI DRAW");
    markerss.forEach((marker) async {
      if (marker.markerId.value != profileData.userId.toString()) {
        _calculateDistance(
          marker,
        );
      }
    });
  }

  // Method for calculating the distance between two places
  Future<bool> _calculateDistance(
    Marker marker,
  ) async {
    try {
      double startLatitude = (await getloc()).latitude;

      double startLongitude = (await getloc()).longitude;

      double destinationLatitude = marker.position.latitude;
      double destinationLongitude = marker.position.longitude;
      String polyID =
          "${profileData.userId.toString()}${marker.markerId.value}";
      //       print(
      //   'POLYLINE ID: $polyID)',
      // );

      // print(
      //   'START COORDINATES: ($startLatitude, $startLongitude)',
      // );
      // print(
      //   'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
      // );

      // Calculating to check that the position relative
      // to the frame, and pan & zoom the camera accordingly.
      double miny = (startLatitude <= destinationLatitude)
          ? startLatitude
          : destinationLatitude;
      double minx = (startLongitude <= destinationLongitude)
          ? startLongitude
          : destinationLongitude;
      double maxy = (startLatitude <= destinationLatitude)
          ? destinationLatitude
          : startLatitude;
      double maxx = (startLongitude <= destinationLongitude)
          ? destinationLongitude
          : startLongitude;

      double southWestLatitude = miny;
      double southWestLongitude = minx;

      double northEastLatitude = maxy;
      double northEastLongitude = maxx;

      // Accommodate the two locations within the
      // camera view of the map
      _controller.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(northEastLatitude, northEastLongitude),
            southwest: LatLng(southWestLatitude, southWestLongitude),
          ),
          18.0,
        ),
      );

      await _createPolylines(startLatitude, startLongitude, destinationLatitude,
          destinationLongitude, polyID);

      return true;
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Create the polylines for showing the route between two places
  _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      String polyId) async {
    print(
      'POLYLINE ID: $polyId)',
    );
    print(
      'START COORDINATES: ($startLatitude, $startLongitude)',
    );
    print(
      'DESTINATION COORDINATES: ($destinationLatitude, $destinationLongitude)',
    );

    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.walking,
    );

    print(
        " result.status  result.status  result.status  result.status:${result.status}");
    print(
        " errorMessage errorMessage errorMessage errorMessage_____________:${result.errorMessage}");

    print("_createPolylines::::" + result.points.length.toString());

    if (result.points.isNotEmpty) {
      print("polylineCoordinates::before" + polylineCoordinates.toString());
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
      print("polylineCoordinates:: After" + polylineCoordinates.toString());
    }

    PolylineId id = PolylineId(polyId);
    Polyline polyline = await _buildPolyline(id, polylineCoordinates);

    setState(() {
      polylines[id] = polyline;
    });

    print("POLYLINES LENGTH:${polylines.length}");
  }

  Future<Polyline> _buildPolyline(
      PolylineId polylineId, List<LatLng> polylineCoordinates) async {
    Polyline polyline = Polyline(
      polylineId: polylineId,
      patterns: [PatternItem.dash(8), PatternItem.gap(8)],
      color: Colors.black,
      points: polylineCoordinates,
      width: 3,
      startCap: Cap.roundCap,
      endCap: Cap.roundCap,
    );
    return polyline;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return FutureBuilder(
        future: getloc(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
                child: ProcessingIndicator(
              size: size.height * 0.0015,
            ));
          }
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          Position position = snapshot.data;
          print("Current location map screen:$position");

          BlocProvider.of<MapScreenBloc>(context).currentLocation = position;

          return _blocView(position);
        });
  }

  _blocView(Position position) {
    return BlocListener<MapScreenBloc, MapScreenState>(
      listener: (context, state) {
        if (state is BuildingMarkersFailed) {
          Fluttertoast.showToast(msg: "${state.error}");
        }

        if (state is BuiltMarkers) {
          Set<Marker> getMarkers = state.markers;

          drawMultiRoutes(getMarkers);
        }
      },
      child: BlocBuilder<MapScreenBloc, MapScreenState>(
        builder: (context, state) {
          bool isloadingMarkers =
              BlocProvider.of<MapScreenBloc>(context).loadMarkers;
          _controller = BlocProvider.of<MapScreenBloc>(context).mapController;
          Set<Marker> builtmarkers =
              BlocProvider.of<MapScreenBloc>(context).builtmarkers;

          return _showMap(position, builtmarkers, isloadingMarkers);
        },
      ),
    );
  }

  _showMap(
    Position position,
    Set<Marker> markers,
    bool isLoading,
  ) {
    final size = MediaQuery.of(context).size;
    return Stack(
      children: [
        googleMap = GoogleMap(
          myLocationButtonEnabled: false,
          compassEnabled: false,
          zoomControlsEnabled: false,
          mapType: MapType.normal,
          initialCameraPosition:
              BlocProvider.of<MapScreenBloc>(context).initialCameraPosition(),
          polylines: Set<Polyline>.of(polylines.values),
          onMapCreated: BlocProvider.of<MapScreenBloc>(context).onMapCreated,
          myLocationEnabled: true,
          markers: markers,
        ),
        Align(
            alignment: Alignment.center,
            child: isLoading
                ? ProcessingIndicator(
                    size: size.height * 0.0015,
                  )
                : Container())
      ],
    );
  }
}
